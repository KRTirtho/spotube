import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import 'package:palette_generator/palette_generator.dart';

import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/collections/intents.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/extensions/duration.dart';
import 'package:spotube/modules/player/use_progress.dart';
import 'package:spotube/provider/audio_player/audio_player.dart';
import 'package:spotube/provider/audio_player/querying_track_info.dart';
import 'package:spotube/services/audio_player/audio_player.dart';

class PlayerControls extends HookConsumerWidget {
  final PaletteGenerator? palette;
  final bool compact;

  const PlayerControls({
    this.palette,
    this.compact = false,
    super.key,
  });

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
    final isFetchingActiveTrack = ref.watch(queryingTrackInfoProvider);

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
                            onChanged: isFetchingActiveTrack
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
                  Consumer(builder: (context, ref, _) {
                    final shuffled = ref
                        .watch(audioPlayerProvider.select((s) => s.shuffled));
                    return IconButton(
                      tooltip: shuffled
                          ? context.l10n.unshuffle_playlist
                          : context.l10n.shuffle_playlist,
                      icon: const Icon(SpotubeIcons.shuffle),
                      style: shuffled ? activeButtonStyle : buttonStyle,
                      onPressed: isFetchingActiveTrack
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
                    onPressed: isFetchingActiveTrack
                        ? null
                        : audioPlayer.skipToPrevious,
                  ),
                  IconButton(
                    tooltip: playing
                        ? context.l10n.pause_playback
                        : context.l10n.resume_playback,
                    icon: isFetchingActiveTrack
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
                    onPressed: isFetchingActiveTrack
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
                    onPressed:
                        isFetchingActiveTrack ? null : audioPlayer.skipToNext,
                  ),
                  Consumer(builder: (context, ref, _) {
                    final loopMode = ref
                        .watch(audioPlayerProvider.select((s) => s.loopMode));

                    return IconButton(
                      tooltip: loopMode == PlaylistMode.single
                          ? context.l10n.loop_track
                          : loopMode == PlaylistMode.loop
                              ? context.l10n.repeat_playlist
                              : null,
                      icon: Icon(
                        loopMode == PlaylistMode.single
                            ? SpotubeIcons.repeatOne
                            : SpotubeIcons.repeat,
                      ),
                      style: loopMode == PlaylistMode.single ||
                              loopMode == PlaylistMode.loop
                          ? activeButtonStyle
                          : buttonStyle,
                      onPressed: isFetchingActiveTrack
                          ? null
                          : () async {
                              await audioPlayer.setLoopMode(
                                switch (loopMode) {
                                  PlaylistMode.loop => PlaylistMode.single,
                                  PlaylistMode.single => PlaylistMode.none,
                                  PlaylistMode.none => PlaylistMode.loop,
                                },
                              );
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
