import 'package:spotube/models/database/database.dart';
import 'package:spotube/provider/database/database.dart';
import 'package:spotube/services/logger/logger.dart';
import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/provider/server/active_sourced_track.dart';
import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';

import 'package:spotube/services/dio/dio.dart';

class SourcedSegments {
  final String source;
  final List<SkipSegmentTableData> segments;

  SourcedSegments({required this.source, required this.segments});
}

Future<List<SkipSegmentTableData>> getAndCacheSkipSegments(
    String id, Ref ref) async {
  final database = ref.read(databaseProvider);
  try {
    final cached = await (database.select(database.skipSegmentTable)
          ..where((s) => s.trackId.equals(id)))
        .get();

    if (cached.isNotEmpty) {
      return cached;
    }

    final res = await globalDio.getUri(
      Uri(
        scheme: "https",
        host: "sponsor.ajay.app",
        path: "/api/skipSegments",
        queryParameters: {
          "videoID": id,
          "category": [
            'sponsor',
            'selfpromo',
            'interaction',
            'intro',
            'outro',
            'music_offtopic'
          ],
          "actionType": 'skip'
        },
      ),
      options: Options(
        responseType: ResponseType.json,
        validateStatus: (status) => (status ?? 0) < 500,
      ),
    );

    if (res.data == "Not Found") {
      return List.castFrom<dynamic, SkipSegmentTableData>([]);
    }

    final data = res.data as List;
    final segments = data.map((obj) {
      final start = obj["segment"].first.toInt();
      final end = obj["segment"].last.toInt();
      return SkipSegmentTableCompanion.insert(
        trackId: id,
        start: start,
        end: end,
      );
    }).toList();

    await database.batch((b) {
      b.insertAll(database.skipSegmentTable, segments);
    });

    return await (database.select(database.skipSegmentTable)
          ..where((s) => s.trackId.equals(id)))
        .get();
  } catch (e, stack) {
    AppLogger.reportError(e, stack);
    return List.castFrom<dynamic, SkipSegmentTableData>([]);
  }
}

final segmentProvider = FutureProvider<SourcedSegments?>(
  (ref) async {
    final track = ref.watch(activeSourcedTrackProvider);
    if (track == null) return null;

    final skipNonMusic = ref.watch(
      userPreferencesProvider.select(
        (s) {
          final isPipedYTMusicMode = s.audioSource == AudioSource.piped &&
              s.searchMode == SearchMode.youtubeMusic;

          return s.skipNonMusic && !isPipedYTMusicMode;
        },
      ),
    );

    if (!skipNonMusic) {
      return SourcedSegments(
        segments: [],
        source: track.sourceInfo.id,
      );
    }

    final segments = await getAndCacheSkipSegments(track.sourceInfo.id, ref);

    return SourcedSegments(
      source: track.sourceInfo.id,
      segments: segments,
    );
  },
);
