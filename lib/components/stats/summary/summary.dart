import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/collections/formatters.dart';
import 'package:spotube/components/stats/summary/summary_card.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/provider/history/summary.dart';

class StatsPageSummarySection extends HookConsumerWidget {
  const StatsPageSummarySection({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final summary = ref.watch(playbackHistorySummaryProvider);

    return SliverPadding(
      padding: const EdgeInsets.all(10),
      sliver: SliverLayoutBuilder(builder: (context, constrains) {
        return SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: constrains.isXs
                ? 2
                : constrains.smAndDown
                    ? 3
                    : constrains.mdAndDown
                        ? 4
                        : 5,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: constrains.isXs ? 1.3 : 1.5,
          ),
          delegate: SliverChildListDelegate([
            SummaryCard(
              title: summary.duration.inMinutes.toDouble(),
              unit: "minutes",
              description: 'Listened to music',
              color: Colors.purple,
            ),
            SummaryCard(
              title: summary.tracks.toDouble(),
              unit: "songs",
              description: 'Streamed overall',
              color: Colors.lightBlue,
            ),
            SummaryCard.unformatted(
              title: usdFormatter.format(summary.fees.toDouble()),
              unit: "",
              description: 'Worth of streams',
              color: Colors.green,
            ),
            SummaryCard(
              title: summary.artists.toDouble(),
              unit: "artist's",
              description: 'Music reached you',
              color: Colors.yellow,
            ),
            SummaryCard(
              title: summary.albums.toDouble(),
              unit: "full albums",
              description: 'Got your love',
              color: Colors.pink,
            ),
            SummaryCard(
              title: summary.playlists.toDouble(),
              unit: "playlists",
              description: 'Were on repeat',
              color: Colors.teal,
            ),
          ]),
        );
      }),
    );
  }
}
