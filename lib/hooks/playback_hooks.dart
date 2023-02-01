import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotube/provider/playback_provider.dart';

Future<void> Function() useNextTrack(WidgetRef ref) {
  return () async {
    final playback = ref.read(playbackProvider);
    await playback.player.pause();
    await playback.player.seek(Duration.zero);
    playback.seekForward();
  };
}

Future<void> Function() usePreviousTrack(WidgetRef ref) {
  return () async {
    final playback = ref.read(playbackProvider);
    await playback.player.pause();
    await playback.player.seek(Duration.zero);
    playback.seekBackward();
  };
}
