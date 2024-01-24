import 'package:flutter/material.dart' hide Page;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/shared/horizontal_playbutton_card_view/horizontal_playbutton_card_view.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/services/queries/queries.dart';

class HomeFeaturedSection extends HookConsumerWidget {
  const HomeFeaturedSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final featuredPlaylistsQuery = useQueries.playlist.featured(ref);
    final playlists = useMemoized(
      () => featuredPlaylistsQuery.pages
          .whereType<Page<PlaylistSimple>>()
          .expand((page) => page.items ?? const <PlaylistSimple>[]),
      [featuredPlaylistsQuery.pages],
    );
    final isLoadingFeaturedPlaylists = !featuredPlaylistsQuery.hasPageData &&
        !featuredPlaylistsQuery.isLoadingNextPage;

    return Skeletonizer(
      enabled: isLoadingFeaturedPlaylists,
      child: HorizontalPlaybuttonCardView<PlaylistSimple>(
        items: playlists.toList(),
        title: Text(context.l10n.featured),
        isLoadingNextPage: featuredPlaylistsQuery.isLoadingNextPage,
        hasNextPage: featuredPlaylistsQuery.hasNextPage,
        onFetchMore: featuredPlaylistsQuery.fetchNext,
      ),
    );
  }
}
