import 'package:flutter/material.dart' as material;
import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:spotube/components/track_presentation/presentation_props.dart';
import 'package:spotube/components/track_presentation/track_presentation.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/provider/metadata_plugin/library/albums.dart';
import 'package:spotube/provider/metadata_plugin/tracks/album.dart';
import 'package:spotube/provider/metadata_plugin/utils/common.dart';

@RoutePage()
class AlbumPage extends HookConsumerWidget {
  static const name = "album";

  final SpotubeSimpleAlbumObject album;
  final String id;
  const AlbumPage({
    super.key,
    @PathParam("id") required this.id,
    required this.album,
  });

  @override
  Widget build(BuildContext context, ref) {
    final tracks = ref.watch(metadataPluginAlbumTracksProvider(album.id));
    final tracksNotifier =
        ref.watch(metadataPluginAlbumTracksProvider(album.id).notifier);
    final favoriteAlbumsNotifier =
        ref.watch(metadataPluginSavedAlbumsProvider.notifier);
    final isSavedAlbum =
        ref.watch(metadataPluginIsSavedAlbumProvider(album.id));

    return material.RefreshIndicator.adaptive(
      onRefresh: () async {
        ref.invalidate(metadataPluginAlbumTracksProvider(album.id));
        ref.invalidate(metadataPluginIsSavedAlbumProvider(album.id));
        ref.invalidate(metadataPluginSavedAlbumsProvider);
      },
      child: TrackPresentation(
        options: TrackPresentationOptions(
          collection: album,
          image: album.images.asUrlString(
            placeholder: ImagePlaceholder.albumArt,
          ),
          title: album.name,
          description:
              "${context.l10n.released} • ${album.releaseDate} • ${album.artists.first.name}",
          tracks: tracks.asData?.value.items ?? [],
          error: tracks.error,
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
              ref.invalidate(metadataPluginAlbumTracksProvider(album.id));
            },
          ),
          routePath: "/album/${album.id}",
          shareUrl: album.externalUri,
          isLiked: isSavedAlbum.asData?.value ?? false,
          owner: album.artists.first.name,
          onHeart: isSavedAlbum.asData?.value == null
              ? null
              : () async {
                  if (isSavedAlbum.asData!.value) {
                    await favoriteAlbumsNotifier.removeFavorite([album]);
                  } else {
                    await favoriteAlbumsNotifier.addFavorite([album]);
                  }
                  return null;
                },
        ),
      ),
    );
  }
}
