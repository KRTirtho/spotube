import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:spotube/helpers/zero-pad-num-str.dart';
import 'package:spotube/models/GlobalKeyActions.dart';
import 'package:spotube/provider/UserPreferences.dart';

class PlayerControls extends ConsumerStatefulWidget {
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

  @override
  _PlayerControlsState createState() => _PlayerControlsState();
}

class _PlayerControlsState extends ConsumerState<PlayerControls> {
  StreamSubscription? _timePositionListener;
  late List<GlobalKeyActions> _hotKeys = [];

  @override
  void dispose() async {
    await _timePositionListener?.cancel();
    Future.wait(_hotKeys.map((e) => hotKeyManager.unregister(e.hotKey)));
    super.dispose();
  }

  _playOrPause(key) async {
    try {
      widget.isPlaying ? widget.onPause?.call() : await widget.onPlay?.call();
    } catch (e, stack) {
      print("[PlayPauseShortcut] $e");
      print(stack);
    }
  }

  _configureHotKeys(UserPreferences preferences) async {
    await Future.wait(_hotKeys.map((e) => hotKeyManager.unregister(e.hotKey)))
        .then((val) async {
      _hotKeys = [
        GlobalKeyActions(
          HotKey(KeyCode.space, scope: HotKeyScope.inapp),
          _playOrPause,
        ),
        if (preferences.nextTrackHotKey != null)
          GlobalKeyActions(
              preferences.nextTrackHotKey!, (key) => widget.onNext?.call()),
        if (preferences.prevTrackHotKey != null)
          GlobalKeyActions(
              preferences.prevTrackHotKey!, (key) => widget.onPrevious?.call()),
        if (preferences.playPauseHotKey != null)
          GlobalKeyActions(preferences.playPauseHotKey!, _playOrPause)
      ];
      await Future.wait(
        _hotKeys.map((e) {
          return hotKeyManager.register(
            e.hotKey,
            keyDownHandler: e.onKeyDown,
          );
        }),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    UserPreferences preferences = ref.watch(userPreferencesProvider);
    _configureHotKeys(preferences);

    return Container(
      constraints: const BoxConstraints(maxWidth: 700),
      child: Column(
        children: [
          StreamBuilder<Duration>(
              stream: widget.positionStream,
              builder: (context, snapshot) {
                var totalMinutes =
                    zeroPadNumStr(widget.duration.inMinutes.remainder(60));
                var totalSeconds =
                    zeroPadNumStr(widget.duration.inSeconds.remainder(60));
                var currentMinutes = snapshot.hasData
                    ? zeroPadNumStr(snapshot.data!.inMinutes.remainder(60))
                    : "00";
                var currentSeconds = snapshot.hasData
                    ? zeroPadNumStr(snapshot.data!.inSeconds.remainder(60))
                    : "00";

                var sliderMax = widget.duration.inSeconds;
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
                          widget.onSeek?.call(value * sliderMax);
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
                  color:
                      widget.shuffled ? Theme.of(context).primaryColor : null,
                  onPressed: () {
                    widget.onShuffle?.call();
                  }),
              IconButton(
                  icon: const Icon(Icons.skip_previous_rounded),
                  onPressed: () {
                    widget.onPrevious?.call();
                  }),
              IconButton(
                icon: Icon(
                  widget.isPlaying
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded,
                ),
                onPressed: () => _playOrPause(null),
              ),
              IconButton(
                  icon: const Icon(Icons.skip_next_rounded),
                  onPressed: () => widget.onNext?.call()),
              IconButton(
                icon: const Icon(Icons.stop_rounded),
                onPressed: () => widget.onStop?.call(),
              )
            ],
          )
        ],
      ),
    );
  }
}
