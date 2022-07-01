import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';

/// An [AudioHandler] for playing a single item.
class AudioPlayerHandler extends BaseAudioHandler {
  final _player = AudioPlayer();

  FutureOr<void> Function()? onNextRequest;
  FutureOr<void> Function()? onPreviousRequest;

  /// Initialise our audio handler.
  AudioPlayerHandler() {
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

  AudioPlayer get core => _player;

  void addItem(MediaItem item) {
    mediaItem.add(item);
  }

  // In this simple example, we handle only 4 actions: play, pause, seek and
  // stop. Any button press from the Flutter UI, notification, lock screen or
  // headset will be routed through to these 4 methods so that you can handle
  // your audio playback logic in one place.

  @override
  Future<void> play() => _player.resume();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> stop() => _player.stop();

  @override
  Future<void> skipToNext() async {
    await onNextRequest?.call();
    await super.skipToNext();
  }

  @override
  Future<void> skipToPrevious() async {
    await onPreviousRequest?.call();
    await super.skipToPrevious();
  }

  @override
  Future<void> onTaskRemoved() {
    _player.stop();
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
        if (_player.state == PlayerState.playing)
          MediaControl.pause
        else
          MediaControl.play,
        MediaControl.skipToNext,
        MediaControl.stop,
      ],
      androidCompactActionIndices: const [0, 1, 2],
      playing: _player.state == PlayerState.playing,
      updatePosition: (await _player.getCurrentPosition()) ?? Duration.zero,
    );
  }
}
