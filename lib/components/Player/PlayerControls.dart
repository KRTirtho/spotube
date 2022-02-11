import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:spotube/helpers/zero-pad-num-str.dart';
import 'package:spotube/models/GlobalKeyActions.dart';
import 'package:spotube/provider/UserPreferences.dart';

class PlayerControls extends HookConsumerWidget {
  final Stream<Duration> positionStream;
  final bool isPlaying;
  final Duration duration;
  final bool shuffled;
  final Function? onStop;
  final Function? onShuffle;
  final Function(double value)? onSeek;
  final Function? onNext;
  final Function? onPrevious;
  final Function? onPlay;
  final Function? onPause;
  const PlayerControls({
    required this.positionStream,
    required this.isPlaying,
    required this.duration,
    required this.shuffled,
    this.onShuffle,
    this.onStop,
    this.onSeek,
    this.onNext,
    this.onPrevious,
    this.onPlay,
    this.onPause,
    Key? key,
  }) : super(key: key);

  _playOrPause(key) async {
    try {
      isPlaying ? await onPause?.call() : await onPlay?.call();
    } catch (e, stack) {
      print("[PlayPauseShortcut] $e");
      print(stack);
    }
  }

  @override
  Widget build(BuildContext context, ref) {
    UserPreferences preferences = ref.watch(userPreferencesProvider);

    var _hotKeys = [];
    useEffect(() {
      _hotKeys = [
        GlobalKeyActions(
          HotKey(KeyCode.space, scope: HotKeyScope.inapp),
          _playOrPause,
        ),
        if (preferences.nextTrackHotKey != null)
          GlobalKeyActions(
              preferences.nextTrackHotKey!, (key) => onNext?.call()),
        if (preferences.prevTrackHotKey != null)
          GlobalKeyActions(
              preferences.prevTrackHotKey!, (key) => onPrevious?.call()),
        if (preferences.playPauseHotKey != null)
          GlobalKeyActions(preferences.playPauseHotKey!, _playOrPause)
      ];
      Future.wait(
        _hotKeys.map((e) {
          return hotKeyManager.register(
            e.hotKey,
            keyDownHandler: e.onKeyDown,
          );
        }),
      );
      return () {
        Future.wait(_hotKeys.map((e) => hotKeyManager.unregister(e.hotKey)));
      };
    });

    return Container(
      constraints: const BoxConstraints(maxWidth: 700),
      child: Column(
        children: [
          StreamBuilder<Duration>(
              stream: positionStream,
              builder: (context, snapshot) {
                var totalMinutes =
                    zeroPadNumStr(duration.inMinutes.remainder(60));
                var totalSeconds =
                    zeroPadNumStr(duration.inSeconds.remainder(60));
                var currentMinutes = snapshot.hasData
                    ? zeroPadNumStr(snapshot.data!.inMinutes.remainder(60))
                    : "00";
                var currentSeconds = snapshot.hasData
                    ? zeroPadNumStr(snapshot.data!.inSeconds.remainder(60))
                    : "00";

                var sliderMax = duration.inSeconds;
                var sliderValue = snapshot.data?.inSeconds ?? 0;
                return Row(
                  children: [
                    Expanded(
                      child: Slider.adaptive(
                        // cannot divide by zero
                        // there's an edge case for value being bigger
                        // than total duration. Keeping it resolved
                        value: (sliderMax == 0 || sliderValue > sliderMax)
                            ? 0
                            : sliderValue / sliderMax,
                        onChanged: (value) {},
                        onChangeEnd: (value) {
                          onSeek?.call(value * sliderMax);
                        },
                      ),
                    ),
                    Text(
                      "$currentMinutes:$currentSeconds/$totalMinutes:$totalSeconds",
                    )
                  ],
                );
              }),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                  icon: const Icon(Icons.shuffle_rounded),
                  color: shuffled ? Theme.of(context).primaryColor : null,
                  onPressed: () {
                    onShuffle?.call();
                  }),
              IconButton(
                  icon: const Icon(Icons.skip_previous_rounded),
                  onPressed: () {
                    onPrevious?.call();
                  }),
              IconButton(
                icon: Icon(
                  isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                ),
                onPressed: () => _playOrPause(null),
              ),
              IconButton(
                  icon: const Icon(Icons.skip_next_rounded),
                  onPressed: () => onNext?.call()),
              IconButton(
                icon: const Icon(Icons.stop_rounded),
                onPressed: () => onStop?.call(),
              )
            ],
          )
        ],
      ),
    );
  }
}
