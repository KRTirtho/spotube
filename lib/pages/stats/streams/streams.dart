import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/collections/formatters.dart';
import 'package:spotube/components/shared/page_window_title_bar.dart';
import 'package:spotube/components/stats/common/track_item.dart';
import 'package:spotube/provider/history/state.dart';
import 'package:spotube/provider/history/top.dart';

class StatsStreamsPage extends HookConsumerWidget {
  static const name = "stats_streams";

  const StatsStreamsPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final topTracks = ref.watch(
      playbackHistoryTopProvider(HistoryDuration.allTime)
          .select((s) => s.tracks),
    );

    return Scaffold(
      appBar: const PageWindowTitleBar(
        title: Text("Streamed songs"),
        centerTitle: false,
        automaticallyImplyLeading: true,
      ),
      body: ListView.separated(
        separatorBuilder: (context, index) => const Gap(8),
        itemCount: topTracks.length,
        itemBuilder: (context, index) {
          final (:track, :count) = topTracks[index];

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
