import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:spotube/provider/Playback.dart';

class MobileAudioService extends BaseAudioHandler {
  final Playback playback;

  MobileAudioService(this.playback) {
    final _player = playback.player;
    _player.onPlayerStateChanged.listen((state) async {
      if (state != PlayerState.completed) {
        playbackState.add(await _transformEvent());
      }
    });

    _player.onPositionChanged.listen((pos) async {
      playbackState.add(await _transformEvent());
    });

    _player.onPlayerComplete.listen((_) {
      if (playback.playlist == null && playback.track == null) {
        playbackState.add(
          PlaybackState(
            processingState: AudioProcessingState.completed,
          ),
        );
      }
    });
  }

  void addItem(MediaItem item) {
    mediaItem.add(item);
  }

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

  Future<PlaybackState> _transformEvent() async {
    return PlaybackState(
      controls: [
        MediaControl.skipToPrevious,
        playback.player.state == PlayerState.playing
            ? MediaControl.pause
            : MediaControl.play,
        MediaControl.skipToNext,
        MediaControl.stop,
      ],
      systemActions: {
        MediaAction.seek,
      },
      androidCompactActionIndices: const [0, 1, 2],
      playing: playback.player.state == PlayerState.playing,
      updatePosition:
          (await playback.player.getCurrentPosition()) ?? Duration.zero,
      processingState: playback.player.state == PlayerState.paused
          ? AudioProcessingState.buffering
          : playback.player.state == PlayerState.playing
              ? AudioProcessingState.ready
              : AudioProcessingState.idle,
    );
  }
}
