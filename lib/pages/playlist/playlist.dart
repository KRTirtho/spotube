import 'package:flutter/material.dart' hide Page;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/shared/dialogs/prompt_dialog.dart';
import 'package:spotube/components/shared/tracks_view/sections/body/use_is_user_playlist.dart';
import 'package:spotube/components/shared/tracks_view/track_view.dart';
import 'package:spotube/components/shared/tracks_view/track_view_props.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/provider/spotify/spotify.dart';
import 'package:spotube/utils/type_conversion_utils.dart';

class PlaylistPage extends HookConsumerWidget {
  final PlaylistSimple playlist;
  const PlaylistPage({
    super.key,
    required this.playlist,
  });

  @override
  Widget build(BuildContext context, ref) {
    final tracks = ref.watch(playlistTracksProvider(playlist.id!));
    final tracksNotifier =
        ref.watch(playlistTracksProvider(playlist.id!).notifier);
    final isFavoritePlaylist =
        ref.watch(isFavoritePlaylistProvider(playlist.id!));
    final favoritePlaylistsNotifier =
        ref.watch(favoritePlaylistsProvider.notifier);

    final isUserPlaylist = useIsUserPlaylist(ref, playlist.id!);

    return InheritedTrackView(
      collectionId: playlist.id!,
      image: TypeConversionUtils.image_X_UrlString(
        playlist.images,
        placeholder: ImagePlaceholder.collection,
      ),
      pagination: PaginationProps(
        hasNextPage: tracks.value?.hasMore ?? false,
        isLoading: tracks.isLoading,
        onFetchMore: tracksNotifier.fetchMore,
        onRefresh: () async {
          ref.invalidate(playlistTracksProvider(playlist.id!));
        },
        onFetchAll: () async {
          return await tracksNotifier.fetchAll();
        },
      ),
      title: playlist.name!,
      description: playlist.description,
      tracks: tracks.value?.items ?? [],
      routePath: '/playlist/${playlist.id}',
      isLiked: isFavoritePlaylist.value ?? false,
      shareUrl: playlist.externalUrls?.spotify ?? "",
      onHeart: isFavoritePlaylist.value == null
          ? null
          : () async {
              final confirmed = isUserPlaylist
                  ? await showPromptDialog(
                      context: context,
                      title: context.l10n.delete_playlist,
                      message: context.l10n.delete_playlist_confirmation,
                    )
                  : true;
              if (!confirmed) return null;

              if (isFavoritePlaylist.value!) {
                await favoritePlaylistsNotifier.removeFavorite(playlist);
              } else {
                await favoritePlaylistsNotifier.addFavorite(playlist);
              }
              return isUserPlaylist;
            },
      child: const TrackView(),
    );
  }
}
