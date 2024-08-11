import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';
import 'package:html/dom.dart' hide Text;
import 'package:spotify/spotify.dart';
import 'package:spotube/modules/library/user_local_tracks.dart';
import 'package:spotube/modules/root/update_dialog.dart';

import 'package:spotube/models/lyrics.dart';
import 'package:spotube/provider/database/database.dart';
import 'package:spotube/services/dio/dio.dart';
import 'package:spotube/services/sourced_track/sourced_track.dart';

import 'package:spotube/utils/primitive_utils.dart';
import 'package:collection/collection.dart';
import 'package:html/parser.dart' as parser;

import 'dart:async';

import 'package:flutter/material.dart' hide Element;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:spotube/collections/env.dart';

import 'package:version/version.dart';

abstract class ServiceUtils {
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
    final response = await globalDio.getUri(
      url,
      options: Options(responseType: ResponseType.plain),
    );

    Document document = parser.parse(response.data);
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
    final response = await globalDio.getUri(
      Uri.parse(authHeader ? reqUrl : "$reqUrl&access_token=$apiKey"),
      options: Options(
        headers: authHeader ? headers : null,
        responseType: ResponseType.json,
      ),
    );
    Map data = response.data["response"];
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

    final searchUri = Uri.parse("$baseUri/subtitles4songs.aspx").replace(
      queryParameters: {"q": query},
    );

    final res = await globalDio.getUri(
      searchUri,
      options: Options(responseType: ResponseType.plain),
    );
    final document = parser.parse(res.data);
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
      return Future.error("Subtitle lookup failed", StackTrace.current);
    }

    final topResult = rateSortedResults.first["result"] as Element;
    final subtitleUri =
        Uri.parse("$baseUri/${topResult.attributes["href"]}&type=lrc");

    final lrcDocument = parser.parse((await globalDio.getUri(
      subtitleUri,
      options: Options(responseType: ResponseType.plain),
    ))
        .data);
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
      provider: "Rent An Adviser",
    );

    return subtitle;
  }

  static void navigate(BuildContext context, String location, {Object? extra}) {
    if (GoRouterState.of(context).matchedLocation == location) return;
    GoRouter.of(context).go(location, extra: extra);
  }

  static void navigateNamed(
    BuildContext context,
    String name, {
    Object? extra,
    Map<String, String>? pathParameters,
    Map<String, dynamic>? queryParameters,
  }) {
    if (GoRouterState.of(context).matchedLocation == name) return;
    GoRouter.of(context).goNamed(
      name,
      pathParameters: pathParameters ?? const {},
      queryParameters: queryParameters ?? const {},
      extra: extra,
    );
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

  static void pushNamed(
    BuildContext context,
    String name, {
    Object? extra,
    Map<String, String> pathParameters = const {},
    Map<String, String> queryParameters = const {},
  }) {
    final router = GoRouter.of(context);
    final routerState = GoRouterState.of(context);
    final routerStack = router.routerDelegate.currentConfiguration.matches
        .map((e) => e.matchedLocation);

    final nameLocation = routerState.namedLocation(
      name,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
    );

    if (routerState.matchedLocation == nameLocation ||
        routerStack.contains(nameLocation)) {
      return;
    }
    router.pushNamed(
      name,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: extra,
    );
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
            return a.artists?.first.name
                    ?.compareTo(b.artists?.first.name ?? "") ??
                0;
          case SortBy.album:
            return a.album?.name?.compareTo(b.album?.name ?? "") ?? 0;
          default:
            return 0;
        }
      });
  }

  static Future<void> checkForUpdates(
    BuildContext context,
    WidgetRef ref,
  ) async {
    if (!Env.enableUpdateChecker) return;
    final database = ref.read(databaseProvider);
    final checkUpdate = await (database.selectOnly(database.preferencesTable)
          ..addColumns([database.preferencesTable.checkUpdate])
          ..where(database.preferencesTable.id.equals(0)))
        .map((row) => row.read(database.preferencesTable.checkUpdate))
        .getSingleOrNull();

    if (checkUpdate == false) return;
    final packageInfo = await PackageInfo.fromPlatform();

    if (Env.releaseChannel == ReleaseChannel.nightly) {
      final value = await globalDio.getUri(
        Uri.parse(
          "https://api.github.com/repos/KRTirtho/spotube/actions/workflows/spotube-release-binary.yml/runs?status=success&per_page=1",
        ),
        options: Options(
          responseType: ResponseType.json,
        ),
      );

      final buildNum = value.data["workflow_runs"][0]["run_number"] as int;

      if (buildNum <= int.parse(packageInfo.buildNumber) || !context.mounted) {
        return;
      }

      await showDialog(
        context: context,
        barrierDismissible: true,
        barrierColor: Colors.black26,
        builder: (context) {
          return RootAppUpdateDialog.nightly(nightlyBuildNum: buildNum);
        },
      );
    } else {
      final value = await globalDio.getUri(
        Uri.parse(
          "https://api.github.com/repos/KRTirtho/spotube/releases/latest",
        ),
      );
      final tagName = (value.data["tag_name"] as String).replaceAll("v", "");
      final currentVersion = packageInfo.version == "Unknown"
          ? null
          : Version.parse(packageInfo.version);
      final latestVersion =
          tagName == "nightly" ? null : Version.parse(tagName);

      if (currentVersion == null ||
          latestVersion == null ||
          (latestVersion.isPreRelease && !currentVersion.isPreRelease) ||
          (!latestVersion.isPreRelease && currentVersion.isPreRelease)) return;

      if (latestVersion <= currentVersion || !context.mounted) return;

      showDialog(
        context: context,
        barrierDismissible: true,
        barrierColor: Colors.black26,
        builder: (context) {
          return RootAppUpdateDialog(version: latestVersion);
        },
      );
    }
  }
}
