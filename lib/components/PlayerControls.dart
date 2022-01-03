import 'package:flutter/material.dart';
import 'package:mpv_dart/mpv_dart.dart';

class PlayerControls extends StatefulWidget {
  final MPVPlayer player;
  final bool isPlaying;
  final double duration;
  final Function? onStop;
  const PlayerControls({
    required this.player,
    required this.isPlaying,
    required this.duration,
    this.onStop,
    Key? key,
  }) : super(key: key);

  @override
  _PlayerControlsState createState() => _PlayerControlsState();
}

class _PlayerControlsState extends State<PlayerControls> {
  double currentPos = 0;

  @override
  void initState() {
    super.initState();
    widget.player.on(MPVEvents.timeposition, null, (ev, context) {
      widget.player.getPercentPosition().then((value) {
        setState(() {
          currentPos = value / 100;
        });
      });
    });
  }

  @override
  void dispose() {
    widget.player.removeAllByEvent(MPVEvents.timeposition);
    super.dispose();
  }

  String zeroPadNumStr(int input) {
    return input < 10 ? "0$input" : input.toString();
  }

  @override
  Widget build(BuildContext context) {
    var totalDuration = Duration(seconds: widget.duration.toInt());
    var totalMinutes = zeroPadNumStr(totalDuration.inMinutes.remainder(60));
    var totalSeconds = zeroPadNumStr(totalDuration.inSeconds.remainder(60));

    var currentDuration =
        Duration(seconds: (widget.duration * currentPos).toInt());

    var currentMinutes = zeroPadNumStr(currentDuration.inMinutes.remainder(60));
    var currentSeconds = zeroPadNumStr(currentDuration.inSeconds.remainder(60));

    return Container(
      constraints: const BoxConstraints(maxWidth: 700),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Slider.adaptive(
                  value: currentPos,
                  onChanged: (value) async {
                    try {
                      setState(() {
                        currentPos = value;
                      });
                      await widget.player.goToPosition(value * widget.duration);
                    } catch (e) {
                      print("[PlayerControls]: $e");
                    }
                  },
                ),
              ),
              Text(
                "$currentMinutes:$currentSeconds/$totalMinutes:$totalSeconds",
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                  icon: const Icon(Icons.shuffle_rounded),
                  onPressed: () async {
                    await widget.player.shuffle();
                  }),
              IconButton(
                  icon: const Icon(Icons.skip_previous_rounded),
                  onPressed: () async {
                    bool moved = await widget.player.prev();
                    if (moved) {
                      setState(() {
                        currentPos = 0;
                      });
                    }
                  }),
              IconButton(
                  icon: Icon(
                    widget.isPlaying
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                  ),
                  onPressed: () async {
                    widget.isPlaying
                        ? await widget.player.pause()
                        : await widget.player.play();
                  }),
              IconButton(
                  icon: const Icon(Icons.skip_next_rounded),
                  onPressed: () async {
                    bool moved = await widget.player.next();
                    if (moved) {
                      setState(() {
                        currentPos = 0;
                      });
                    }
                  }),
              IconButton(
                icon: const Icon(Icons.stop_rounded),
                onPressed: () async {
                  await widget.player.stop();
                  widget.onStop?.call();
                  setState(() {
                    currentPos = 0;
                  });
                },
              )
            ],
          )
        ],
      ),
    );
  }
}
