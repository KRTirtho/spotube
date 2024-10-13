import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:spotube/collections/formatters.dart';
import 'package:spotube/components/titlebar/titlebar.dart';
import 'package:spotube/modules/stats/common/artist_item.dart';
import 'package:spotube/extensions/context.dart';

import 'package:spotube/provider/history/top.dart';
import 'package:spotube/provider/history/top/tracks.dart';
import 'package:spotube/provider/spotify/spotify.dart';
import 'package:very_good_infinite_list/very_good_infinite_list.dart';

class StatsStreamFeesPage extends HookConsumerWidget {
  static const name = "stats_stream_fees";

  const StatsStreamFeesPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final ThemeData(:textTheme, :hintColor) = Theme.of(context);
    final duration = useState<HistoryDuration>(HistoryDuration.days30);

    final topTracks = ref.watch(
      historyTopTracksProvider(duration.value),
    );
    final topTracksNotifier =
        ref.watch(historyTopTracksProvider(duration.value).notifier);

    final artistsData = useMemoized(
        () => topTracks.asData?.value.artists ?? [], [topTracks.asData?.value]);

    final total = useMemoized(
      () => artistsData.fold<double>(
        0,
        (previousValue, element) => previousValue + element.count * 0.005,
      ),
      [artistsData],
    );

    return Scaffold(
      appBar: PageWindowTitleBar(
        automaticallyImplyLeading: true,
        centerTitle: false,
        title: Text(context.l10n.streaming_fees_hypothetical),
      ),
      body: CustomScrollView(
        slivers: [
          SliverCrossAxisConstrained(
            maxCrossAxisExtent: 600,
            alignment: -1,
            child: SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: SliverToBoxAdapter(
                child: Text(
                  context.l10n.spotify_hipotetical_calculation,
                  style: textTheme.bodySmall?.copyWith(
                    color: hintColor,
                  ),
                ),
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
                    style: textTheme.titleLarge,
                  ),
                  DropdownButton<HistoryDuration>(
                    value: duration.value,
                    onChanged: (value) {
                      if (value == null) return;
                      duration.value = value;
                    },
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
                isLoading: topTracks.isLoading && !topTracks.isLoadingNextPage,
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
    );
  }
}
