import 'package:fl_query/fl_query.dart';
import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:platform_ui/platform_ui.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/hooks/use_palette_color.dart';
import 'package:spotube/provider/authentication_provider.dart';
import 'package:spotube/provider/spotify_provider.dart';
import 'package:spotube/services/mutations/mutations.dart';
import 'package:spotube/services/queries/queries.dart';

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
    final auth = ref.watch(AuthenticationNotifier.provider);

    if (auth == null) return Container();

    return PlatformIconButton(
      tooltip: tooltip,
      icon: Icon(
        icon ?? (!isLiked ? SpotubeIcons.heart : SpotubeIcons.heartFilled),
        color: isLiked ? Colors.pink : color,
      ),
      onPressed: onPressed,
    );
  }
}

Tuple3<bool, Mutation<bool, Tuple2<SpotifyApi, bool>>, Query<User, SpotifyApi>>
    useTrackToggleLike(Track track, WidgetRef ref) {
  final me =
      useQuery(job: Queries.user.me, externalData: ref.watch(spotifyProvider));

  final savedTracks = useQuery(
    job: Queries.playlist.tracksOf("user-liked-tracks"),
    externalData: ref.watch(spotifyProvider),
  );

  final isLiked =
      savedTracks.data?.map((track) => track.id).contains(track.id) ?? false;

  final mounted = useIsMounted();

  final toggleTrackLike = useMutation<bool, Tuple2<SpotifyApi, bool>>(
    job: Mutations.track.toggleFavorite(track.id!),
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
      job: Queries.playlist.tracksOf("user-liked-tracks"),
      externalData: ref.watch(spotifyProvider),
    );
    final toggler = useTrackToggleLike(track, ref);
    if (toggler.item3.isLoading || !toggler.item3.hasData) {
      return const PlatformCircularProgressIndicator();
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
      job: Queries.user.me,
      externalData: ref.watch(spotifyProvider),
    );

    final job =
        Queries.playlist.doesUserFollow("${playlist.id}:${me.data?.id}");
    final isLikedQuery = useQuery(
      job: job,
      externalData: ref.watch(spotifyProvider),
    );

    final togglePlaylistLike = useMutation<bool, Tuple2<SpotifyApi, bool>>(
      job: Mutations.playlist.toggleFavorite(playlist.id!),
      onData: (payload, variables, queryContext) async {
        await isLikedQuery.refetch();
        await QueryBowl.of(context)
            .getQuery(Queries.playlist.ofMine.queryKey)
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

    if (me.isLoading || !me.hasData) {
      return const PlatformCircularProgressIndicator();
    }

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
      job: Queries.user.me,
      externalData: spotify,
    );

    final albumIsSaved = useQuery(
      job: Queries.album.isSavedForMe(album.id!),
      externalData: spotify,
    );
    final isLiked = albumIsSaved.data ?? false;

    final toggleAlbumLike = useMutation<bool, Tuple2<SpotifyApi, bool>>(
      job: Mutations.album.toggleFavorite(album.id!),
      onData: (payload, variables, queryContext) {
        albumIsSaved.refetch();
        QueryBowl.of(context)
            .getQuery(Queries.album.ofMine.queryKey)
            ?.refetch();
      },
    );

    if (me.isLoading || !me.hasData) {
      return const PlatformCircularProgressIndicator();
    }

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
