import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:spotube/provider/playlist_queue_provider.dart';
import 'package:spotube/services/audio_player.dart';

class MobileAudioService extends BaseAudioHandler {
  AudioSession? session;
  final PlaylistQueueNotifier playlistNotifier;

  PlaylistQueue? get playlist => playlistNotifier.state;

  MobileAudioService(this.playlistNotifier) {
    AudioSession.instance.then((s) {
      session = s;
      s.interruptionEventStream.listen((event) async {
        if (event.type != AudioInterruptionType.duck) {
          await playlistNotifier.pause();
        }
      });
    });
    audioPlayer.onPlayerStateChanged.listen((state) async {
      if (state != PlayerState.completed) {
        playbackState.add(await _transformEvent());
      }
    });

    audioPlayer.onPositionChanged.listen((pos) async {
      playbackState.add(await _transformEvent());
    });
  }

  void addItem(MediaItem item) {
    session?.setActive(true);
    mediaItem.add(item);
  }

  @override
  Future<void> play() => playlistNotifier.resume();

  @override
  Future<void> pause() => playlistNotifier.pause();

  @override
  Future<void> seek(Duration position) => playlistNotifier.seek(position);

  @override
  Future<void> stop() async {
    await playlistNotifier.stop();
  }

  @override
  Future<void> skipToNext() async {
    await playlistNotifier.next();
    await super.skipToNext();
  }

  @override
  Future<void> skipToPrevious() async {
    await playlistNotifier.previous();
    await super.skipToPrevious();
  }

  @override
  Future<void> onTaskRemoved() async {
    await playlistNotifier.stop();
    await audioPlayer.release();
    return super.onTaskRemoved();
  }

  Future<PlaybackState> _transformEvent() async {
    return PlaybackState(
      controls: [
        MediaControl.skipToPrevious,
        audioPlayer.state == PlayerState.playing
            ? MediaControl.pause
            : MediaControl.play,
        MediaControl.skipToNext,
        MediaControl.stop,
      ],
      systemActions: {
        MediaAction.seek,
      },
      androidCompactActionIndices: const [0, 1, 2],
      playing: audioPlayer.state == PlayerState.playing,
      updatePosition: (await audioPlayer.getCurrentPosition()) ?? Duration.zero,
      processingState: audioPlayer.state == PlayerState.paused
          ? AudioProcessingState.buffering
          : audioPlayer.state == PlayerState.playing
              ? AudioProcessingState.ready
              : AudioProcessingState.idle,
    );
  }
}
