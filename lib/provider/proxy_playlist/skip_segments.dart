import 'dart:convert';

import 'package:catcher_2/catcher_2.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart';
import 'package:spotube/models/local_track.dart';
import 'package:spotube/models/skip_segment.dart';
import 'package:spotube/provider/proxy_playlist/proxy_playlist_provider.dart';
import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';
import 'package:spotube/provider/user_preferences/user_preferences_state.dart';
import 'package:spotube/services/sourced_track/sourced_track.dart';

class SourcedSegments {
  final String source;
  final List<SkipSegment> segments;

  SourcedSegments({required this.source, required this.segments});
}

Future<List<SkipSegment>> getAndCacheSkipSegments(String id) async {
  try {
    final cached = await SkipSegment.box.get(id) as List?;
    if (cached != null && cached.isNotEmpty) {
      return List.castFrom<dynamic, SkipSegment>(
        cached
            .map(
              (json) => SkipSegment.fromJson(
                Map.castFrom<dynamic, dynamic, String, dynamic>(json),
              ),
            )
            .toList(),
      );
    }

    final res = await get(Uri(
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
    ));

    if (res.body == "Not Found") {
      return List.castFrom<dynamic, SkipSegment>([]);
    }

    final data = jsonDecode(res.body) as List;
    final segments = data.map((obj) {
      final start = obj["segment"].first.toInt();
      final end = obj["segment"].last.toInt();
      return SkipSegment(start, end);
    }).toList();

    await SkipSegment.box.put(
      id,
      segments.map((e) => e.toJson()).toList(),
    );
    return List.castFrom<dynamic, SkipSegment>(segments);
  } catch (e, stack) {
    await SkipSegment.box.put(id, []);
    Catcher2.reportCheckedError(e, stack);
    return List.castFrom<dynamic, SkipSegment>([]);
  }
}

final segmentProvider = FutureProvider<SourcedSegments?>(
  (ref) async {
    final track = ref.watch(
      ProxyPlaylistNotifier.provider.select((s) => s.activeTrack),
    );
    if (track == null) return null;

    if (track is LocalTrack || track is! SourcedTrack) return null;

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

    final segments = await getAndCacheSkipSegments(track.sourceInfo.id);

    return SourcedSegments(
      source: track.sourceInfo.id,
      segments: segments,
    );
  },
);
