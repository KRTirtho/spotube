import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/provider/volume_provider.dart';

class VolumeSlider extends HookConsumerWidget {
  final bool fullWidth;
  const VolumeSlider({
    Key? key,
    this.fullWidth = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final volume = ref.watch(volumeProvider);
    final volumeNotifier = ref.watch(volumeProvider.notifier);

    var slider = Listener(
      onPointerSignal: (event) async {
        if (event is PointerScrollEvent) {
          if (event.scrollDelta.dy > 0) {
            final value = volume - .2;
            volumeNotifier.setVolume(value < 0 ? 0 : value);
          } else {
            final value = volume + .2;
            volumeNotifier.setVolume(value > 1 ? 1 : value);
          }
        }
      },
      child: Slider(
        min: 0,
        max: 1,
        value: volume,
        onChanged: volumeNotifier.setVolume,
      ),
    );
    return Row(
      mainAxisAlignment:
          !fullWidth ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: [
        IconButton(
          icon: Icon(
            volume == 0
                ? SpotubeIcons.volumeMute
                : volume <= 0.2
                    ? SpotubeIcons.volumeLow
                    : volume <= 0.6
                        ? SpotubeIcons.volumeMedium
                        : SpotubeIcons.volumeHigh,
            size: 16,
          ),
          onPressed: () {
            if (volume == 0) {
              volumeNotifier.setVolume(1);
            } else {
              volumeNotifier.setVolume(0);
            }
          },
        ),
        if (fullWidth) Expanded(child: slider) else slider,
      ],
    );
  }
}
