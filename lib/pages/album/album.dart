import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/shared/tracks_view/track_view.dart';
import 'package:spotube/components/shared/tracks_view/track_view_props.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/provider/spotify/spotify.dart';
import 'package:spotube/utils/type_conversion_utils.dart';

class AlbumPage extends HookConsumerWidget {
  final AlbumSimple album;
  const AlbumPage({
    super.key,
    required this.album,
  });

  @override
  Widget build(BuildContext context, ref) {
    final tracks = ref.watch(albumTracksProvider(album));
    final tracksNotifier = ref.watch(albumTracksProvider(album).notifier);
    final favoriteAlbumsNotifier = ref.watch(favoriteAlbumsProvider.notifier);
    final isSavedAlbum = ref.watch(albumsIsSavedProvider(album.id!));

    return InheritedTrackView(
      collectionId: album.id!,
      image: TypeConversionUtils.image_X_UrlString(
        album.images,
        placeholder: ImagePlaceholder.albumArt,
      ),
      title: album.name!,
      description:
          "${context.l10n.released} • ${album.releaseDate} • ${album.artists!.first.name}",
      tracks: tracks.value?.items ?? [],
      pagination: PaginationProps(
        hasNextPage: tracks.value?.hasMore ?? false,
        isLoading: tracks.isLoading,
        onFetchMore: () async {
          await tracksNotifier.fetchMore();
        },
        onFetchAll: () async {
          return tracksNotifier.fetchAll();
        },
        onRefresh: () async {
          ref.invalidate(albumTracksProvider(album));
        },
      ),
      routePath: "/album/${album.id}",
      shareUrl: album.externalUrls!.spotify!,
      isLiked: isSavedAlbum.value ?? false,
      onHeart: isSavedAlbum.value == null
          ? null
          : () async {
              if (isSavedAlbum.value!) {
                await favoriteAlbumsNotifier.removeFavorites([album.id!]);
              } else {
                await favoriteAlbumsNotifier.addFavorites([album.id!]);
              }
              return null;
            },
      child: const TrackView(),
    );
  }
}
