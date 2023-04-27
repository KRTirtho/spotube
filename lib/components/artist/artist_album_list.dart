import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide Page;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/album/album_card.dart';
import 'package:spotube/components/shared/shimmers/shimmer_playbutton_card.dart';
import 'package:spotube/components/shared/waypoint.dart';
import 'package:spotube/models/logger.dart';
import 'package:spotube/services/queries/queries.dart';

class ArtistAlbumList extends HookConsumerWidget {
  final String artistId;
  ArtistAlbumList(
    this.artistId, {
    Key? key,
  }) : super(key: key);

  final logger = getLogger(ArtistAlbumList);

  @override
  Widget build(BuildContext context, ref) {
    final scrollController = useScrollController();
    final albumsQuery = useQueries.artist.albumsOf(ref, artistId);

    final albums = useMemoized(() {
      return albumsQuery.pages
          .expand<Album>((page) => page.items ?? const Iterable.empty())
          .toList();
    }, [albumsQuery.pages]);

    final hasNextPage = albumsQuery.pages.isEmpty
        ? false
        : (albumsQuery.pages.last.items?.length ?? 0) == 5;

    return Column(
      children: [
        ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(
            dragDevices: {
              PointerDeviceKind.touch,
              PointerDeviceKind.mouse,
            },
          ),
          child: Scrollbar(
            interactive: false,
            controller: scrollController,
            child: Waypoint(
              controller: scrollController,
              onTouchEdge: albumsQuery.fetchNext,
              child: SingleChildScrollView(
                controller: scrollController,
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...albums.map((album) => AlbumCard(album)),
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
