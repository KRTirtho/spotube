import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spotube/collections/formatters.dart';
import 'package:spotube/components/titlebar/titlebar.dart';
import 'package:spotube/modules/stats/common/playlist_item.dart';

import 'package:spotube/provider/history/top.dart';
import 'package:spotube/provider/history/top/playlists.dart';
import 'package:spotube/provider/spotify/spotify.dart';
import 'package:very_good_infinite_list/very_good_infinite_list.dart';

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

    return Scaffold(
      appBar: const PageWindowTitleBar(
        automaticallyImplyLeading: true,
        centerTitle: false,
        title: Text("Playlists"),
      ),
      body: Skeletonizer(
        enabled: topPlaylists.isLoading && !topPlaylists.isLoadingNextPage,
        child: InfiniteList(
          onFetchData: () async {
            await topPlaylistsNotifier.fetchMore();
          },
          hasError: topPlaylists.hasError,
          isLoading: topPlaylists.isLoading && !topPlaylists.isLoadingNextPage,
          hasReachedMax: topPlaylists.asData?.value.hasMore ?? true,
          itemCount: playlistsData.length,
          itemBuilder: (context, index) {
            final playlist = playlistsData[index];
            return StatsPlaylistItem(
              playlist: playlist.playlist,
              info: Text(
                  "${compactNumberFormatter.format(playlist.count)} plays"),
            );
          },
        ),
      ),
    );
  }
}
