import 'package:flutter/material.dart' hide Page;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:spotify/spotify.dart';
import 'package:spotube/components/shared/horizontal_playbutton_card_view/horizontal_playbutton_card_view.dart';
import 'package:spotube/components/shared/inter_scrollbar/inter_scrollbar.dart';
import 'package:spotube/components/shared/shimmers/shimmer_categories.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/provider/authentication_provider.dart';
import 'package:spotube/services/queries/queries.dart';
import 'package:spotube/utils/type_conversion_utils.dart';

class PersonalizedPage extends HookConsumerWidget {
  const PersonalizedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final controller = useScrollController();
    final auth = ref.watch(AuthenticationNotifier.provider);
    final featuredPlaylistsQuery = useQueries.playlist.featured(ref);
    final playlists = useMemoized(
      () => featuredPlaylistsQuery.pages
          .whereType<Page<PlaylistSimple>>()
          .expand((page) => page.items ?? const <PlaylistSimple>[]),
      [featuredPlaylistsQuery.pages],
    );

    final madeForUser = useQueries.views.get(ref, "made-for-x-hub");

    final newReleases = useQueries.album.newReleases(ref);
    final userArtistsQuery = useQueries.artist.followedByMeAll(ref);
    final userArtists =
        userArtistsQuery.data?.map((s) => s.id!).toList() ?? const [];

    final albums = useMemoized(
      () => newReleases.pages
          .whereType<Page<AlbumSimple>>()
          .expand((page) => page.items ?? const <AlbumSimple>[])
          .where((album) {
            return album.artists
                    ?.any((artist) => userArtists.contains(artist.id!)) ==
                true;
          })
          .map((album) => TypeConversionUtils.simpleAlbum_X_Album(album))
          .toList(),
      [newReleases.pages],
    );

    return InterScrollbar(
      controller: controller,
      child: ListView(
        controller: controller,
        children: [
          if (!featuredPlaylistsQuery.hasPageData &&
              !featuredPlaylistsQuery.isLoadingNextPage)
            const ShimmerCategories()
          else
            HorizontalPlaybuttonCardView<PlaylistSimple>(
              items: playlists.toList(),
              title: Text(context.l10n.featured),
              hasNextPage: featuredPlaylistsQuery.hasNextPage,
              onFetchMore: featuredPlaylistsQuery.fetchNext,
            ),
          if (auth != null &&
              newReleases.hasPageData &&
              userArtistsQuery.hasData &&
              !newReleases.isLoadingNextPage)
            HorizontalPlaybuttonCardView<Album>(
              items: albums,
              title: Text(context.l10n.new_releases),
              hasNextPage: newReleases.hasNextPage,
              onFetchMore: newReleases.fetchNext,
            )
          else
            const ShimmerCategories(),
          ...?madeForUser.data?["content"]?["items"]?.map((item) {
            final playlists = item["content"]?["items"]
                    ?.where((itemL2) => itemL2["type"] == "playlist")
                    .map((itemL2) => PlaylistSimple.fromJson(itemL2))
                    .toList()
                    .cast<PlaylistSimple>() ??
                <PlaylistSimple>[];
            if (playlists.isEmpty) return const SizedBox.shrink();
            return HorizontalPlaybuttonCardView<PlaylistSimple>(
              items: playlists,
              title: Text(item["name"] ?? ""),
              hasNextPage: false,
              onFetchMore: () {},
            );
          })
        ],
      ),
    );
  }
}
