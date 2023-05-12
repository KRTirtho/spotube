import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/provider/playlist_queue_provider.dart';
import 'package:spotube/services/audio_player/audio_player.dart';
import 'package:tuple/tuple.dart';

Tuple4<double, Duration, Duration, double> useProgress(WidgetRef ref) {
  ref.watch(PlaylistQueueNotifier.provider);

  final bufferProgress =
      useStream(audioPlayer.bufferedPositionStream).data?.inSeconds ?? 0;
  final playlistNotifier = ref.watch(PlaylistQueueNotifier.notifier);

  // Duration future is needed for getting the duration of the song
  // as stream can be null when no event occurs (Mostly needed for android)
  final durationFuture = useFuture(audioPlayer.duration);
  final duration = useStream(audioPlayer.durationStream).data ??
      durationFuture.data ??
      Duration.zero;
  final positionFuture = useFuture(audioPlayer.position);
  final positionSnapshot = useStream(audioPlayer.positionStream);

  final position =
      positionSnapshot.data ?? positionFuture.data ?? Duration.zero;

  final sliderMax = duration.inSeconds;
  final sliderValue = position.inSeconds;

  // this is a hack to fix duration not being updated
  useEffect(() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (positionSnapshot.hasData && duration == Duration.zero) {
        await Future.delayed(const Duration(milliseconds: 200));
        await playlistNotifier.pause();
        await Future.delayed(const Duration(milliseconds: 400));
        await playlistNotifier.resume();
      }
    });
    return null;
  }, [positionSnapshot.hasData, duration]);

  return Tuple4(
    sliderMax == 0 || sliderValue > sliderMax ? 0 : sliderValue / sliderMax,
    position,
    duration,
    sliderMax == 0 || bufferProgress > sliderMax
        ? 0
        : bufferProgress / sliderMax,
  );
}
