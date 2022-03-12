import 'package:spotube/provider/Playback.dart';

Future<void> Function() useNextTrack(Playback playback) {
  return () async {
    try {
      await playback.player.pause();
      await playback.player.seek(Duration.zero);
      playback.movePlaylistPositionBy(1);
    } catch (e, stack) {
      print("[PlayerControls.onNext()] $e");
      print(stack);
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
      print("[PlayerControls.onPrevious()] $e");
      print(stack);
    }
  };
}

Future<void> Function([dynamic]) useTogglePlayPause(Playback playback) {
  return ([key]) async {
    print("CLICK CLICK");
    try {
      if (playback.currentTrack == null) return;
      playback.isPlaying
          ? await playback.player.pause()
          : await playback.player.play();
    } catch (e, stack) {
      print("[PlayPauseShortcut] $e");
      print(stack);
    }
  };
}
