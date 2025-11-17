import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spotube/collections/formatters.dart';
import 'package:spotube/components/titlebar/titlebar.dart';
import 'package:spotube/modules/stats/common/playlist_item.dart';
import 'package:spotube/extensions/context.dart';

import 'package:spotube/provider/history/top.dart';
import 'package:spotube/provider/history/top/playlists.dart';
import 'package:spotube/provider/metadata_plugin/utils/common.dart';
import 'package:very_good_infinite_list/very_good_infinite_list.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class StatsPlaylistsPage extends HookConsumerWidget {
  static const name = "stats_playlists";
  const StatsPlaylistsPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final topPlaylists =
        ref.watch(historyTopPlaylistsProvider(HistoryDuration.allTime));

    final topPlaylistsNotifier = ref
        .watch(historyTopPlaylistsProvider(HistoryDuration.allTime).notifier);

    final playlistsData = topPlaylists.asData?.value.items ?? [];

    return SafeArea(
      bottom: false,
      child: Scaffold(
        headers: [
          TitleBar(
            title: Text(context.l10n.playlists),
          )
        ],
        child: Skeletonizer(
          enabled: topPlaylists.isLoading && !topPlaylists.isLoadingNextPage,
          child: InfiniteList(
            onFetchData: () async {
              await topPlaylistsNotifier.fetchMore();
            },
            hasError: topPlaylists.hasError,
            isLoading:
                topPlaylists.isLoading && !topPlaylists.isLoadingNextPage,
            hasReachedMax: topPlaylists.asData?.value.hasMore ?? true,
            itemCount: playlistsData.length,
            itemBuilder: (context, index) {
              final playlist = playlistsData[index];
              return StatsPlaylistItem(
                playlist: playlist.playlist,
                info: Text(
                  context.l10n.count_plays(
                      compactNumberFormatter.format(playlist.count)),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
