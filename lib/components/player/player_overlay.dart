import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:platform_ui/platform_ui.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/player/player_track_details.dart';
import 'package:spotube/hooks/use_palette_color.dart';
import 'package:spotube/collections/intents.dart';
import 'package:spotube/provider/playlist_queue_provider.dart';
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
      PlaylistQueueNotifier.provider.select((s) => s != null),
    );
    final playlistNotifier = ref.watch(PlaylistQueueNotifier.notifier);
    final playing = useStream(PlaylistQueueNotifier.playing).data ??
        PlaylistQueueNotifier.isPlaying;

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
                        IconButton(
                          icon: Icon(
                            SpotubeIcons.skipBack,
                            color: paletteColor.bodyTextColor,
                          ),
                          onPressed: playlistNotifier.previous,
                        ),
                        Consumer(
                          builder: (context, ref, _) {
                            return IconButton(
                              icon: Icon(
                                playing
                                    ? SpotubeIcons.pause
                                    : SpotubeIcons.play,
                                color: paletteColor.bodyTextColor,
                              ),
                              onPressed: Actions.handler<PlayPauseIntent>(
                                context,
                                PlayPauseIntent(ref),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            SpotubeIcons.skipForward,
                            color: paletteColor.bodyTextColor,
                          ),
                          onPressed: playlistNotifier.next,
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
