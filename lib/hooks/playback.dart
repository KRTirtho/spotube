import 'package:spotube/models/Logger.dart';
import 'package:spotube/provider/Playback.dart';

final logger = createLogger("PlaybackHook");

Future<void> Function() useNextTrack(Playback playback) {
  return () async {
    try {
      await playback.player.pause();
      await playback.player.seek(Duration.zero);
      playback.movePlaylistPositionBy(1);
    } catch (e, stack) {
      logger.e("useNextTrack", e, stack);
    }
  };
}

Future<void> Function() usePreviousTrack(Playback playback) {
  return () async {
    try {
      await playback.player.pause();
      await playback.player.seek(Duration.zero);
      playback.movePlaylistPositionBy(-1);
    } catch (e, stack) {
      logger.e("onPrevious", e, stack);
    }
  };
}

Future<void> Function([dynamic]) useTogglePlayPause(Playback playback) {
  return ([key]) async {
    try {
      if (playback.currentTrack == null) return;
      playback.isPlaying
          ? await playback.player.pause()
          : await playback.player.play();
    } catch (e, stack) {
      logger.e("useTogglePlayPause", e, stack);
    }
  };
}
