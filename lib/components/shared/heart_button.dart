import 'package:fl_query/fl_query.dart';
import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:spotify/spotify.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/provider/authentication_provider.dart';
import 'package:spotube/provider/scrobbler_provider.dart';
import 'package:spotube/services/mutations/mutations.dart';
import 'package:spotube/services/queries/queries.dart';

class HeartButton extends HookConsumerWidget {
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

    if (auth == null) return const SizedBox.shrink();

    return IconButton(
      tooltip: tooltip,
      icon: AnimatedSwitcher(
        switchInCurve: Curves.fastOutSlowIn,
        switchOutCurve: Curves.fastOutSlowIn,
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return ScaleTransition(
            scale: animation,
            child: child,
          );
        },
        child: Icon(
          icon ??
              (isLiked
                  ? Icons.favorite_rounded
                  : Icons.favorite_outline_rounded),
          key: ValueKey(isLiked),
          color: color ?? (isLiked ? color ?? Colors.red : null),
        ),
      ),
      onPressed: onPressed,
    );
  }
}

typedef UseTrackToggleLike = ({
  bool isLiked,
  Mutation<bool, dynamic, bool> toggleTrackLike,
  Query<User?, dynamic> me,
});

UseTrackToggleLike useTrackToggleLike(Track track, WidgetRef ref) {
  final me = useQueries.user.me(ref);

  final savedTracks = useQueries.playlist.likedTracksQuery(ref);

  final isLiked = useMemoized(
    () => savedTracks.data?.any((element) => element.id == track.id) ?? false,
    [savedTracks.data, track.id],
  );

  final mounted = useIsMounted();

  final scrobblerNotifier = ref.read(scrobblerProvider.notifier);

  final toggleTrackLike = useMutations.track.toggleFavorite(
    ref,
    track.id!,
    onMutate: (isLiked) {
      if (isLiked) {
        savedTracks.setData(
          savedTracks.data
                  ?.where((element) => element.id != track.id)
                  .toList() ??
              [],
        );
      } else {
        savedTracks.setData(
          [
            ...?savedTracks.data,
            track,
          ],
        );
      }
      return isLiked;
    },
    onData: (isLiked, recoveryData) async {
      await savedTracks.refresh();
      if (isLiked) {
        await scrobblerNotifier.love(track);
      } else {
        await scrobblerNotifier.unlove(track);
      }
    },
    onError: (payload, isLiked) {
      if (!mounted()) return;

      if (isLiked != true) {
        savedTracks.setData(
          savedTracks.data
                  ?.where((element) => element.id != track.id)
                  .toList() ??
              [],
        );
      } else {
        savedTracks.setData(
          [
            ...?savedTracks.data,
            track,
          ],
        );
      }
    },
  );

  return (isLiked: isLiked, toggleTrackLike: toggleTrackLike, me: me);
}

class TrackHeartButton extends HookConsumerWidget {
  final Track track;
  const TrackHeartButton({
    Key? key,
    required this.track,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final savedTracks = useQueries.playlist.likedTracksQuery(ref);
    final (:me, :isLiked, :toggleTrackLike) = useTrackToggleLike(track, ref);

    if (me.isLoading || !me.hasData) {
      return const CircularProgressIndicator();
    }

    return HeartButton(
      tooltip: isLiked
          ? context.l10n.remove_from_favorites
          : context.l10n.save_as_favorite,
      isLiked: isLiked,
      onPressed: savedTracks.hasData
          ? () {
              toggleTrackLike.mutate(isLiked);
            }
          : null,
    );
  }
}

class PlaylistHeartButton extends HookConsumerWidget {
  final PlaylistSimple playlist;
  final IconData? icon;
  final ValueChanged<bool>? onData;

  const PlaylistHeartButton({
    required this.playlist,
    Key? key,
    this.icon,
    this.onData,
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
      ],
      onData: onData,
    );

    if (me.isLoading || !me.hasData) {
      return const CircularProgressIndicator();
    }

    return HeartButton(
      isLiked: isLikedQuery.data ?? false,
      tooltip: isLikedQuery.data ?? false
          ? context.l10n.remove_from_favorites
          : context.l10n.save_as_favorite,
      color: Colors.white,
      icon: icon,
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
    final client = useQueryClient();
    final me = useQueries.user.me(ref);

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

    if (me.isLoading || !me.hasData) {
      return const CircularProgressIndicator();
    }

    return HeartButton(
      isLiked: isLiked,
      tooltip: isLiked
          ? context.l10n.remove_from_favorites
          : context.l10n.save_as_favorite,
      color: Colors.white,
      onPressed: albumIsSaved.hasData
          ? () {
              toggleAlbumLike.mutate(isLiked);
            }
          : null,
    );
  }
}
