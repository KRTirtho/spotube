import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:palette_generator/palette_generator.dart';

import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/collections/intents.dart';
import 'package:spotube/hooks/use_progress.dart';
import 'package:spotube/models/logger.dart';
import 'package:spotube/provider/playlist_queue_provider.dart';
import 'package:spotube/utils/primitive_utils.dart';

class PlayerControls extends HookConsumerWidget {
  final PaletteGenerator? palette;
  final bool compact;

  PlayerControls({
    this.palette,
    this.compact = false,
    Key? key,
  }) : super(key: key);

  final logger = getLogger(PlayerControls);

  static FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context, ref) {
    final shortcuts = useMemoized(
        () => {
              const SingleActivator(LogicalKeyboardKey.arrowRight):
                  SeekIntent(ref, true),
              const SingleActivator(LogicalKeyboardKey.arrowLeft):
                  SeekIntent(ref, false),
            },
        [ref]);
    final actions = useMemoized(
        () => {
              SeekIntent: SeekAction(),
            },
        []);
    final playlist = ref.watch(PlaylistQueueNotifier.provider);
    final playlistNotifier = ref.watch(PlaylistQueueNotifier.notifier);
    final playing = useStream(PlaylistQueueNotifier.playing).data ??
        PlaylistQueueNotifier.isPlaying;
    final theme = Theme.of(context);

    final isDominantColorDark = ThemeData.estimateBrightnessForColor(
          palette?.dominantColor?.color ?? theme.colorScheme.primary,
        ) ==
        Brightness.dark;

    final dominantColor = isDominantColorDark
        ? palette?.mutedColor ?? palette?.dominantColor
        : palette?.dominantColor;

    final sliderColor =
        palette?.dominantColor?.titleTextColor ?? theme.colorScheme.primary;

    final buttonStyle = IconButton.styleFrom(
      backgroundColor: dominantColor?.color.withOpacity(0.2) ??
          theme.colorScheme.surface.withOpacity(0.4),
      minimumSize: const Size(28, 28),
    );

    final activeButtonStyle = IconButton.styleFrom(
      backgroundColor:
          dominantColor?.titleTextColor ?? theme.colorScheme.primaryContainer,
      foregroundColor:
          dominantColor?.color ?? theme.colorScheme.onPrimaryContainer,
      minimumSize: const Size(28, 28),
    );

    final accentColor = palette?.lightVibrantColor ??
        palette?.darkVibrantColor ??
        dominantColor;

    final resumePauseStyle = IconButton.styleFrom(
      backgroundColor: accentColor?.color ?? theme.colorScheme.primary,
      foregroundColor:
          accentColor?.titleTextColor ?? theme.colorScheme.onPrimary,
      padding: EdgeInsets.all(compact ? 10 : 12),
      iconSize: compact ? 18 : 24,
    );

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (focusNode.canRequestFocus) {
          focusNode.requestFocus();
        }
      },
      child: FocusableActionDetector(
        focusNode: focusNode,
        shortcuts: shortcuts,
        actions: actions,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            children: [
              if (!compact)
                HookBuilder(
                  builder: (context) {
                    final progressObj = useProgress(ref);

                    final progressStatic = progressObj.item1;
                    final position = progressObj.item2;
                    final duration = progressObj.item3;

                    final totalMinutes = PrimitiveUtils.zeroPadNumStr(
                      duration.inMinutes.remainder(60),
                    );
                    final totalSeconds = PrimitiveUtils.zeroPadNumStr(
                      duration.inSeconds.remainder(60),
                    );
                    final currentMinutes = PrimitiveUtils.zeroPadNumStr(
                      position.inMinutes.remainder(60),
                    );
                    final currentSeconds = PrimitiveUtils.zeroPadNumStr(
                      position.inSeconds.remainder(60),
                    );

                    final progress = useState<num>(
                      useMemoized(() => progressStatic, []),
                    );

                    useEffect(() {
                      progress.value = progressStatic;
                      return null;
                    }, [progressStatic]);

                    return Column(
                      children: [
                        Tooltip(
                          message: "Slide to seek forward or backward",
                          child: Slider(
                            // cannot divide by zero
                            // there's an edge case for value being bigger
                            // than total duration. Keeping it resolved
                            value: progress.value.toDouble(),
                            onChanged: playlist?.isLoading == true
                                ? null
                                : (v) {
                                    progress.value = v;
                                  },
                            onChangeEnd: (value) async {
                              await playlistNotifier.seek(
                                Duration(
                                  seconds: (value * duration.inSeconds).toInt(),
                                ),
                              );
                            },
                            activeColor: sliderColor,
                            inactiveColor: sliderColor.withOpacity(0.15),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                          ),
                          child: DefaultTextStyle(
                            style: theme.textTheme.bodySmall!.copyWith(
                              color: palette?.dominantColor?.bodyTextColor,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("$currentMinutes:$currentSeconds"),
                                Text("$totalMinutes:$totalSeconds"),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    tooltip: playlist?.isShuffled == true
                        ? "Unshuffle playlist"
                        : "Shuffle playlist",
                    icon: const Icon(SpotubeIcons.shuffle),
                    style: playlist?.isShuffled == true
                        ? activeButtonStyle
                        : buttonStyle,
                    onPressed: playlist == null
                        ? null
                        : () {
                            if (playlist.isShuffled == true) {
                              playlistNotifier.unshuffle();
                            } else {
                              playlistNotifier.shuffle();
                            }
                          },
                  ),
                  IconButton(
                    tooltip: "Previous track",
                    icon: const Icon(SpotubeIcons.skipBack),
                    style: buttonStyle,
                    onPressed: playlistNotifier.previous,
                  ),
                  IconButton(
                    tooltip: playing ? "Pause playback" : "Resume playback",
                    icon: playlist?.isLoading == true
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(),
                          )
                        : Icon(
                            playing ? SpotubeIcons.pause : SpotubeIcons.play,
                          ),
                    style: resumePauseStyle,
                    onPressed: Actions.handler<PlayPauseIntent>(
                      context,
                      PlayPauseIntent(ref),
                    ),
                  ),
                  IconButton(
                    tooltip: "Next track",
                    icon: const Icon(SpotubeIcons.skipForward),
                    style: buttonStyle,
                    onPressed: playlistNotifier.next,
                  ),
                  IconButton(
                    tooltip: playlist?.isLooping != true
                        ? "Loop Track"
                        : "Repeat playlist",
                    icon: Icon(
                      playlist?.isLooping == true
                          ? SpotubeIcons.repeatOne
                          : SpotubeIcons.repeat,
                    ),
                    style: playlist?.isLooping == true
                        ? activeButtonStyle
                        : buttonStyle,
                    onPressed: playlist == null || playlist.isLoading
                        ? null
                        : () {
                            if (playlist.isLooping == true) {
                              playlistNotifier.unloop();
                            } else {
                              playlistNotifier.loop();
                            }
                          },
                  ),
                ],
              ),
              const SizedBox(height: 5)
            ],
          ),
        ),
      ),
    );
  }
}
