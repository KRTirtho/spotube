import 'package:fl_query/fl_query.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:spotify/spotify.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/hooks/use_palette_color.dart';
import 'package:spotube/provider/authentication_provider.dart';
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

    return IconButton(
      tooltip: tooltip,
      icon: Icon(
        icon ?? (!isLiked ? SpotubeIcons.heart : SpotubeIcons.heartFilled),
        color: isLiked ? Colors.pink : color,
      ),
      onPressed: onPressed,
    );
  }
}

Tuple3<bool, Mutation<bool, dynamic, bool>, Query<User, dynamic>>
    useTrackToggleLike(Track track, WidgetRef ref) {
  final me = useQueries.user.me(ref);

  final savedTracks =
      useQueries.playlist.tracksOfQuery(ref, "user-liked-tracks");

  final isLiked =
      savedTracks.data?.map((track) => track.id).contains(track.id) ?? false;

  final mounted = useIsMounted();

  final toggleTrackLike = useMutations.track.toggleFavorite(
    ref,
    track.id!,
    onMutate: (variables) {
      return variables;
    },
    onError: (payload, isLiked) {
      if (!mounted()) return;

      savedTracks.setData(
        isLiked == true
            ? [...(savedTracks.data ?? []), track]
            : savedTracks.data
                    ?.where(
                      (element) => element.id != track.id,
                    )
                    .toList() ??
                [],
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
    final savedTracks =
        useQueries.playlist.tracksOfQuery(ref, "user-liked-tracks");
    final toggler = useTrackToggleLike(track, ref);
    if (toggler.item3.isLoading || !toggler.item3.hasData) {
      return const CircularProgressIndicator();
    }

    return HeartButton(
      tooltip: toggler.item1 ? "Remove from Favorite" : "Add to Favorite",
      isLiked: toggler.item1,
      onPressed: savedTracks.hasData
          ? () {
              toggler.item2.mutate(toggler.item1);
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
        "current-user-playlists",
      ],
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
      return const CircularProgressIndicator();
    }

    return HeartButton(
      isLiked: isLikedQuery.data ?? false,
      tooltip: isLikedQuery.data ?? false
          ? "Remove from Favorite"
          : "Add to Favorite",
      color: color?.titleTextColor,
      onPressed: isLikedQuery.hasData
          ? () {
              togglePlaylistLike.mutate(isLikedQuery.data!);
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
    final me = useQueries.user.me(ref);

    final albumIsSaved = useQueries.album.isSavedForMe(ref, album.id!);
    final isLiked = albumIsSaved.data ?? false;

    final toggleAlbumLike = useMutations.album.toggleFavorite(
      ref,
      album.id!,
      refreshQueries: [
        albumIsSaved.key,
        "current-user-albums",
      ],
    );

    if (me.isLoading || !me.hasData) {
      return const CircularProgressIndicator();
    }

    return HeartButton(
      isLiked: isLiked,
      tooltip: isLiked ? "Remove from Favorite" : "Add to Favorite",
      onPressed: albumIsSaved.hasData
          ? () {
              toggleAlbumLike.mutate(isLiked);
            }
          : null,
    );
  }
}
