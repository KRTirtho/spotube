import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/services/audio_player/audio_player.dart';

({
  double progressStatic,
  Duration position,
  Duration duration,
  double bufferProgress
}) useProgress(WidgetRef ref) {
  final bufferProgress =
      useStream(audioPlayer.bufferedPositionStream).data?.inSeconds ?? 0;

  Duration audioPlayerDuration = Duration.zero;
  Duration audioPlayerPosition = Duration.zero;

  // Duration future is needed for getting the duration of the song
  // as stream can be null when no event occurs (Mostly needed for android)
  audioPlayer.duration.then((value) {
    if (value != null) {
      audioPlayerDuration = value;
    }
  });

  audioPlayer.position.then((value) {
    if (value != null) {
      audioPlayerPosition = value;
    }
  });

  final position = useState<Duration>(audioPlayerPosition);
  final duration =
      useStream(audioPlayer.durationStream).data ?? audioPlayerDuration;
  final sliderMax = duration.inSeconds;
  final sliderValue = position.value.inSeconds;

  useEffect(() {
    // audioPlayer.positionStream is fired every 200ms and only 1s delay is
    // enough. Thus only update the position if the difference is more than 1s
    // Reduces CPU usage
    var lastPosition = position.value;
    return audioPlayer.positionStream.listen((event) {
      if (event.inMilliseconds > 1000 &&
          event.inMilliseconds - lastPosition.inMilliseconds < 1000) return;
      lastPosition = event;
      position.value = event;
    }).cancel;
  }, [audioPlayerPosition, audioPlayerDuration]);

  return (
    progressStatic:
        sliderMax == 0 || sliderValue > sliderMax ? 0 : sliderValue / sliderMax,
    position: position.value,
    duration: duration,
    bufferProgress: sliderMax == 0 || bufferProgress > sliderMax
        ? 0
        : bufferProgress / sliderMax,
  );
}
