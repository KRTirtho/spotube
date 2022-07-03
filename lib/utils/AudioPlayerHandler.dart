import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:spotube/provider/Playback.dart';

/// An [AudioHandler] for playing a single item.
class AudioPlayerHandler extends BaseAudioHandler {
  final Playback playback;

  /// Initialise our audio handler.
  AudioPlayerHandler(this.playback) {
    final _player = playback.player;
    // So that our clients (the Flutter UI and the system notification) know
    // what state to display, here we set up our audio handler to broadcast all
    // playback state changes as they happen via playbackState...
    // _player.
    _player.onPlayerStateChanged.listen((state) async {
      playbackState.add(await _transformEvent());
    });
    _player.onDurationChanged.listen((duration) async {
      playbackState.add(await _transformEvent());
    });
    _player.onPositionChanged.listen((state) async {
      playbackState.add(await _transformEvent());
    });
  }

  void addItem(MediaItem item) {
    mediaItem.add(item);
  }

  // In this simple example, we handle only 4 actions: play, pause, seek and
  // stop. Any button press from the Flutter UI, notification, lock screen or
  // headset will be routed through to these 4 methods so that you can handle
  // your audio playback logic in one place.

  @override
  Future<void> play() => playback.resume();

  @override
  Future<void> pause() => playback.pause();

  @override
  Future<void> seek(Duration position) => playback.seekPosition(position);

  @override
  Future<void> stop() => playback.stop();

  @override
  Future<void> skipToNext() async {
    playback.seekForward();
    await super.skipToNext();
  }

  @override
  Future<void> skipToPrevious() async {
    playback.seekBackward();
    await super.skipToPrevious();
  }

  @override
  Future<void> onTaskRemoved() {
    playback.destroy();
    return super.onTaskRemoved();
  }

  /// Transform a just_audio event into an audio_service state.
  ///
  /// This method is used from the constructor. Every event received from the
  /// just_audio player will be transformed into an audio_service state so that
  /// it can be broadcast to audio_service clients.
  Future<PlaybackState> _transformEvent() async {
    return PlaybackState(
      controls: [
        MediaControl.skipToPrevious,
        if (playback.isPlaying) MediaControl.pause else MediaControl.play,
        MediaControl.skipToNext,
        MediaControl.stop,
      ],
      androidCompactActionIndices: const [0, 1, 2],
      playing: playback.isPlaying,
      updatePosition:
          (await playback.player.getCurrentPosition()) ?? Duration.zero,
    );
  }
}
