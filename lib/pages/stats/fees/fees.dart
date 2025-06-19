import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:spotube/collections/formatters.dart';
import 'package:spotube/components/titlebar/titlebar.dart';
import 'package:spotube/modules/stats/common/artist_item.dart';
import 'package:spotube/extensions/context.dart';

import 'package:spotube/provider/history/top.dart';
import 'package:spotube/provider/history/top/tracks.dart';
import 'package:spotube/provider/metadata_plugin/utils/common.dart';
import 'package:very_good_infinite_list/very_good_infinite_list.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class StatsStreamFeesPage extends HookConsumerWidget {
  static const name = "stats_stream_fees";

  const StatsStreamFeesPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final duration = useState<HistoryDuration>(HistoryDuration.days30);

    final topTracks = ref.watch(
      historyTopTracksProvider(duration.value),
    );
    final topTracksNotifier =
        ref.watch(historyTopTracksProvider(duration.value).notifier);

    final artistsData = useMemoized(
      () => topTracksNotifier.artists,
      [topTracks.asData?.value],
    );

    final total = useMemoized(
      () => artistsData.fold<double>(
        0,
        (previousValue, element) => previousValue + element.count * 0.005,
      ),
      [artistsData],
    );

    final translations = <HistoryDuration, String>{
      HistoryDuration.days7: context.l10n.this_week,
      HistoryDuration.days30: context.l10n.this_month,
      HistoryDuration.months6: context.l10n.last_6_months,
      HistoryDuration.year: context.l10n.this_year,
      HistoryDuration.years2: context.l10n.last_2_years,
      HistoryDuration.allTime: context.l10n.all_time,
    };

    return SafeArea(
      bottom: false,
      child: Scaffold(
        headers: [
          TitleBar(
            title: Text(context.l10n.streaming_fees_hypothetical),
          )
        ],
        child: CustomScrollView(
          slivers: [
            SliverCrossAxisConstrained(
              maxCrossAxisExtent: 600,
              alignment: -1,
              child: SliverPadding(
                padding: const EdgeInsets.all(16.0),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    context.l10n.hipotetical_calculation,
                  ).small().muted(),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.l10n.total_money(usdFormatter.format(total)),
                    ).semiBold().large(),
                    Select<HistoryDuration>(
                      value: duration.value,
                      onChanged: (value) {
                        if (value == null) return;
                        duration.value = value;
                      },
                      itemBuilder: (context, value) =>
                          Text(translations[value]!),
                      constraints: const BoxConstraints(maxWidth: 150),
                      popupWidthConstraint: PopoverConstraint.anchorMaxSize,
                      popup: SelectPopup(
                        items: SelectItemBuilder(
                          childCount: translations.length,
                          builder: (context, index) {
                            final entry = translations.entries.elementAt(index);
                            return SelectItemButton(
                              value: entry.key,
                              child: Text(entry.value),
                            );
                          },
                        ),
                      ).call,
                    ),
                  ],
                ),
              ),
            ),
            SliverSafeArea(
              sliver: Skeletonizer.sliver(
                enabled: topTracks.isLoading && !topTracks.isLoadingNextPage,
                child: SliverInfiniteList(
                  onFetchData: () async {
                    await topTracksNotifier.fetchMore();
                  },
                  hasError: topTracks.hasError,
                  isLoading:
                      topTracks.isLoading && !topTracks.isLoadingNextPage,
                  hasReachedMax: topTracks.asData?.value.hasMore ?? true,
                  itemCount: artistsData.length,
                  itemBuilder: (context, index) {
                    final artist = artistsData[index];
                    return StatsArtistItem(
                      artist: artist.artist,
                      info: Text(usdFormatter.format(artist.count * 0.005)),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
