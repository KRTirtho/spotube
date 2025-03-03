import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:shadcn_flutter/shadcn_flutter_extension.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/modules/stats/top/albums.dart';
import 'package:spotube/modules/stats/top/artists.dart';
import 'package:spotube/modules/stats/top/tracks.dart';
import 'package:spotube/extensions/context.dart';

import 'package:spotube/provider/history/top.dart';

class StatsPageTopSection extends HookConsumerWidget {
  const StatsPageTopSection({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final selectedIndex = useState(0);
    final historyDuration = ref.watch(playbackHistoryTopDurationProvider);
    final historyDurationNotifier =
        ref.watch(playbackHistoryTopDurationProvider.notifier);

    final translations = <HistoryDuration, String>{
      HistoryDuration.days7: context.l10n.this_week,
      HistoryDuration.days30: context.l10n.this_month,
      HistoryDuration.months6: context.l10n.last_6_months,
      HistoryDuration.year: context.l10n.this_year,
      HistoryDuration.years2: context.l10n.last_2_years,
      HistoryDuration.allTime: context.l10n.all_time,
    };

    final dropdown = Select<HistoryDuration>(
        popupConstraints: const BoxConstraints(maxWidth: 150),
        popupWidthConstraint: PopoverConstraint.flexible,
        padding: const EdgeInsets.all(4),
        borderRadius: BorderRadius.circular(4),
        value: historyDuration,
        onChanged: (value) {
          if (value == null) return;
          historyDurationNotifier.update((_) => value);
        },
        itemBuilder: (context, item) => Text(translations[item]!),
        popup: (context) {
          return SelectPopup(
            items: SelectItemBuilder(
              childCount: HistoryDuration.values.length,
              builder: (context, index) {
                final item = HistoryDuration.values[index];
                return SelectItemButton(
                  value: item,
                  child: Text(translations[item]!),
                );
              },
            ),
          );
        });

    return SliverLayoutBuilder(builder: (context, constraints) {
      return SliverMainAxisGroup(
        slivers: [
          SliverAppBar(
            floating: true,
            elevation: 0,
            backgroundColor: context.theme.colorScheme.background,
            automaticallyImplyLeading: false,
            flexibleSpace: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  TabList(
                    index: selectedIndex.value,
                    onChanged: (value) {
                      selectedIndex.value = value;
                    },
                    children: [
                      TabItem(
                        child: Text(context.l10n.top_tracks),
                      ),
                      TabItem(
                        child: Text(context.l10n.top_artists),
                      ),
                      TabItem(
                        child: Text(context.l10n.top_albums),
                      ),
                    ],
                  ),
                  if (constraints.mdAndUp) ...[
                    const Spacer(),
                    dropdown,
                  ]
                ],
              ),
            ),
          ),
          if (constraints.smAndDown)
            SliverToBoxAdapter(
              child: Align(
                alignment: Alignment.centerRight,
                child: dropdown,
              ),
            ),
          switch (selectedIndex.value) {
            1 => const TopArtists(),
            2 => const TopAlbums(),
            _ => const TopTracks(),
          },
        ],
      );
    });
  }
}
