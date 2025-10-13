import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'package:spotube/components/heart_button/use_track_toggle_like.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/provider/metadata_plugin/core/auth.dart';
import 'package:spotube/provider/metadata_plugin/library/tracks.dart';
import 'package:spotube/provider/metadata_plugin/core/user.dart';

class HeartButton extends HookConsumerWidget {
  final bool isLiked;
  final void Function()? onPressed;
  final IconData? icon;
  final Color? color;
  final String? tooltip;
  final AbstractButtonStyle variance;
  final ButtonSize size;
  const HeartButton({
    required this.isLiked,
    required this.onPressed,
    this.color,
    this.tooltip,
    this.icon,
    this.variance = ButtonVariance.ghost,
    this.size = ButtonSize.normal,
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    final authenticated = ref.watch(metadataPluginAuthenticatedProvider);

    if (authenticated.asData?.value != true) return const SizedBox.shrink();

    return Tooltip(
      tooltip: TooltipContainer(child: Text(tooltip ?? "")).call,
      child: IconButton(
        variance: variance,
        size: size,
        enabled: onPressed != null,
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
      ),
    );
  }
}

class TrackHeartButton extends HookConsumerWidget {
  final SpotubeTrackObject track;
  const TrackHeartButton({
    super.key,
    required this.track,
  });

  @override
  Widget build(BuildContext context, ref) {
    final savedTracks = ref.watch(metadataPluginSavedTracksProvider);
    final me = ref.watch(metadataPluginUserProvider);
    final (:isLiked, :isLoading, :toggleTrackLike) =
        useTrackToggleLike(track, ref);

    if (me.isLoading) {
      return const CircularProgressIndicator();
    }

    return HeartButton(
      tooltip: isLiked
          ? context.l10n.remove_from_favorites
          : context.l10n.save_as_favorite,
      isLiked: isLiked,
      onPressed: savedTracks.asData?.value == null || isLoading
          ? null
          : () {
              toggleTrackLike(track);
            },
    );
  }
}
