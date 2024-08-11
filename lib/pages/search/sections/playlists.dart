import 'package:flutter/material.dart' hide Page;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/horizontal_playbutton_card_view/horizontal_playbutton_card_view.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/provider/spotify/spotify.dart';

class SearchPlaylistsSection extends HookConsumerWidget {
  const SearchPlaylistsSection({
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    final playlistsQuery = ref.watch(searchProvider(SearchType.playlist));
    final playlistsQueryNotifier =
        ref.watch(searchProvider(SearchType.playlist).notifier);
    final playlists =
        playlistsQuery.asData?.value.items.cast<PlaylistSimple>() ?? [];

    return HorizontalPlaybuttonCardView(
      isLoadingNextPage: playlistsQuery.isLoadingNextPage,
      hasNextPage: playlistsQuery.asData?.value.hasMore == true,
      items: playlists,
      onFetchMore: playlistsQueryNotifier.fetchMore,
      title: Text(context.l10n.playlists),
    );
  }
}
