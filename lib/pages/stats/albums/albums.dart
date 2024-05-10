import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/collections/formatters.dart';
import 'package:spotube/components/shared/page_window_title_bar.dart';
import 'package:spotube/components/stats/common/album_item.dart';
import 'package:spotube/provider/history/state.dart';
import 'package:spotube/provider/history/top.dart';

class StatsAlbumsPage extends HookConsumerWidget {
  static const name = "stats_albums";
  const StatsAlbumsPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final albums = ref.watch(
      playbackHistoryTopProvider(HistoryDuration.allTime)
          .select((s) => s.albums),
    );

    return Scaffold(
      appBar: const PageWindowTitleBar(
        automaticallyImplyLeading: true,
        centerTitle: false,
        title: Text("Albums"),
      ),
      body: ListView.builder(
        itemCount: albums.length,
        itemBuilder: (context, index) {
          final album = albums[index];
          return StatsAlbumItem(
            album: album.album,
            info: Text("${compactNumberFormatter.format(album.count)} plays"),
          );
        },
      ),
    );
  }
}
