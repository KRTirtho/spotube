import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/components/shared/themed_button_tab_bar.dart';
import 'package:spotube/components/stats/top/albums.dart';
import 'package:spotube/components/stats/top/artists.dart';
import 'package:spotube/components/stats/top/tracks.dart';
import 'package:spotube/provider/history/state.dart';
import 'package:spotube/provider/history/top.dart';

class StatsPageTopSection extends HookConsumerWidget {
  const StatsPageTopSection({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final tabController = useTabController(initialLength: 3);
    final historyDuration = ref.watch(playbackHistoryTopDurationProvider);
    final historyDurationNotifier =
        ref.watch(playbackHistoryTopDurationProvider.notifier);

    return SliverMainAxisGroup(
      slivers: [
        SliverAppBar(
          floating: true,
          flexibleSpace: ThemedButtonsTabBar(
            controller: tabController,
            tabs: const [
              Tab(
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Text("Top Tracks"),
                ),
              ),
              Tab(
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Text("Top Artists"),
                ),
              ),
              Tab(
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Text("Top Albums"),
                ),
              ),
            ],
          ),
        ),
        SliverToBoxAdapter(
          child: Align(
            alignment: Alignment.centerRight,
            child: DropdownButton(
              style: Theme.of(context).textTheme.bodySmall!,
              isDense: true,
              padding: const EdgeInsets.all(4),
              borderRadius: BorderRadius.circular(4),
              underline: const SizedBox(),
              value: historyDuration,
              onChanged: (value) {
                if (value == null) return;
                historyDurationNotifier.update((_) => value);
              },
              icon: const Icon(Icons.arrow_drop_down),
              items: const [
                DropdownMenuItem(
                  value: HistoryDuration.days7,
                  child: Text("This week"),
                ),
                DropdownMenuItem(
                  value: HistoryDuration.days30,
                  child: Text("This month"),
                ),
                DropdownMenuItem(
                  value: HistoryDuration.months6,
                  child: Text("Last 6 months"),
                ),
                DropdownMenuItem(
                  value: HistoryDuration.year,
                  child: Text("This year"),
                ),
                DropdownMenuItem(
                  value: HistoryDuration.years2,
                  child: Text("Last 2 years"),
                ),
                DropdownMenuItem(
                  value: HistoryDuration.allTime,
                  child: Text("All time"),
                ),
              ],
            ),
          ),
        ),
        ListenableBuilder(
          listenable: tabController,
          builder: (context, _) {
            return switch (tabController.index) {
              1 => const TopArtists(),
              2 => const TopAlbums(),
              _ => const TopTracks(),
            };
          },
        ),
      ],
    );
  }
}
