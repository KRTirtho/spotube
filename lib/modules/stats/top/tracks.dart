import 'package:flutter_undraw/flutter_undraw.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:shadcn_flutter/shadcn_flutter_extension.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spotube/collections/formatters.dart';
import 'package:spotube/modules/stats/common/track_item.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/provider/history/top.dart';
import 'package:spotube/provider/history/top/tracks.dart';
import 'package:spotube/provider/metadata_plugin/utils/common.dart';
import 'package:very_good_infinite_list/very_good_infinite_list.dart';

class TopTracks extends HookConsumerWidget {
  const TopTracks({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final historyDuration = ref.watch(playbackHistoryTopDurationProvider);
    final topTracks = ref.watch(
      historyTopTracksProvider(historyDuration),
    );
    final topTracksNotifier =
        ref.watch(historyTopTracksProvider(historyDuration).notifier);

    final tracksData = topTracks.asData?.value.items ?? [];

    return Skeletonizer.sliver(
      enabled: topTracks.isLoading && !topTracks.isLoadingNextPage,
      child: SliverInfiniteList(
        onFetchData: () async {
          await topTracksNotifier.fetchMore();
        },
        hasError: topTracks.hasError,
        isLoading: topTracks.isLoading && !topTracks.isLoadingNextPage,
        hasReachedMax: topTracks.asData?.value.hasMore ?? true,
        itemCount: tracksData.length,
        emptyBuilder: (context) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Gap(50),
              Undraw(
                illustration: UndrawIllustration.happyMusic,
                color: context.theme.colorScheme.primary,
                height: 200 * context.theme.scaling,
              ),
              Text(
                context.l10n.no_tracks_listened_yet,
                textAlign: TextAlign.center,
              ).muted().small(),
            ],
          ),
        ),
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
    );
  }
}
