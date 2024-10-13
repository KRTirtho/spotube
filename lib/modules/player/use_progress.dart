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

  final duration = useState(Duration.zero);
  final position = useState(Duration.zero);

  final sliderMax = duration.value.inSeconds;
  final sliderValue = position.value.inSeconds;

  useEffect(() {
    duration.value = audioPlayer.duration;

    final durationSubscription = audioPlayer.durationStream.listen((event) {
      duration.value = event;
    });

    position.value = audioPlayer.position;

    var lastPosition = position.value;

    // audioPlayer.positionStream is fired every 200ms and only 1s delay is
    // enough. Thus only update the position if the difference is more than 1s
    // Reduces CPU usage
    final positionSubscription = audioPlayer.positionStream.listen((event) {
      final diff = event.inMilliseconds - lastPosition.inMilliseconds;
      if (event.inMilliseconds > 1000 && diff < 1000 && diff > 0) return;

      lastPosition = event;
      position.value = event;
    });

    return () {
      positionSubscription.cancel();
      durationSubscription.cancel();
    };
  }, []);

  return (
    progressStatic:
        sliderMax == 0 || sliderValue > sliderMax ? 0 : sliderValue / sliderMax,
    position: position.value,
    duration: duration.value,
    bufferProgress: sliderMax == 0 || bufferProgress > sliderMax
        ? 0
        : bufferProgress / sliderMax,
  );
}
