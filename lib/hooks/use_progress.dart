import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/provider/playlist_queue_provider.dart';
import 'package:tuple/tuple.dart';

Tuple3<double, Duration, Duration> useProgress(WidgetRef ref) {
  ref.watch(PlaylistQueueNotifier.provider);

  final playlistNotifier = ref.watch(PlaylistQueueNotifier.notifier);

  final duration =
      useStream(PlaylistQueueNotifier.duration).data ?? Duration.zero;
  final positionSnapshot = useStream(PlaylistQueueNotifier.position);

  final position = positionSnapshot.data ?? Duration.zero;

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

  return Tuple3(
    sliderMax == 0 || sliderValue > sliderMax ? 0 : sliderValue / sliderMax,
    position,
    duration,
  );
}
