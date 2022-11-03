import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:platform_ui/platform_ui.dart';
import 'package:spotube/components/Player/PlayerTrackDetails.dart';
import 'package:spotube/hooks/playback.dart';
import 'package:spotube/hooks/usePaletteColor.dart';
import 'package:spotube/models/Intents.dart';
import 'package:spotube/provider/Playback.dart';
import 'package:spotube/utils/service_utils.dart';

class PlayerOverlay extends HookConsumerWidget {
  final String albumArt;

  const PlayerOverlay({
    required this.albumArt,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final paletteColor = usePaletteColor(albumArt, ref);
    final canShow = ref.watch(
      playbackProvider.select(
        (s) =>
            s.track != null ||
            s.isPlaying ||
            s.status == PlaybackStatus.loading,
      ),
    );

    final onNext = useNextTrack(ref);
    final onPrevious = usePreviousTrack(ref);

    return GestureDetector(
      onVerticalDragEnd: (details) {
        int sensitivity = 8;
        if (details.primaryVelocity != null &&
            details.primaryVelocity! < -sensitivity) {
          ServiceUtils.navigate(context, "/player");
        }
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: MediaQuery.of(context).size.width,
            height: canShow ? 50 : 0,
            decoration: BoxDecoration(
              color: paletteColor.color.withOpacity(.7),
              border: Border.all(
                color: paletteColor.titleTextColor,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 250),
              opacity: canShow ? 1 : 0,
              child: Material(
                textStyle: PlatformTheme.of(context).textTheme!.body!,
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
                        PlatformIconButton(
                            icon: Icon(
                              Icons.skip_previous_rounded,
                              color: paletteColor.bodyTextColor,
                            ),
                            onPressed: () {
                              onPrevious();
                            }),
                        Consumer(
                          builder: (context, ref, _) {
                            return PlatformIconButton(
                              icon: Icon(
                                ref.read(playbackProvider).isPlaying
                                    ? Icons.pause_rounded
                                    : Icons.play_arrow_rounded,
                                color: paletteColor.bodyTextColor,
                              ),
                              onPressed: Actions.handler<PlayPauseIntent>(
                                context,
                                PlayPauseIntent(ref),
                              ),
                            );
                          },
                        ),
                        PlatformIconButton(
                          icon: Icon(
                            Icons.skip_next_rounded,
                            color: paletteColor.bodyTextColor,
                          ),
                          onPressed: () => onNext(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
