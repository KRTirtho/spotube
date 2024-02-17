import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:palette_generator/palette_generator.dart';

import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/collections/intents.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/extensions/duration.dart';
import 'package:spotube/components/player/use_progress.dart';
import 'package:spotube/models/logger.dart';
import 'package:spotube/provider/proxy_playlist/proxy_playlist_provider.dart';
import 'package:spotube/services/audio_player/audio_player.dart';
import 'package:spotube/services/audio_player/loop_mode.dart';

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
    final playlist = ref.watch(ProxyPlaylistNotifier.provider);
    final playlistNotifier = ref.watch(ProxyPlaylistNotifier.notifier);

    final playing =
        useStream(audioPlayer.playingStream).data ?? audioPlayer.isPlaying;
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
                    final (
                      :bufferProgress,
                      :duration,
                      :position,
                      :progressStatic
                    ) = useProgress(ref);

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
                          message: context.l10n.slide_to_seek,
                          child: Slider(
                            // cannot divide by zero
                            // there's an edge case for value being bigger
                            // than total duration. Keeping it resolved
                            value: progress.value.toDouble(),
                            secondaryTrackValue: bufferProgress,
                            onChanged: playlist.isFetching == true
                                ? null
                                : (v) {
                                    progress.value = v;
                                  },
                            onChangeEnd: (value) async {
                              await audioPlayer.seek(
                                Duration(
                                  seconds: (value * duration.inSeconds).toInt(),
                                ),
                              );
                            },
                            activeColor: sliderColor,
                            secondaryActiveColor: sliderColor.withOpacity(0.2),
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
                                Text(position.toHumanReadableString()),
                                Text(duration.toHumanReadableString()),
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
                  StreamBuilder<bool>(
                      stream: audioPlayer.shuffledStream,
                      builder: (context, snapshot) {
                        final shuffled = snapshot.data ?? false;
                        return IconButton(
                          tooltip: shuffled
                              ? context.l10n.unshuffle_playlist
                              : context.l10n.shuffle_playlist,
                          icon: const Icon(SpotubeIcons.shuffle),
                          style: shuffled ? activeButtonStyle : buttonStyle,
                          onPressed: playlist.isFetching == true
                              ? null
                              : () {
                                  if (shuffled) {
                                    audioPlayer.setShuffle(false);
                                  } else {
                                    audioPlayer.setShuffle(true);
                                  }
                                },
                        );
                      }),
                  IconButton(
                    tooltip: context.l10n.previous_track,
                    icon: const Icon(SpotubeIcons.skipBack),
                    style: buttonStyle,
                    onPressed: playlist.isFetching == true
                        ? null
                        : playlistNotifier.previous,
                  ),
                  IconButton(
                    tooltip: playing
                        ? context.l10n.pause_playback
                        : context.l10n.resume_playback,
                    icon: playlist.isFetching == true
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: accentColor?.titleTextColor ??
                                  theme.colorScheme.onPrimary,
                            ),
                          )
                        : Icon(
                            playing ? SpotubeIcons.pause : SpotubeIcons.play,
                          ),
                    style: resumePauseStyle,
                    onPressed: playlist.isFetching == true
                        ? null
                        : Actions.handler<PlayPauseIntent>(
                            context,
                            PlayPauseIntent(ref),
                          ),
                  ),
                  IconButton(
                    tooltip: context.l10n.next_track,
                    icon: const Icon(SpotubeIcons.skipForward),
                    style: buttonStyle,
                    onPressed: playlist.isFetching == true
                        ? null
                        : playlistNotifier.next,
                  ),
                  StreamBuilder<PlaybackLoopMode>(
                      stream: audioPlayer.loopModeStream,
                      builder: (context, snapshot) {
                        final loopMode = snapshot.data ?? PlaybackLoopMode.none;
                        return IconButton(
                          tooltip: loopMode == PlaybackLoopMode.one
                              ? context.l10n.loop_track
                              : loopMode == PlaybackLoopMode.all
                                  ? context.l10n.repeat_playlist
                                  : null,
                          icon: Icon(
                            loopMode == PlaybackLoopMode.one
                                ? SpotubeIcons.repeatOne
                                : SpotubeIcons.repeat,
                          ),
                          style: loopMode == PlaybackLoopMode.one ||
                                  loopMode == PlaybackLoopMode.all
                              ? activeButtonStyle
                              : buttonStyle,
                          onPressed: playlist.isFetching == true
                              ? null
                              : () async {
                                  switch (await audioPlayer.loopMode) {
                                    case PlaybackLoopMode.all:
                                      audioPlayer
                                          .setLoopMode(PlaybackLoopMode.one);
                                      break;
                                    case PlaybackLoopMode.one:
                                      audioPlayer
                                          .setLoopMode(PlaybackLoopMode.none);
                                      break;
                                    case PlaybackLoopMode.none:
                                      audioPlayer
                                          .setLoopMode(PlaybackLoopMode.all);
                                      break;
                                  }
                                },
                        );
                      }),
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
