import 'package:flutter_undraw/flutter_undraw.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:shadcn_flutter/shadcn_flutter_extension.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spotube/collections/formatters.dart';
import 'package:spotube/modules/stats/common/album_item.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/provider/history/top.dart';
import 'package:spotube/provider/history/top/albums.dart';
import 'package:spotube/provider/metadata_plugin/utils/common.dart';
import 'package:very_good_infinite_list/very_good_infinite_list.dart';

class TopAlbums extends HookConsumerWidget {
  const TopAlbums({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final historyDuration = ref.watch(playbackHistoryTopDurationProvider);
    final topAlbums = ref.watch(historyTopAlbumsProvider(historyDuration));
    final topAlbumsNotifier =
        ref.watch(historyTopAlbumsProvider(historyDuration).notifier);

    final albumsData = topAlbums.asData?.value.items ?? [];

    return Skeletonizer.sliver(
      enabled: topAlbums.isLoading && !topAlbums.isLoadingNextPage,
      child: SliverInfiniteList(
        onFetchData: () async {
          await topAlbumsNotifier.fetchMore();
        },
        hasError: topAlbums.hasError,
        isLoading: topAlbums.isLoading && !topAlbums.isLoadingNextPage,
        hasReachedMax: topAlbums.asData?.value.hasMore ?? true,
        itemCount: albumsData.length,
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
          final album = albumsData[index];
          return StatsAlbumItem(
            album: album.album,
            info: Text(
              context.l10n
                  .count_plays(compactNumberFormatter.format(album.count)),
            ),
          );
        },
      ),
    );
  }
}
