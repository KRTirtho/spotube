import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spotube/collections/formatters.dart';
import 'package:spotube/components/titlebar/titlebar.dart';
import 'package:spotube/modules/stats/common/track_item.dart';
import 'package:spotube/extensions/context.dart';

import 'package:spotube/provider/history/top.dart';
import 'package:spotube/provider/history/top/tracks.dart';
import 'package:spotube/provider/spotify/spotify.dart';
import 'package:very_good_infinite_list/very_good_infinite_list.dart';

class StatsStreamsPage extends HookConsumerWidget {
  static const name = "stats_streams";

  const StatsStreamsPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final topTracks = ref.watch(
      historyTopTracksProvider(HistoryDuration.allTime),
    );
    final topTracksNotifier =
        ref.watch(historyTopTracksProvider(HistoryDuration.allTime).notifier);

    final tracksData = topTracks.asData?.value.items ?? [];

    return Scaffold(
      appBar: PageWindowTitleBar(
        title: Text(context.l10n.streamed_songs),
        centerTitle: false,
        automaticallyImplyLeading: true,
      ),
      body: Skeletonizer(
        enabled: topTracks.isLoading && !topTracks.isLoadingNextPage,
        child: InfiniteList(
          separatorBuilder: (context, index) => const Gap(8),
          onFetchData: () async {
            await topTracksNotifier.fetchMore();
          },
          hasError: topTracks.hasError,
          isLoading: topTracks.isLoading && !topTracks.isLoadingNextPage,
          hasReachedMax: topTracks.asData?.value.hasMore ?? true,
          itemCount: tracksData.length,
          itemBuilder: (context, index) {
            final track = tracksData[index];
            return StatsTrackItem(
              track: track.track,
              info: Text(
                context.l10n
                    .count_plays(compactNumberFormatter.format(track.count)),
              ),
            );
          },
        ),
      ),
    );
  }
}
