import 'package:fl_query/fl_query.dart';
import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:platform_ui/platform_ui.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/hooks/usePaletteColor.dart';
import 'package:spotube/provider/Auth.dart';
import 'package:spotube/provider/SpotifyDI.dart';
import 'package:spotube/provider/SpotifyRequests.dart';
import 'package:spotube/utils/type_conversion_utils.dart';
import 'package:tuple/tuple.dart';

class HeartButton extends ConsumerWidget {
  final bool isLiked;
  final void Function()? onPressed;
  final IconData? icon;
  final Color? color;
  final String? tooltip;
  const HeartButton({
    required this.isLiked,
    required this.onPressed,
    this.color,
    this.tooltip,
    this.icon,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final auth = ref.watch(authProvider);

    if (!auth.isLoggedIn) return Container();

    return PlatformIconButton(
      tooltip: tooltip,
      icon: Icon(
        icon ??
            (!isLiked
                ? Icons.favorite_outline_rounded
                : Icons.favorite_rounded),
        color: isLiked ? Colors.pink : color,
      ),
      onPressed: onPressed,
    );
  }
}

Tuple3<bool, Mutation<bool, Tuple2<SpotifyApi, bool>>, Query<User, SpotifyApi>>
    useTrackToggleLike(Track track, WidgetRef ref) {
  final me = useQuery(
      job: currentUserQueryJob, externalData: ref.watch(spotifyProvider));

  final savedTracks = useQuery(
    job: playlistTracksQueryJob("user-liked-tracks"),
    externalData: ref.watch(spotifyProvider),
  );

  final isLiked =
      savedTracks.data?.map((track) => track.id).contains(track.id) ?? false;

  final mounted = useIsMounted();

  final toggleTrackLike = useMutation<bool, Tuple2<SpotifyApi, bool>>(
    job: toggleFavoriteTrackMutationJob(track.id!),
    onMutate: (variable) {
      savedTracks.setQueryData(
        (oldData) {
          if (!variable.item2) {
            return [...(oldData ?? []), track];
          }

          return oldData
                  ?.where(
                    (element) => element.id != track.id,
                  )
                  .toList() ??
              [];
        },
      );
      return track;
    },
    onData: (payload, variables, _) {
      if (!mounted()) return;
      savedTracks.refetch();
    },
    onError: (payload, variables, queryContext) {
      if (!mounted()) return;
      savedTracks.setQueryData(
        (oldData) {
          if (variables.item2) {
            return [...(oldData ?? []), track];
          }

          return oldData
                  ?.where(
                    (element) => element.id != track.id,
                  )
                  .toList() ??
              [];
        },
      );
    },
  );

  return Tuple3(isLiked, toggleTrackLike, me);
}

class TrackHeartButton extends HookConsumerWidget {
  final Track track;
  const TrackHeartButton({
    Key? key,
    required this.track,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final savedTracks = useQuery(
      job: playlistTracksQueryJob("user-liked-tracks"),
      externalData: ref.watch(spotifyProvider),
    );
    final toggler = useTrackToggleLike(track, ref);
    if (toggler.item3.isLoading || !toggler.item3.hasData) {
      return const CircularProgressIndicator();
    }

    return HeartButton(
      tooltip: toggler.item1 ? "Remove from Favorite" : "Add to Favorite",
      isLiked: toggler.item1,
      onPressed: savedTracks.hasData
          ? () {
              toggler.item2.mutate(
                Tuple2(ref.read(spotifyProvider), toggler.item1),
              );
            }
          : null,
    );
  }
}

class PlaylistHeartButton extends HookConsumerWidget {
  final PlaylistSimple playlist;

  const PlaylistHeartButton({
    required this.playlist,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final me = useQuery(
      job: currentUserQueryJob,
      externalData: ref.watch(spotifyProvider),
    );

    final job = playlistIsFollowedQueryJob("${playlist.id}:${me.data?.id}");
    final isLikedQuery = useQuery(
      job: job,
      externalData: ref.watch(spotifyProvider),
    );

    final togglePlaylistLike = useMutation<bool, Tuple2<SpotifyApi, bool>>(
      job: toggleFavoritePlaylistMutationJob(playlist.id!),
      onData: (payload, variables, queryContext) {
        isLikedQuery.refetch();
        QueryBowl.of(context)
            .getQuery(currentUserPlaylistsQueryJob.queryKey)
            ?.refetch();
      },
    );

    final titleImage = useMemoized(
        () => TypeConversionUtils.image_X_UrlString(
              playlist.images,
              placeholder: ImagePlaceholder.collection,
            ),
        [playlist.images]);

    final color = usePaletteGenerator(
      context,
      titleImage,
    ).dominantColor;

    if (me.isLoading || !me.hasData) return const CircularProgressIndicator();

    return HeartButton(
      isLiked: isLikedQuery.data ?? false,
      tooltip: isLikedQuery.data ?? false
          ? "Remove from Favorite"
          : "Add to Favorite",
      color: color?.titleTextColor,
      onPressed: isLikedQuery.hasData
          ? () {
              togglePlaylistLike.mutate(
                Tuple2(
                  ref.read(spotifyProvider),
                  isLikedQuery.data!,
                ),
              );
            }
          : null,
    );
  }
}

class AlbumHeartButton extends HookConsumerWidget {
  final AlbumSimple album;

  const AlbumHeartButton({
    required this.album,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final spotify = ref.watch(spotifyProvider);
    final me = useQuery(
      job: currentUserQueryJob,
      externalData: spotify,
    );

    final albumIsSaved = useQuery(
      job: albumIsSavedForCurrentUserQueryJob(album.id!),
      externalData: spotify,
    );
    final isLiked = albumIsSaved.data ?? false;

    final toggleAlbumLike = useMutation<bool, Tuple2<SpotifyApi, bool>>(
      job: toggleFavoriteAlbumMutationJob(album.id!),
      onData: (payload, variables, queryContext) {
        albumIsSaved.refetch();
        QueryBowl.of(context)
            .getQuery(currentUserAlbumsQueryJob.queryKey)
            ?.refetch();
      },
    );

    if (me.isLoading || !me.hasData) return const CircularProgressIndicator();

    return HeartButton(
      isLiked: isLiked,
      tooltip: isLiked ? "Remove from Favorite" : "Add to Favorite",
      onPressed: albumIsSaved.hasData
          ? () {
              toggleAlbumLike
                  .mutate(Tuple2(ref.read(spotifyProvider), isLiked));
            }
          : null,
    );
  }
}
