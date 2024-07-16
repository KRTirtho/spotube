import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/components/themed_button_tab_bar.dart';
import 'package:spotube/modules/stats/top/albums.dart';
import 'package:spotube/modules/stats/top/artists.dart';
import 'package:spotube/modules/stats/top/tracks.dart';
import 'package:spotube/extensions/context.dart';

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
            tabs: [
              Tab(
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(context.l10n.top_tracks),
                ),
              ),
              Tab(
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(context.l10n.top_artists),
                ),
              ),
              Tab(
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(context.l10n.top_albums),
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
              items: [
                DropdownMenuItem(
                  value: HistoryDuration.days7,
                  child: Text(context.l10n.this_week),
                ),
                DropdownMenuItem(
                  value: HistoryDuration.days30,
                  child: Text(context.l10n.this_month),
                ),
                DropdownMenuItem(
                  value: HistoryDuration.months6,
                  child: Text(context.l10n.last_6_months),
                ),
                DropdownMenuItem(
                  value: HistoryDuration.year,
                  child: Text(context.l10n.this_year),
                ),
                DropdownMenuItem(
                  value: HistoryDuration.years2,
                  child: Text(context.l10n.last_2_years),
                ),
                DropdownMenuItem(
                  value: HistoryDuration.allTime,
                  child: Text(context.l10n.all_time),
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
