import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide Page;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:spotify/spotify.dart';
import 'package:spotube/components/album/album_card.dart';
import 'package:spotube/components/playlist/playlist_card.dart';
import 'package:spotube/components/shared/shimmers/shimmer_categories.dart';
import 'package:spotube/components/shared/shimmers/shimmer_playbutton_card.dart';
import 'package:spotube/components/shared/waypoint.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/models/logger.dart';
import 'package:spotube/provider/authentication_provider.dart';
import 'package:spotube/services/queries/queries.dart';
import 'package:spotube/utils/type_conversion_utils.dart';

class PersonalizedItemCard extends HookWidget {
  final Iterable<PlaylistSimple>? playlists;
  final Iterable<AlbumSimple>? albums;
  final String title;
  final bool hasNextPage;
  final void Function() onFetchMore;

  PersonalizedItemCard({
    this.playlists,
    this.albums,
    required this.title,
    required this.hasNextPage,
    required this.onFetchMore,
    Key? key,
  })  : assert(playlists == null || albums == null),
        super(key: key);

  final logger = getLogger(PersonalizedItemCard);

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
              },
            ),
            child: Scrollbar(
              controller: scrollController,
              interactive: false,
              child: Waypoint(
                controller: scrollController,
                onTouchEdge: hasNextPage ? onFetchMore : null,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...?playlists?.map((playlist) => PlaylistCard(playlist)),
                      ...?albums?.map(
                        (album) => AlbumCard(
                          TypeConversionUtils.simpleAlbum_X_Album(album),
                        ),
                      ),
                      if (hasNextPage) const ShimmerPlaybuttonCard(count: 1),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PersonalizedPage extends HookConsumerWidget {
  const PersonalizedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
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
      }),
      [newReleases.pages],
    );

    return ListView(
      children: [
        if (!featuredPlaylistsQuery.hasPageData)
          const ShimmerCategories()
        else
          PersonalizedItemCard(
            playlists: playlists,
            title: context.l10n.featured,
            hasNextPage: featuredPlaylistsQuery.hasNextPage,
            onFetchMore: featuredPlaylistsQuery.fetchNext,
          ),
        if (auth != null && newReleases.hasPageData && userArtistsQuery.hasData)
          PersonalizedItemCard(
            albums: albums,
            title: context.l10n.new_releases,
            hasNextPage: newReleases.hasNextPage,
            onFetchMore: newReleases.fetchNext,
          ),
        ...?madeForUser.data?["content"]?["items"]?.map((item) {
          final playlists = item["content"]?["items"]
                  ?.where((itemL2) => itemL2["type"] == "playlist")
                  .map((itemL2) => PlaylistSimple.fromJson(itemL2))
                  .toList()
                  .cast<PlaylistSimple>() ??
              <PlaylistSimple>[];
          if (playlists.isEmpty) return const SizedBox.shrink();
          return PersonalizedItemCard(
            playlists: playlists,
            title: item["name"] ?? "",
            hasNextPage: false,
            onFetchMore: () {},
          );
        })
      ],
    );
  }
}
