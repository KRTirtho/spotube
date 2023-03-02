import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide Page;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:platform_ui/platform_ui.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/album/album_card.dart';
import 'package:spotube/components/playlist/playlist_card.dart';
import 'package:spotube/components/shared/shimmers/shimmer_playbutton_card.dart';
import 'package:spotube/components/shared/waypoint.dart';
import 'package:spotube/models/logger.dart';
import 'package:spotube/services/queries/queries.dart';
import 'package:spotube/utils/type_conversion_utils.dart';

class PersonalizedItemCard extends HookWidget {
  final Iterable<Page<PlaylistSimple>>? playlists;
  final Iterable<Page<AlbumSimple>>? albums;
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

    final playlistItems = playlists
        ?.expand(
          (page) => page.items ?? const Iterable<PlaylistSimple>.empty(),
        )
        .toList();

    final albumItems = albums
        ?.expand(
          (page) => page.items ?? const Iterable<AlbumSimple>.empty(),
        )
        .toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              PlatformText.headline(title),
            ],
          ),
        ),
        SizedBox(
          height: playlists != null ? 245 : 285,
          child: ScrollConfiguration(
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
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  controller: scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    ...?playlistItems
                        ?.map((playlist) => PlaylistCard(playlist)),
                    ...?albumItems?.map(
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
    );
  }
}

class PersonalizedPage extends HookConsumerWidget {
  const PersonalizedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final featuredPlaylistsQuery = useQueries.playlist.featured(ref);

    final newReleases = useQueries.album.newReleases(ref);

    return ListView(
      children: [
        PersonalizedItemCard(
          playlists:
              featuredPlaylistsQuery.pages.whereType<Page<PlaylistSimple>>(),
          title: 'Featured',
          hasNextPage: featuredPlaylistsQuery.hasNextPage,
          onFetchMore: featuredPlaylistsQuery.fetchNext,
        ),
        PersonalizedItemCard(
          albums: newReleases.pages.whereType<Page<AlbumSimple>>(),
          title: 'New Releases',
          hasNextPage: newReleases.hasNextPage,
          onFetchMore: newReleases.fetchNext,
        ),
      ],
    );
  }
}
