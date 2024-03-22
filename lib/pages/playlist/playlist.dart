import 'package:flutter/material.dart' hide Page;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/shared/dialogs/prompt_dialog.dart';
import 'package:spotube/components/shared/tracks_view/sections/body/use_is_user_playlist.dart';
import 'package:spotube/components/shared/tracks_view/track_view.dart';
import 'package:spotube/components/shared/tracks_view/track_view_props.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/extensions/infinite_query.dart';
import 'package:spotube/provider/spotify_provider.dart';
import 'package:spotube/services/mutations/mutations.dart';
import 'package:spotube/services/queries/queries.dart';
import 'package:spotube/utils/type_conversion_utils.dart';

class PlaylistPage extends HookConsumerWidget {
  final PlaylistSimple playlist;
  const PlaylistPage({
    Key? key,
    required this.playlist,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final spotify = ref.watch(spotifyProvider);
    final tracksQuery = useQueries.playlist.tracksOfQuery(ref, playlist.id!);

    final tracks = useMemoized(
      () {
        return tracksQuery.pages.expand((page) => page).toList();
      },
      [tracksQuery.pages],
    );

    final me = useQueries.user.me(ref);

    final isLikedQuery = useQueries.playlist.doesUserFollow(
      ref,
      playlist.id!,
      me.data?.id ?? '',
    );

    final togglePlaylistLike = useMutations.playlist.toggleFavorite(
      ref,
      playlist.id!,
      refreshQueries: [
        isLikedQuery.key,
      ],
    );

    final isUserPlaylist = useIsUserPlaylist(ref, playlist.id!);

    return InheritedTrackView(
      collectionId: playlist.id!,
      image: TypeConversionUtils.image_X_UrlString(
        playlist.images,
        placeholder: ImagePlaceholder.collection,
      ),
      pagination: PaginationProps.fromQuery(
        tracksQuery,
        onFetchAll: () {
          return tracksQuery.fetchAllTracks(
            getAllTracks: () async {
              final res = await spotify.playlists
                  .getTracksByPlaylistId(playlist.id!)
                  .all();
              return res.toList();
            },
          );
        },
      ),
      title: playlist.name!,
      description: playlist.description,
      tracks: tracks,
      routePath: '/playlist/${playlist.id}',
      isLiked: isLikedQuery.data ?? false,
      shareUrl: playlist.externalUrls?.spotify ?? "",
      onHeart: () async {
        if (!isLikedQuery.hasData || togglePlaylistLike.isMutating) {
          return false;
        }
        final confirmed = isUserPlaylist
            ? await showPromptDialog(
                context: context,
                title: context.l10n.delete_playlist,
                message: context.l10n.delete_playlist_confirmation,
              )
            : true;
        if (confirmed) {
          await togglePlaylistLike.mutate(isLikedQuery.data!);
          return isUserPlaylist;
        }
        return null;
      },
      child: const TrackView(),
    );
  }
}
