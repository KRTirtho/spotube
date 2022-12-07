import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide Page;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/Album/AlbumCard.dart';
import 'package:spotube/components/LoaderShimmers/ShimmerPlaybuttonCard.dart';
import 'package:spotube/components/Shared/Waypoint.dart';
import 'package:spotube/models/Logger.dart';
import 'package:spotube/provider/SpotifyDI.dart';
import 'package:spotube/provider/SpotifyRequests.dart';

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
    final albumsQuery = useInfiniteQuery(
      job: artistAlbumsQueryJob(artistId),
      externalData: ref.watch(spotifyProvider),
    );

    final albums = useMemoized(() {
      return albumsQuery.pages
          .expand<Album>((page) => page?.items ?? const Iterable.empty())
          .toList();
    }, [albumsQuery.pages]);

    final hasNextPage = albumsQuery.pages.isEmpty
        ? false
        : (albumsQuery.pages.last?.items?.length ?? 0) == 5;

    return SizedBox(
      height: 300,
      child: ScrollConfiguration(
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
            onTouchEdge: () {
              albumsQuery.fetchNextPage();
            },
            child: ListView.builder(
              itemCount: albums.length,
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                if (index == albums.length - 1 && hasNextPage) {
                  return const ShimmerPlaybuttonCard(count: 1);
                }
                return AlbumCard(albums[index]);
              },
            ),
          ),
        ),
      ),
    );
  }
}
