import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:spotify/spotify.dart';
import 'package:spotube/components/heart_button/use_track_toggle_like.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/provider/authentication/authentication.dart';
import 'package:spotube/provider/spotify/spotify.dart';

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
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    final auth = ref.watch(authenticationProvider);

    if (auth.asData?.value == null) return const SizedBox.shrink();

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

class TrackHeartButton extends HookConsumerWidget {
  final Track track;
  const TrackHeartButton({
    super.key,
    required this.track,
  });

  @override
  Widget build(BuildContext context, ref) {
    final savedTracks = ref.watch(likedTracksProvider);
    final me = ref.watch(meProvider);
    final (:isLiked, :toggleTrackLike) = useTrackToggleLike(track, ref);

    if (me.isLoading) {
      return const CircularProgressIndicator();
    }

    return HeartButton(
      tooltip: isLiked
          ? context.l10n.remove_from_favorites
          : context.l10n.save_as_favorite,
      isLiked: isLiked,
      onPressed: savedTracks.asData?.value != null
          ? () {
              toggleTrackLike(track);
            }
          : null,
    );
  }
}
