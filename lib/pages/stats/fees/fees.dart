import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:spotube/collections/formatters.dart';
import 'package:spotube/components/titlebar/titlebar.dart';
import 'package:spotube/modules/stats/common/artist_item.dart';

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
      appBar: const PageWindowTitleBar(
        automaticallyImplyLeading: true,
        centerTitle: false,
        title: Text("Streaming fees (hypothetical)"),
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
                  "*This is calculated based on Spotify's per stream "
                  "payout of \$0.003 to \$0.005. This is a hypothetical "
                  "calculation to give user insight about how much they "
                  "would have paid to the artists if they were to listen "
                  "their song in Spotify.",
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
                    "Total ${usdFormatter.format(total)}",
                    style: textTheme.titleLarge,
                  ),
                  DropdownButton<HistoryDuration>(
                    value: duration.value,
                    onChanged: (value) {
                      if (value == null) return;
                      duration.value = value;
                    },
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
