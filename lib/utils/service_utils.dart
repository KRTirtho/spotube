import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart' hide Element;
import 'package:go_router/go_router.dart';
import 'package:html/dom.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/library/user_local_tracks.dart';
import 'package:spotube/models/logger.dart';
import 'package:http/http.dart' as http;
import 'package:spotube/models/lyrics.dart';
import 'package:spotube/services/sourced_track/sourced_track.dart';

import 'package:spotube/utils/primitive_utils.dart';
import 'package:collection/collection.dart';
import 'package:html/parser.dart' as parser;

abstract class ServiceUtils {
  static final logger = getLogger("ServiceUtils");

  static final _englishMatcherRegex = RegExp(
    "^[a-zA-Z0-9\\s!\"#\$%&\\'()*+,-.\\/:;<=>?@\\[\\]^_`{|}~]*\$",
  );
  static bool onlyContainsEnglish(String text) {
    return _englishMatcherRegex.hasMatch(text);
  }

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
        .replaceAll(RegExp(r"\s*\[[^\]]*]"), ' ')
        .replaceAll(RegExp(r"\sfeat\.|\sft\."), ' ')
        .replaceAll(RegExp(r"\s+"), ' ')
        .trim();
  }

  static Future<String?> extractLyrics(Uri url) async {
    final response = await http.get(url);

    Document document = parser.parse(response.body);
    String? lyrics = document.querySelector('div.lyrics')?.text.trim();
    if (lyrics == null) {
      lyrics = "";
      document
          .querySelectorAll("div[class^=\"Lyrics__Container\"]")
          .forEach((element) {
        if (element.text.trim().isNotEmpty) {
          final snippet = element.innerHtml.replaceAll("<br>", "\n").replaceAll(
                RegExp("<(?!\\s*br\\s*\\/?)[^>]+>", caseSensitive: false),
                "",
              );
          final el = document.createElement("textarea");
          el.innerHtml = snippet;
          lyrics = "$lyrics${el.text.trim()}\n\n";
        }
      });
    }

    return lyrics;
  }

  @Deprecated("In favor spotify lyrics api, this isn't needed anymore")
  static Future<List?> searchSong(
    String title,
    List<String> artist, {
    String? apiKey,
    bool optimizeQuery = false,
    bool authHeader = false,
  }) async {
    if (apiKey == "" || apiKey == null) {
      apiKey = PrimitiveUtils.getRandomElement(/* lyricsSecrets */ []);
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
  }

  static Future<String?> getGeniusLyrics(
      {required String title, required List<String> artists}) async {
    //Requires a non-blacklisted, valid User Agent. Or else, cloudflare might throw a 403.
    Map<String, String> headers = {
      HttpHeaders.userAgentHeader:
          "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/117.0.0.0 Safari/537.36 Edg/117.0.2045.4",
    };

    final searchResultResponse = await http.get(
        Uri.parse(
            "https://genius.com/api/search/multi?q=${title.replaceAll(RegExp(r"(\(.*\))"), "")} ${artists[0]}"),
        headers: headers);
    final searchResultObj = jsonDecode(searchResultResponse.body);
    String topResultPath;
    try {
      topResultPath = searchResultObj["response"]["sections"][0]["hits"][0]
          ["result"]["path"] as String;
      logger.t("topResultUrl: https://genius.com$topResultPath");
    } catch (e) {
      //logger.e(e);
      throw "topResultPath not found!";
    }
    final lyrics =
        await extractLyrics(Uri.parse("https://genius.com$topResultPath"));

    return lyrics?.trim();
  }

  static Future<String?> getAZLyrics(
      {required String title, required List<String> artists}) async {
    const Map<String, String> headers = {
      HttpHeaders.userAgentHeader:
          "Mozilla/5.0 (Linux i656 ; en-US) AppleWebKit/601.49 (KHTML, like Gecko) Chrome/51.0.1145.334 Safari/600"
    };

    //Will throw error 400 when you request the script without the host header
    const Map<String, String> headersForScript = {
      HttpHeaders.userAgentHeader:
          "Mozilla/5.0 (Linux i656 ; en-US) AppleWebKit/601.49 (KHTML, like Gecko) Chrome/51.0.1145.334 Safari/600",
      HttpHeaders.hostHeader: "www.azlyrics.com",
    };

    final azLyricsGeoScript = await http.get(
        Uri.parse("https://www.azlyrics.com/geo.js"),
        headers: headersForScript);

    RegExp scriptValueRegex = RegExp(r'\.setAttribute\("value", "(.*)"\);');
    RegExp scriptNameRegex = RegExp(r'\.setAttribute\("name", "(.*)"\);');
    final String? v =
        scriptValueRegex.firstMatch(azLyricsGeoScript.body)?.group(1);
    final String? x =
        scriptNameRegex.firstMatch(azLyricsGeoScript.body)?.group(1);

    logger.t("Additional URL params: $x=$v");

    final suggestionUrl = Uri.parse(
        "https://search.azlyrics.com/suggest.php?q=${title.replaceAll(RegExp(r"(\(.*\))"), "")} ${artists[0]}&${x.toString()}=${v.toString()}");

    final searchResponse = await http.get(suggestionUrl, headers: headers);
    if (searchResponse.statusCode != 200) {
      throw "searchResponse = ${searchResponse.statusCode}";
    }

    final Map searchResult = jsonDecode(searchResponse.body);

    String bestLyricsURL;

    try {
      bestLyricsURL = searchResult["songs"][0]["url"];
      logger.t("bestLyricsURL: $bestLyricsURL");
    } catch (e) {
      throw "No best Lyrics URL";
    }

    final lyricsResponse =
        await http.get(Uri.parse(bestLyricsURL), headers: headers);

    if (lyricsResponse.statusCode != 200) {
      throw "lyricsResponse = ${lyricsResponse.statusCode}";
    }

    var document = parser.parse(lyricsResponse.body);
    var lyricsDiv = document.querySelectorAll(
        "body > div.container.main-page > div.row > div.col-xs-12.col-lg-8.text-center > div");

    if (lyricsDiv.isEmpty) throw "lyricsDiv is empty";

    final String lyrics = lyricsDiv[4].text;

    return lyrics.trim();
  }

  @Deprecated("In favor spotify lyrics api, this isn't needed anymore")
  static Future<String?> getLyrics(
    String title,
    List<String> artists, {
    required String apiKey,
    bool optimizeQuery = false,
    bool authHeader = false,
  }) async {
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
  }

  @Deprecated("In favor spotify lyrics api, this isn't needed anymore")
  static const baseUri = "https://www.rentanadviser.com/subtitles";

  @Deprecated("In favor spotify lyrics api, this isn't needed anymore")
  static Future<SubtitleSimple?> getTimedLyrics(SourcedTrack track) async {
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
      final exactYtMatch = title == track.sourceInfo.title.toLowerCase();
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

  static void navigate(BuildContext context, String location, {Object? extra}) {
    if (GoRouterState.of(context).matchedLocation == location) return;
    GoRouter.of(context).go(location, extra: extra);
  }

  static void push(BuildContext context, String location, {Object? extra}) {
    final router = GoRouter.of(context);
    final routerState = GoRouterState.of(context);
    final routerStack = router.routerDelegate.currentConfiguration.matches
        .map((e) => e.matchedLocation);

    if (routerState.matchedLocation == location ||
        routerStack.contains(location)) return;
    router.push(location, extra: extra);
  }

  static DateTime parseSpotifyAlbumDate(AlbumSimple? album) {
    if (album == null || album.releaseDate == null) {
      return DateTime.parse("1975-01-01");
    }

    switch (album.releaseDatePrecision ?? DatePrecision.year) {
      case DatePrecision.day:
        return DateTime.parse(album.releaseDate!);
      case DatePrecision.month:
        return DateTime.parse("${album.releaseDate}-01");
      case DatePrecision.year:
        return DateTime.parse("${album.releaseDate}-01-01");
    }
  }

  static List<T> sortTracks<T extends Track>(List<T> tracks, SortBy sortBy) {
    if (sortBy == SortBy.none) return tracks;
    return List<T>.from(tracks)
      ..sort((a, b) {
        switch (sortBy) {
          case SortBy.ascending:
            return a.name?.compareTo(b.name ?? "") ?? 0;
          case SortBy.descending:
            return b.name?.compareTo(a.name ?? "") ?? 0;
          case SortBy.newest:
            final aDate = parseSpotifyAlbumDate(a.album);
            final bDate = parseSpotifyAlbumDate(b.album);
            return bDate.compareTo(aDate);
          case SortBy.oldest:
            final aDate = parseSpotifyAlbumDate(a.album);
            final bDate = parseSpotifyAlbumDate(b.album);
            return aDate.compareTo(bDate);
          case SortBy.duration:
            return a.durationMs?.compareTo(b.durationMs ?? 0) ?? 0;
          case SortBy.artist:
            return a.artists?.first.name?.compareTo(b.artists?.first.name ?? "") ?? 0;
          case SortBy.album:
            return a.album?.name?.compareTo(b.album?.name ?? "") ?? 0;
          default:
            return 0;
        }
      });
  }
}
