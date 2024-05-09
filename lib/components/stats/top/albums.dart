import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/collections/formatters.dart';
import 'package:spotube/components/stats/common/album_item.dart';
import 'package:spotube/provider/history/top.dart';

class TopAlbums extends HookConsumerWidget {
  const TopAlbums({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final historyDuration = ref.watch(playbackHistoryTopDurationProvider);
    final albums = ref.watch(playbackHistoryTopProvider(historyDuration)
        .select((value) => value.albums));

    return SliverList.builder(
      itemCount: albums.length,
      itemBuilder: (context, index) {
        final album = albums[index];
        return StatsAlbumItem(
          album: album.album,
          info: Text(
            "${compactNumberFormatter.format(album.count)} plays",
          ),
        );
      },
    );
  }
}
