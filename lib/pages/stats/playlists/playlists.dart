import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/collections/formatters.dart';
import 'package:spotube/components/shared/page_window_title_bar.dart';
import 'package:spotube/components/stats/common/playlist_item.dart';
import 'package:spotube/provider/history/state.dart';
import 'package:spotube/provider/history/top.dart';

class StatsPlaylistsPage extends HookConsumerWidget {
  static const name = "stats_playlists";
  const StatsPlaylistsPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final playlists = ref.watch(
      playbackHistoryTopProvider(HistoryDuration.allTime)
          .select((s) => s.playlists),
    );

    return Scaffold(
      appBar: const PageWindowTitleBar(
        automaticallyImplyLeading: true,
        centerTitle: false,
        title: Text("Playlists"),
      ),
      body: ListView.builder(
        itemCount: playlists.length,
        itemBuilder: (context, index) {
          final playlist = playlists[index];
          return StatsPlaylistItem(
            playlist: playlist.playlist.playlist,
            info:
                Text("${compactNumberFormatter.format(playlist.count)} plays"),
          );
        },
      ),
    );
  }
}
