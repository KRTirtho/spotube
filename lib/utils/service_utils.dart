import 'dart:math';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'package:html/dom.dart' hide Text;
import 'package:shadcn_flutter/shadcn_flutter.dart' hide Element;
import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/pages/library/user_local_tracks/user_local_tracks.dart';
import 'package:spotube/modules/root/update_dialog.dart';

import 'package:spotube/provider/database/database.dart';
import 'package:spotube/services/dio/dio.dart';
import 'package:spotube/services/logger/logger.dart';

import 'package:spotube/utils/primitive_utils.dart';
import 'package:collection/collection.dart';
import 'package:html/parser.dart' as parser;

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:spotube/collections/env.dart';

import 'package:version/version.dart';

enum UserAgentDevice {
  desktop,
  mobile,
}

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
        .replaceAll(RegExp(r"\s*\[[^\]]*]"), ' ')
        .replaceAll(RegExp(r"\sfeat\.|\sft\.", caseSensitive: false), ' ')
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

  static DateTime parseSpotifyAlbumDate(SpotubeFullAlbumObject? album) {
    if (album == null) {
      return DateTime.parse("1975-01-01");
    }

    return DateTime.parse(album.releaseDate);
  }

  static List<T> sortTracks<T extends SpotubeTrackObject>(
      List<T> tracks, SortBy sortBy) {
    if (sortBy == SortBy.none) return tracks;
    return List<T>.from(tracks)
      ..sort((a, b) {
        switch (sortBy) {
          case SortBy.ascending:
            return a.name.compareTo(b.name);
          case SortBy.descending:
            return b.name.compareTo(a.name);
          // TODO: We'll figure this one out later :')
          // case SortBy.newest:
          //   final aDate = parseSpotifyAlbumDate(a.album);
          //   final bDate = parseSpotifyAlbumDate(b.album);
          //   return bDate.compareTo(aDate);
          // case SortBy.oldest:
          //   final aDate = parseSpotifyAlbumDate(a.album);
          //   final bDate = parseSpotifyAlbumDate(b.album);
          // return aDate.compareTo(bDate);
          case SortBy.duration:
            return a.durationMs.compareTo(b.durationMs);
          case SortBy.artist:
            return a.artists.first.name.compareTo(b.artists.first.name);
          case SortBy.album:
            return a.album.name.compareTo(b.album.name);
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
        barrierColor: Colors.black.withAlpha(66),
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
          (!latestVersion.isPreRelease && currentVersion.isPreRelease)) {
        return;
      }

      if (latestVersion <= currentVersion || !context.mounted) return;

      showDialog(
        context: context,
        barrierDismissible: true,
        barrierColor: Colors.black.withAlpha(66),
        builder: (context) {
          return RootAppUpdateDialog(version: latestVersion);
        },
      );
    }
  }

  static Future<Uint8List?> downloadImage(
    String imageUrl,
  ) async {
    try {
      final fileStream = DefaultCacheManager().getImageFile(imageUrl);

      final bytes = List<int>.empty(growable: true);

      await for (final data in fileStream) {
        if (data is FileInfo) {
          bytes.addAll(data.file.readAsBytesSync());
          break;
        }
      }

      return Uint8List.fromList(bytes);
    } catch (e, stackTrace) {
      AppLogger.reportError(e, stackTrace);
      return null;
    }
  }

  static int randomNumber(int min, int max) {
    return min + Random().nextInt(max - min);
  }

  static String randomUserAgent(UserAgentDevice type) {
    if (type == UserAgentDevice.desktop) {
      return "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_${randomNumber(11, 15)}_${randomNumber(4, 9)}) AppleWebKit/${randomNumber(530, 537)}.${randomNumber(30, 37)} (KHTML, like Gecko) Chrome/${randomNumber(80, 105)}.0.${randomNumber(3000, 4500)}.${randomNumber(60, 125)} Safari/${randomNumber(530, 537)}.${randomNumber(30, 36)}";
    } else {
      return "Mozilla/5.0 (Linux; Android ${randomNumber(8, 13)}) AppleWebKit/${randomNumber(530, 537)}.${randomNumber(30, 36)} (KHTML, like Gecko) Chrome/${randomNumber(101, 116)}.0.${randomNumber(3000, 6000)}.${randomNumber(60, 125)} Mobile Safari/${randomNumber(530, 537)}.${randomNumber(30, 36)}";
    }
  }

  static String sanitizeFilename(String input, {String replacement = ''}) {
    final result = input
        // illegalRe
        .replaceAll(
          RegExp(r'[\/\?<>\\:\*\|"]'),
          replacement,
        )
        // controlRe
        .replaceAll(
          RegExp(
            r'[\x00-\x1f\x80-\x9f]',
          ),
          replacement,
        )
        // reservedRe
        .replaceFirst(
          RegExp(r'^\.+$'),
          replacement,
        )
        // windowsReservedRe
        .replaceFirst(
          RegExp(
            r'^(con|prn|aux|nul|com[0-9]|lpt[0-9])(\..*)?$',
            caseSensitive: false,
          ),
          replacement,
        )
        // windowsTrailingRe
        .replaceFirst(RegExp(r'[\. ]+$'), replacement);

    return result.length > 255 ? result.substring(0, 255) : result;
  }
}
