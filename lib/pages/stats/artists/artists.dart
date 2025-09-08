import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';
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
class StatsArtistsPage extends HookConsumerWidget {
  static const name = "stats_artists";
  const StatsArtistsPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final topTracks = ref.watch(
      historyTopTracksProvider(HistoryDuration.allTime),
    );
    final topTracksNotifier =
        ref.watch(historyTopTracksProvider(HistoryDuration.allTime).notifier);

    final artistsData = useMemoized(
      () => topTracksNotifier.artists,
      [topTracks.asData?.value],
    );

    return SafeArea(
      bottom: false,
      child: Scaffold(
        headers: [
          TitleBar(
            title: Text(context.l10n.artists),
          )
        ],
        child: Skeletonizer(
          enabled: topTracks.isLoading && !topTracks.isLoadingNextPage,
          child: InfiniteList(
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
                info: Text(context.l10n
                    .count_plays(compactNumberFormatter.format(artist.count))),
              );
            },
          ),
        ),
      ),
    );
  }
}
