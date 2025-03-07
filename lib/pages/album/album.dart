import 'package:flutter/material.dart' as material;
import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/track_presentation/presentation_props.dart';
import 'package:spotube/components/track_presentation/track_presentation.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/extensions/image.dart';
import 'package:spotube/provider/spotify/spotify.dart';

@RoutePage()
class AlbumPage extends HookConsumerWidget {
  static const name = "album";

  final AlbumSimple album;
  final String id;
  const AlbumPage({
    super.key,
    @PathParam("id") required this.id,
    required this.album,
  });

  @override
  Widget build(BuildContext context, ref) {
    final tracks = ref.watch(albumTracksProvider(album));
    final tracksNotifier = ref.watch(albumTracksProvider(album).notifier);
    final favoriteAlbumsNotifier = ref.watch(favoriteAlbumsProvider.notifier);
    final isSavedAlbum = ref.watch(albumsIsSavedProvider(album.id!));

    return material.RefreshIndicator.adaptive(
      onRefresh: () async {
        ref.invalidate(albumTracksProvider(album));
        ref.invalidate(favoriteAlbumsProvider);
        ref.invalidate(albumsIsSavedProvider(album.id!));
      },
      child: TrackPresentation(
        options: TrackPresentationOptions(
          collection: album,
          image: album.images.asUrlString(
            placeholder: ImagePlaceholder.albumArt,
          ),
          title: album.name!,
          description:
              "${context.l10n.released} • ${album.releaseDate} • ${album.artists!.first.name}",
          tracks: tracks.asData?.value.items ?? [],
          pagination: PaginationProps(
            hasNextPage: tracks.asData?.value.hasMore ?? false,
            isLoading: tracks.isLoading || tracks.isLoadingNextPage,
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
          shareUrl: album.externalUrls?.spotify ??
              "https://open.spotify.com/album/${album.id}",
          isLiked: isSavedAlbum.asData?.value ?? false,
          owner: album.artists!.first.name,
          onHeart: isSavedAlbum.asData?.value == null
              ? null
              : () async {
                  if (isSavedAlbum.asData!.value) {
                    await favoriteAlbumsNotifier.removeFavorites([album.id!]);
                  } else {
                    await favoriteAlbumsNotifier.addFavorites([album.id!]);
                  }
                  return null;
                },
        ),
      ),
    );
  }
}
