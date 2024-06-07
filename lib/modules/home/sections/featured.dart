import 'package:flutter/material.dart' hide Page;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/horizontal_playbutton_card_view/horizontal_playbutton_card_view.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/provider/spotify/spotify.dart';

class HomeFeaturedSection extends HookConsumerWidget {
  const HomeFeaturedSection({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final featuredPlaylists = ref.watch(featuredPlaylistsProvider);
    final featuredPlaylistsNotifier =
        ref.watch(featuredPlaylistsProvider.notifier);

    return Skeletonizer(
      enabled: featuredPlaylists.isLoading,
      child: HorizontalPlaybuttonCardView<PlaylistSimple>(
        items: featuredPlaylists.asData?.value.items ?? [],
        title: Text(context.l10n.featured),
        isLoadingNextPage: featuredPlaylists.isLoadingNextPage,
        hasNextPage: featuredPlaylists.asData?.value.hasMore ?? false,
        onFetchMore: featuredPlaylistsNotifier.fetchMore,
      ),
    );
  }
}
