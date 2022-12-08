import 'dart:convert';

import 'package:flutter/widgets.dart' hide Element;
import 'package:go_router/go_router.dart';
import 'package:html/dom.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/library/user_local_tracks.dart';
import 'package:spotube/models/logger.dart';
import 'package:http/http.dart' as http;
import 'package:spotube/models/lyrics.dart';
import 'package:spotube/models/spotify_spotube_credentials.dart';
import 'package:spotube/models/spotube_track.dart';
import 'package:spotube/models/generated_secrets.dart';
import 'package:spotube/utils/primitive_utils.dart';
import 'package:collection/collection.dart';
import 'package:html/parser.dart' as parser;

abstract class ServiceUtils {
  static final logger = getLogger("ServiceUtils");

  static String clearArtistsOfTitle(String title, List<String> artists) {
    return title
        .replaceAll(RegExp(artists.join("|"), caseSensitive: false), "")
        .trim();
  }

  static String getTitle(
    String title, {
    List<String> artists = const [],
    bool onlyCleanArtist = false,
  }) {
    final match = RegExp(r"(?<=\().+?(?=\))").firstMatch(title)?.group(0);
    final artistInBracket =
        artists.any((artist) => match?.contains(artist) ?? false);

    if (artistInBracket) {
      title = title.replaceAll(
        RegExp(" *\\([^)]*\\) *"),
        '',
      );
    }

    title = clearArtistsOfTitle(title, artists);
    if (onlyCleanArtist) {
      artists = [];
    }

    return "$title ${artists.map((e) => e.replaceAll(",", " ")).join(", ")}"
        .toLowerCase()
        .replaceAll(RegExp(" *\\[[^\\]]*]"), '')
        .replaceAll(RegExp("feat.|ft."), '')
        .replaceAll(RegExp("\\s+"), ' ')
        .trim();
  }

  static Future<String?> extractLyrics(Uri url) async {
    try {
      var response = await http.get(url);

      Document document = parser.parse(response.body);
      var lyrics = document.querySelector('div.lyrics')?.text.trim();
      if (lyrics == null) {
        lyrics = "";
        document
            .querySelectorAll("div[class^=\"Lyrics__Container\"]")
            .forEach((element) {
          if (element.text.trim().isNotEmpty) {
            var snippet = element.innerHtml.replaceAll("<br>", "\n").replaceAll(
                  RegExp("<(?!\\s*br\\s*\\/?)[^>]+>", caseSensitive: false),
                  "",
                );
            var el = document.createElement("textarea");
            el.innerHtml = snippet;
            lyrics = "$lyrics${el.text.trim()}\n\n";
          }
        });
      }

      return lyrics;
    } catch (e, stack) {
      logger.e("extractLyrics", e, stack);
      rethrow;
    }
  }

  static Future<List?> searchSong(
    String title,
    List<String> artist, {
    String? apiKey,
    bool optimizeQuery = false,
    bool authHeader = false,
  }) async {
    try {
      if (apiKey == "" || apiKey == null) {
        apiKey = PrimitiveUtils.getRandomElement(lyricsSecrets);
      }
      const searchUrl = 'https://api.genius.com/search?q=';
      String song =
          optimizeQuery ? getTitle(title, artists: artist) : "$title $artist";

      String reqUrl = "$searchUrl${Uri.encodeComponent(song)}";
      Map<String, String> headers = {"Authorization": 'Bearer $apiKey'};
      final response = await http.get(
        Uri.parse(authHeader ? reqUrl : "$reqUrl&access_token=$apiKey"),
        headers: authHeader ? headers : null,
      );
      Map data = jsonDecode(response.body)["response"];
      if (data["hits"]?.length == 0) return null;
      List results = data["hits"]?.map((val) {
        return <String, dynamic>{
          "id": val["result"]["id"],
          "full_title": val["result"]["full_title"],
          "albumArt": val["result"]["song_art_image_url"],
          "url": val["result"]["url"],
          "author": val["result"]["primary_artist"]["name"],
        };
      }).toList();
      return results;
    } catch (e, stack) {
      logger.e("searchSong", e, stack);
      rethrow;
    }
  }

  static Future<String?> getLyrics(
    String title,
    List<String> artists, {
    required String apiKey,
    bool optimizeQuery = false,
    bool authHeader = false,
  }) async {
    try {
      final results = await searchSong(
        title,
        artists,
        apiKey: apiKey,
        optimizeQuery: optimizeQuery,
        authHeader: authHeader,
      );
      if (results == null) return null;
      title = getTitle(
        title,
        artists: artists,
        onlyCleanArtist: true,
      ).trim();
      final ratedLyrics = results.map((result) {
        final gTitle = (result["full_title"] as String).toLowerCase();
        int points = 0;
        final hasTitle = gTitle.contains(title);
        final hasAllArtists =
            artists.every((artist) => gTitle.contains(artist.toLowerCase()));
        final String lyricAuthor = result["author"].toLowerCase();
        final fromOriginalAuthor =
            lyricAuthor.contains(artists.first.toLowerCase());

        for (final criteria in [
          hasTitle,
          hasAllArtists,
          fromOriginalAuthor,
        ]) {
          if (criteria) points++;
        }
        return {"result": result, "points": points};
      }).sorted(
        (a, b) => ((a["points"] as int).compareTo(a["points"] as int)),
      );
      final worthyOne = ratedLyrics.first["result"];

      String? lyrics = await extractLyrics(Uri.parse(worthyOne["url"]));
      return lyrics;
    } catch (e, stack) {
      logger.e("getLyrics", e, stack);
      return null;
    }
  }

  static const baseUri = "https://www.rentanadviser.com/subtitles";

  static Future<SubtitleSimple?> getTimedLyrics(SpotubeTrack track) async {
    final artistNames =
        track.artists?.map((artist) => artist.name!).toList() ?? [];
    final query = getTitle(
      track.name!,
      artists: artistNames,
    );

    logger.v("[Searching Subtitle] $query");

    final searchUri = Uri.parse("$baseUri/subtitles4songs.aspx").replace(
      queryParameters: {"q": query},
    );

    final res = await http.get(searchUri);
    final document = parser.parse(res.body);
    final results =
        document.querySelectorAll("#tablecontainer table tbody tr td a");

    final rateSortedResults = results.map((result) {
      final title = result.text.trim().toLowerCase();
      int points = 0;
      final hasAllArtists = track.artists
              ?.map((artist) => artist.name!)
              .every((artist) => title.contains(artist.toLowerCase())) ??
          false;
      final hasTrackName = title.contains(track.name!.toLowerCase());
      final isNotLive = !PrimitiveUtils.containsTextInBracket(title, "live");
      final exactYtMatch = title == track.ytTrack.title.toLowerCase();
      if (exactYtMatch) points = 7;
      for (final criteria in [hasTrackName, hasAllArtists, isNotLive]) {
        if (criteria) points++;
      }
      return {"result": result, "points": points};
    }).sorted((a, b) => (b["points"] as int).compareTo(a["points"] as int));

    // not result was found at all
    if (rateSortedResults.first["points"] == 0) {
      logger.e("[Subtitle not found] ${track.name}");
      return Future.error("Subtitle lookup failed", StackTrace.current);
    }

    final topResult = rateSortedResults.first["result"] as Element;
    final subtitleUri =
        Uri.parse("$baseUri/${topResult.attributes["href"]}&type=lrc");

    logger.v("[Selected subtitle] ${topResult.text} | $subtitleUri");

    final lrcDocument = parser.parse((await http.get(subtitleUri)).body);
    final lrcList = lrcDocument
            .querySelector("#ctl00_ContentPlaceHolder1_lbllyrics")
            ?.innerHtml
            .replaceAll(RegExp(r'<h3>.*</h3>'), "")
            .split("<br>")
            .map((e) {
          e = e.trim();
          final regexp = RegExp(r'\[.*\]');
          final timeStr = regexp
              .firstMatch(e)
              ?.group(0)
              ?.replaceAll(RegExp(r'\[|\]'), "")
              .trim()
              .split(":");
          final minuteSeconds = timeStr?.last.split(".");

          return LyricSlice(
              time: Duration(
                minutes: int.parse(timeStr?.first ?? "0"),
                seconds: int.parse(minuteSeconds?.first ?? "0"),
                milliseconds: int.parse(minuteSeconds?.last ?? "0"),
              ),
              text: e.split(regexp).last);
        }).toList() ??
        [];

    final subtitle = SubtitleSimple(
      name: topResult.text.trim(),
      uri: subtitleUri,
      lyrics: lrcList,
      rating: rateSortedResults.first["points"] as int,
    );

    return subtitle;
  }

  static Future<SpotifySpotubeCredentials> getAccessToken(
      String cookieHeader) async {
    try {
      final res = await http.get(
        Uri.parse(
          "https://open.spotify.com/get_access_token?reason=transport&productType=web_player",
        ),
        headers: {
          "Cookie": cookieHeader,
          "User-Agent":
              "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/105.0.0.0 Safari/537.36"
        },
      );
      return SpotifySpotubeCredentials.fromJson(
        jsonDecode(res.body),
      );
    } catch (e, stack) {
      logger.e("getAccessToken", e, stack);
      rethrow;
    }
  }

  static void navigate(BuildContext context, String location, {Object? extra}) {
    GoRouter.of(context).push(location, extra: extra);
  }

  static List<T> sortTracks<T extends Track>(List<T> tracks, SortBy sortBy) {
    if (sortBy == SortBy.none) return tracks;
    return List<T>.from(tracks)
      ..sort((a, b) {
        switch (sortBy) {
          case SortBy.album:
            return a.album?.name?.compareTo(b.album?.name ?? "") ?? 0;
          case SortBy.artist:
            return a.artists?.first.name
                    ?.compareTo(b.artists?.first.name ?? "") ??
                0;
          case SortBy.ascending:
            return a.name?.compareTo(b.name ?? "") ?? 0;
          case SortBy.dateAdded:
            final aDate =
                double.parse(a.album?.releaseDate?.split("-").first ?? "2069");
            final bDate =
                double.parse(b.album?.releaseDate?.split("-").first ?? "2069");
            return aDate.compareTo(bDate);
          case SortBy.descending:
            return b.name?.compareTo(a.name ?? "") ?? 0;
          default:
            return 0;
        }
      });
  }
}
