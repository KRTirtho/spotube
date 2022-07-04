import 'package:spotify/spotify.dart';
import 'package:spotube/models/Logger.dart';
import 'package:spotube/provider/Playback.dart';

final logger = getLogger("PlaybackHook");

Future<void> Function() useNextTrack(Playback playback) {
  return () async {
    try {
      await playback.player.pause();
      await playback.player.seek(Duration.zero);
      playback.seekForward();
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
      playback.seekBackward();
    } catch (e, stack) {
      logger.e("onPrevious", e, stack);
    }
  };
}

Future<void> Function([dynamic]) useTogglePlayPause(Playback playback) {
  return ([key]) async {
    try {
      if (playback.track == null) {
        return;
      } else if (playback.track != null &&
          playback.currentDuration == Duration.zero &&
          await playback.player.getCurrentPosition() == Duration.zero) {
        final track = Track.fromJson(playback.track!.toJson());
        playback.track = null;
        await playback.play(track);
      } else {
        await playback.togglePlayPause();
      }
    } catch (e, stack) {
      logger.e("useTogglePlayPause", e, stack);
    }
  };
}
