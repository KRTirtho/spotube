import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/shared/tracks_view/track_view.dart';
import 'package:spotube/components/shared/tracks_view/track_view_props.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/extensions/infinite_query.dart';
import 'package:spotube/provider/spotify_provider.dart';
import 'package:spotube/services/mutations/mutations.dart';
import 'package:spotube/services/queries/queries.dart';
import 'package:spotube/utils/type_conversion_utils.dart';

class AlbumPage extends HookConsumerWidget {
  final AlbumSimple album;
  const AlbumPage({
    super.key,
    required this.album,
  });

  @override
  Widget build(BuildContext context, ref) {
    final spotify = ref.watch(spotifyProvider);
    final tracksQuery = useQueries.album.tracksOf(ref, album);

    final tracks = useMemoized(() {
      return tracksQuery.pages.expand((element) => element).toList();
    }, [tracksQuery.pages]);

    final client = useQueryClient();

    final albumIsSaved = useQueries.album.isSavedForMe(ref, album.id!);
    final isLiked = albumIsSaved.data ?? false;

    final toggleAlbumLike = useMutations.album.toggleFavorite(
      ref,
      album.id!,
      refreshQueries: [albumIsSaved.key],
      onData: (_, __) async {
        await client.refreshInfiniteQueryAllPages("current-user-albums");
      },
    );

    return InheritedTrackView(
      collectionId: album.id!,
      image: TypeConversionUtils.image_X_UrlString(
        album.images,
        placeholder: ImagePlaceholder.albumArt,
      ),
      title: album.name!,
      description:
          "${context.l10n.released} • ${album.releaseDate} • ${album.artists!.first.name}",
      tracks: tracks,
      pagination: PaginationProps.fromQuery(
        tracksQuery,
        onFetchAll: () {
          return tracksQuery.fetchAllTracks(getAllTracks: () async {
            final res = await spotify.albums.tracks(album.id!).all();

            return res
                .map((track) =>
                    TypeConversionUtils.simpleTrack_X_Track(track, album))
                .toList();
          });
        },
      ),
      routePath: "/album/${album.id}",
      shareUrl: album.externalUrls!.spotify!,
      isLiked: isLiked,
      onHeart: albumIsSaved.hasData
          ? () async {
              await toggleAlbumLike.mutate(isLiked);
              return null;
            }
          : null,
      child: const TrackView(),
    );
  }
}
