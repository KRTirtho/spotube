import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotube/models/logger.dart';
import 'package:spotube/provider/playback_provider.dart';

final logger = getLogger("PlaybackHook");

Future<void> Function() useNextTrack(WidgetRef ref) {
  return () async {
    try {
      final playback = ref.read(playbackProvider);
      await playback.player.pause();
      await playback.player.seek(Duration.zero);
      playback.seekForward();
    } catch (e, stack) {
      logger.e("useNextTrack", e, stack);
    }
  };
}

Future<void> Function() usePreviousTrack(WidgetRef ref) {
  return () async {
    try {
      final playback = ref.read(playbackProvider);
      await playback.player.pause();
      await playback.player.seek(Duration.zero);
      playback.seekBackward();
    } catch (e, stack) {
      logger.e("onPrevious", e, stack);
    }
  };
}
