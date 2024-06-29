import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/collections/formatters.dart';
import 'package:spotube/modules/stats/common/track_item.dart';
import 'package:spotube/provider/history/top.dart';

class TopTracks extends HookConsumerWidget {
  const TopTracks({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final historyDuration = ref.watch(playbackHistoryTopDurationProvider);
    final tracks = ref.watch(
      playbackHistoryTopProvider(historyDuration)
          .select((value) => value.whenData((s) => s.tracks)),
    );

    final tracksData = tracks.asData?.value ?? [];

    return SliverList.builder(
      itemCount: tracksData.length,
      itemBuilder: (context, index) {
        final track = tracksData[index];
        return StatsTrackItem(
          track: track.track,
          info: Text(
            "${compactNumberFormatter.format(track.count)} plays",
          ),
        );
      },
    );
  }
}
