import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spotube/collections/formatters.dart';
import 'package:spotube/components/titlebar/titlebar.dart';
import 'package:spotube/modules/stats/common/album_item.dart';
import 'package:spotube/extensions/context.dart';

import 'package:spotube/provider/history/top.dart';
import 'package:spotube/provider/history/top/albums.dart';
import 'package:spotube/provider/metadata_plugin/utils/common.dart';
import 'package:very_good_infinite_list/very_good_infinite_list.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class StatsAlbumsPage extends HookConsumerWidget {
  static const name = "stats_albums";
  const StatsAlbumsPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final topAlbums =
        ref.watch(historyTopAlbumsProvider(HistoryDuration.allTime));
    final topAlbumsNotifier =
        ref.watch(historyTopAlbumsProvider(HistoryDuration.allTime).notifier);

    final albumsData = topAlbums.asData?.value.items ?? [];

    return SafeArea(
      bottom: false,
      child: Scaffold(
        headers: [
          TitleBar(
            title: Text(context.l10n.albums),
          )
        ],
        child: Skeletonizer(
          enabled: topAlbums.isLoading && !topAlbums.isLoadingNextPage,
          child: InfiniteList(
            onFetchData: () async {
              await topAlbumsNotifier.fetchMore();
            },
            hasError: topAlbums.hasError,
            isLoading: topAlbums.isLoading && !topAlbums.isLoadingNextPage,
            hasReachedMax: topAlbums.asData?.value.hasMore ?? true,
            itemCount: albumsData.length,
            itemBuilder: (context, index) {
              final album = albumsData[index];
              return StatsAlbumItem(
                album: album.album,
                info: Text(context.l10n
                    .count_plays(compactNumberFormatter.format(album.count))),
              );
            },
          ),
        ),
      ),
    );
  }
}
