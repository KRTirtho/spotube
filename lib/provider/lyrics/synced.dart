import 'dart:async';

import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lrc/lrc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:spotube/models/database/database.dart';
import 'package:spotube/models/lyrics.dart';
import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/provider/database/database.dart';
import 'package:spotube/services/dio/dio.dart';
import 'package:spotube/services/logger/logger.dart';

class SyncedLyricsNotifier
    extends FamilyAsyncNotifier<SubtitleSimple, SpotubeTrackObject?> {
  SpotubeTrackObject get _track => arg!;

  /// Lyrics credits: [lrclib.net](https://lrclib.net) and their contributors
  /// Thanks for their generous public API
  Future<SubtitleSimple> getLRCLibLyrics() async {
    final packageInfo = await PackageInfo.fromPlatform();

    final res = await globalDio.getUri(
      Uri(
        scheme: "https",
        host: "lrclib.net",
        path: "/api/get",
        queryParameters: {
          "artist_name": _track.artists.first.name,
          "track_name": _track.name,
          "album_name": _track.album.name,
          if (_track.durationMs > 0)
            "duration": (_track.durationMs / 1000).toInt().toString(),
        },
      ),
      options: Options(
        headers: {
          "User-Agent":
              "Spotube v${packageInfo.version} (https://github.com/KRTirtho/spotube)"
        },
        responseType: ResponseType.json,
      ),
    );

    if (res.statusCode != 200) {
      return SubtitleSimple(
        lyrics: [],
        name: _track.name,
        uri: res.realUri,
        rating: 0,
        provider: "LRCLib",
      );
    }

    final json = res.data as Map<String, dynamic>;

    final syncedLyricsRaw = json["syncedLyrics"] as String?;
    final syncedLyrics = syncedLyricsRaw?.isNotEmpty == true
        ? Lrc.parse(syncedLyricsRaw!)
            .lyrics
            .map(LyricSlice.fromLrcLine)
            .toList()
        : null;

    if (syncedLyrics?.isNotEmpty == true) {
      return SubtitleSimple(
        lyrics: syncedLyrics!,
        name: _track.name,
        uri: res.realUri,
        rating: 100,
        provider: "LRCLib",
      );
    }

    final plainLyrics = (json["plainLyrics"] as String)
        .split("\n")
        .map((line) => LyricSlice(text: line, time: Duration.zero))
        .toList();

    return SubtitleSimple(
      lyrics: plainLyrics,
      name: _track.name,
      uri: res.realUri,
      rating: 0,
      provider: "LRCLib",
    );
  }

  @override
  FutureOr<SubtitleSimple> build(track) async {
    try {
      final database = ref.watch(databaseProvider);

      if (track == null) {
        throw "No track currently";
      }

      final cachedLyrics = await (database.select(database.lyricsTable)
            ..where((tbl) => tbl.trackId.equals(track.id)))
          .map((row) => row.data)
          .getSingleOrNull();

      SubtitleSimple? lyrics = cachedLyrics;

      if (lyrics == null ||
          lyrics.lyrics.isEmpty ||
          lyrics.lyrics.length <= 5) {
        lyrics = await getLRCLibLyrics();
      }

      if (lyrics.lyrics.isEmpty) {
        throw Exception("Unable to find lyrics");
      }

      if (cachedLyrics == null || cachedLyrics.lyrics.isEmpty) {
        await database.into(database.lyricsTable).insert(
              LyricsTableCompanion.insert(
                trackId: track.id,
                data: lyrics,
              ),
              mode: InsertMode.replace,
            );
      }

      return lyrics;
    } catch (e, stackTrace) {
      AppLogger.reportError(e, stackTrace);
      rethrow;
    }
  }
}

final syncedLyricsDelayProvider = StateProvider<int>((ref) => 0);

final syncedLyricsProvider = AsyncNotifierProviderFamily<SyncedLyricsNotifier,
    SubtitleSimple, SpotubeTrackObject?>(
  () => SyncedLyricsNotifier(),
);

final syncedLyricsMapProvider =
    FutureProvider.family((ref, SpotubeTrackObject? track) async {
  final syncedLyrics = await ref.watch(syncedLyricsProvider(track).future);

  final isStaticLyrics =
      syncedLyrics.lyrics.every((l) => l.time == Duration.zero);

  final lyricsMap = syncedLyrics.lyrics
      .map((lyric) => {lyric.time.inSeconds: lyric.text})
      .reduce((accumulator, lyricSlice) => {...accumulator, ...lyricSlice});

  return (static: isStaticLyrics, lyricsMap: lyricsMap);
});
