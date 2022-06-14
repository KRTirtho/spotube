import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/components/Player/PlayerTrackDetails.dart';
import 'package:spotube/hooks/playback.dart';
import 'package:spotube/hooks/useBreakpoints.dart';
import 'package:spotube/hooks/useIsCurrentRoute.dart';
import 'package:spotube/hooks/usePaletteColor.dart';
import 'package:spotube/provider/Playback.dart';

class PlayerOverlay extends HookConsumerWidget {
  final String albumArt;

  const PlayerOverlay({
    required this.albumArt,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final breakpoint = useBreakpoints();
    final isCurrentRoute = useIsCurrentRoute("/");
    final paletteColor = usePaletteColor(context, albumArt, ref);
    final playback = ref.watch(playbackProvider);

    if (isCurrentRoute == false) {
      return Container();
    }

    final onNext = useNextTrack(playback);

    final onPrevious = usePreviousTrack(playback);

    final _playOrPause = useTogglePlayPause(playback);

    return Positioned(
      right: (breakpoint.isMd ? 10 : 5),
      left: (breakpoint.isSm ? 5 : 80),
      bottom: (breakpoint.isSm ? 63 : 10),
      child: GestureDetector(
        onVerticalDragEnd: (details) {
          int sensitivity = 8;
          if (details.primaryVelocity != null &&
              details.primaryVelocity! < -sensitivity) {
            GoRouter.of(context).push("/player");
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          width: MediaQuery.of(context).size.width,
          height: 50,
          decoration: BoxDecoration(
            color: paletteColor.color,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Material(
            type: MaterialType.transparency,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () => GoRouter.of(context).push("/player"),
                      child: PlayerTrackDetails(
                        albumArt: albumArt,
                        color: paletteColor.bodyTextColor,
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                        icon: const Icon(Icons.skip_previous_rounded),
                        color: paletteColor.bodyTextColor,
                        onPressed: () {
                          onPrevious();
                        }),
                    IconButton(
                      icon: Icon(
                        playback.isPlaying
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                      ),
                      color: paletteColor.bodyTextColor,
                      onPressed: _playOrPause,
                    ),
                    IconButton(
                      icon: const Icon(Icons.skip_next_rounded),
                      onPressed: () => onNext(),
                      color: paletteColor.bodyTextColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
