import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/components/shared/horizontal_playbutton_card_view/horizontal_playbutton_card_view.dart';
import 'package:spotube/provider/history/recent.dart';
import 'package:spotube/provider/history/state.dart';

class HomeRecentlyPlayedSection extends HookConsumerWidget {
  const HomeRecentlyPlayedSection({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final history = ref.watch(recentlyPlayedItems);

    if (history.isEmpty) {
      return const SizedBox();
    }

    return HorizontalPlaybuttonCardView(
      title: const Text('Recently Played'),
      items: [
        for (final item in history)
          if (item is PlaybackHistoryPlaylist)
            item.playlist
          else if (item is PlaybackHistoryAlbum)
            item.album
      ],
      hasNextPage: false,
      isLoadingNextPage: false,
      onFetchMore: () {},
    );
  }
}
