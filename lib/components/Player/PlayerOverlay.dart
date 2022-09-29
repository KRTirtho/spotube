import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/components/Player/PlayerTrackDetails.dart';
import 'package:spotube/hooks/playback.dart';
import 'package:spotube/hooks/useBreakpoints.dart';
import 'package:spotube/hooks/usePaletteColor.dart';
import 'package:spotube/models/Intents.dart';
import 'package:spotube/provider/Playback.dart';
import 'package:spotube/provider/UserPreferences.dart';

class PlayerOverlay extends HookConsumerWidget {
  final String albumArt;

  const PlayerOverlay({
    required this.albumArt,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final breakpoint = useBreakpoints();
    final paletteColor = usePaletteColor(albumArt, ref);
    final layoutMode = ref.watch(
      userPreferencesProvider.select((s) => s.layoutMode),
    );

    var isHome = GoRouter.of(context).location == "/";
    final isAllowedPage = ["/playlist/", "/album/"].any(
      (el) => GoRouter.of(context).location.startsWith(el),
    );

    final onNext = useNextTrack(ref);
    final onPrevious = usePreviousTrack(ref);

    if (!isHome && !isAllowedPage) return Container();

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 2500),
      right: (breakpoint.isMd && !isAllowedPage ? 10 : 5),
      left: (layoutMode == LayoutMode.compact ||
              (breakpoint.isSm && layoutMode == LayoutMode.adaptive) ||
              isAllowedPage
          ? 5
          : 90),
      bottom: (layoutMode == LayoutMode.compact && !isAllowedPage) ||
              (breakpoint.isSm &&
                  layoutMode == LayoutMode.adaptive &&
                  !isAllowedPage)
          ? 63
          : 10,
      child: GestureDetector(
        onVerticalDragEnd: (details) {
          int sensitivity = 8;
          if (details.primaryVelocity != null &&
              details.primaryVelocity! < -sensitivity) {
            GoRouter.of(context).push("/player");
          }
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              width: MediaQuery.of(context).size.width,
              height: 50,
              decoration: BoxDecoration(
                color: paletteColor.color.withOpacity(.7),
                border: Border.all(
                  color: paletteColor.titleTextColor,
                  width: 2,
                ),
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
                        Consumer(
                          builder: (context, ref, _) {
                            return IconButton(
                              icon: Icon(
                                ref.read(playbackProvider).isPlaying
                                    ? Icons.pause_rounded
                                    : Icons.play_arrow_rounded,
                              ),
                              color: paletteColor.bodyTextColor,
                              onPressed: Actions.handler<PlayPauseIntent>(
                                context,
                                PlayPauseIntent(ref),
                              ),
                            );
                          },
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
        ),
      ),
    );
  }
}
