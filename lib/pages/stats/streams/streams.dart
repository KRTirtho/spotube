import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/collections/formatters.dart';
import 'package:spotube/components/titlebar/titlebar.dart';
import 'package:spotube/modules/stats/common/track_item.dart';
import 'package:spotube/provider/history/state.dart';
import 'package:spotube/provider/history/top.dart';

class StatsStreamsPage extends HookConsumerWidget {
  static const name = "stats_streams";

  const StatsStreamsPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final topTracks = ref.watch(
      playbackHistoryTopProvider(HistoryDuration.allTime)
          .select((s) => s.whenData((s) => s.tracks)),
    );

    final topTracksData = topTracks.asData?.value ?? [];

    return Scaffold(
      appBar: const PageWindowTitleBar(
        title: Text("Streamed songs"),
        centerTitle: false,
        automaticallyImplyLeading: true,
      ),
      body: ListView.separated(
        separatorBuilder: (context, index) => const Gap(8),
        itemCount: topTracksData.length,
        itemBuilder: (context, index) {
          final (:track, :count) = topTracksData[index];

          return StatsTrackItem(
            track: track,
            info: Text(
              "${compactNumberFormatter.format(count)} streams",
            ),
          );
        },
      ),
    );
  }
}
