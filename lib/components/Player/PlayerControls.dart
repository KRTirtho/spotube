import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:spotube/helpers/zero-pad-num-str.dart';
import 'package:spotube/hooks/playback.dart';
import 'package:spotube/models/Logger.dart';
import 'package:spotube/provider/Playback.dart';

class PlayerControls extends HookConsumerWidget {
  final Color? iconColor;
  PlayerControls({
    this.iconColor,
    Key? key,
  }) : super(key: key);

  final logger = getLogger(PlayerControls);

  @override
  Widget build(BuildContext context, ref) {
    final Playback playback = ref.watch(playbackProvider);
    final AudioPlayer player = playback.player;

    final onNext = useNextTrack(playback);

    final onPrevious = usePreviousTrack(playback);

    final _playOrPause = useTogglePlayPause(playback);

    final duration = playback.duration ?? Duration.zero;

    return Container(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Column(
          children: [
            StreamBuilder<Duration>(
                stream: player.positionStream.isBroadcast
                    ? player.positionStream
                    : player.positionStream.asBroadcastStream(),
                builder: (context, snapshot) {
                  final totalMinutes =
                      zeroPadNumStr(duration.inMinutes.remainder(60));
                  final totalSeconds =
                      zeroPadNumStr(duration.inSeconds.remainder(60));
                  final currentMinutes = snapshot.hasData
                      ? zeroPadNumStr(snapshot.data!.inMinutes.remainder(60))
                      : "00";
                  final currentSeconds = snapshot.hasData
                      ? zeroPadNumStr(snapshot.data!.inSeconds.remainder(60))
                      : "00";

                  final sliderMax = duration.inSeconds;
                  final sliderValue = snapshot.data?.inSeconds ?? 0;
                  return Column(
                    children: [
                      Slider.adaptive(
                        // cannot divide by zero
                        // there's an edge case for value being bigger
                        // than total duration. Keeping it resolved
                        value: (sliderMax == 0 || sliderValue > sliderMax)
                            ? 0
                            : sliderValue / sliderMax,
                        onChanged: (value) {},
                        onChangeEnd: (value) {
                          player.seek(
                            Duration(
                              seconds: (value * sliderMax).toInt(),
                            ),
                          );
                        },
                        activeColor: iconColor,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "$currentMinutes:$currentSeconds",
                            ),
                            Text("$totalMinutes:$totalSeconds"),
                          ],
                        ),
                      ),
                    ],
                  );
                }),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                    icon: const Icon(Icons.shuffle_rounded),
                    color: playback.shuffled
                        ? Theme.of(context).primaryColor
                        : iconColor,
                    onPressed: () {
                      if (playback.currentTrack == null ||
                          playback.currentPlaylist == null) {
                        return;
                      }
                      try {
                        if (!playback.shuffled) {
                          playback.shuffle();
                        } else {
                          playback.unshuffle();
                        }
                      } catch (e, stack) {
                        logger.e("onShuffle", e, stack);
                      }
                    }),
                IconButton(
                    icon: const Icon(Icons.skip_previous_rounded),
                    color: iconColor,
                    onPressed: () {
                      onPrevious();
                    }),
                IconButton(
                  icon: Icon(
                    playback.isPlaying
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                  ),
                  color: iconColor,
                  onPressed: _playOrPause,
                ),
                IconButton(
                  icon: const Icon(Icons.skip_next_rounded),
                  onPressed: () => onNext(),
                  color: iconColor,
                ),
                IconButton(
                  icon: const Icon(Icons.stop_rounded),
                  color: iconColor,
                  onPressed: playback.currentTrack != null
                      ? () async {
                          try {
                            await player.pause();
                            await player.seek(Duration.zero);
                            playback.reset();
                          } catch (e, stack) {
                            logger.e("onStop", e, stack);
                          }
                        }
                      : null,
                )
              ],
            ),
          ],
        ));
  }
}
