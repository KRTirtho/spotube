import 'dart:async';

import 'package:audioplayers/audioplayers.dart' as ap;

final audioPlayer = SpotubeAudioPlayer();

enum PlayerState {
  playing,
  paused,
  completed,
  buffering,
  stopped;

  static PlayerState fromApPlayerState(ap.PlayerState state) {
    switch (state) {
      case ap.PlayerState.playing:
        return PlayerState.playing;
      case ap.PlayerState.paused:
        return PlayerState.paused;
      case ap.PlayerState.stopped:
        return PlayerState.stopped;
      case ap.PlayerState.completed:
        return PlayerState.completed;
    }
  }

  ap.PlayerState get asAudioPlayerPlayerState {
    switch (this) {
      case PlayerState.playing:
        return ap.PlayerState.playing;
      case PlayerState.paused:
        return ap.PlayerState.paused;
      case PlayerState.stopped:
        return ap.PlayerState.stopped;
      case PlayerState.completed:
        return ap.PlayerState.completed;
      case PlayerState.buffering:
        return ap.PlayerState.paused;
    }
  }
}

class SpotubeAudioPlayer {
  final ap.AudioPlayer? _audioPlayer;

  SpotubeAudioPlayer()
      : _audioPlayer = apSupportedPlatform ? ap.AudioPlayer() : null;

  /// Whether the current platform supports the audioplayers plugin
  static const bool apSupportedPlatform = true;

  // stream getters
  Stream<Duration> get durationStream {
    if (apSupportedPlatform) {
      return _audioPlayer!.onDurationChanged;
    } else {
      throw UnimplementedError();
    }
  }

  Stream<Duration> get positionStream {
    if (apSupportedPlatform) {
      return _audioPlayer!.onPositionChanged;
    } else {
      throw UnimplementedError();
    }
  }

  Stream<Duration> get bufferedPositionStream {
    if (apSupportedPlatform) {
      // audioplayers doesn't have the capability to get buffered position
      return const Stream.empty();
    } else {
      throw UnimplementedError();
    }
  }

  Stream<void> get completedStream {
    if (apSupportedPlatform) {
      return _audioPlayer!.onPlayerComplete;
    } else {
      throw UnimplementedError();
    }
  }

  Stream<bool> get playingStream {
    if (apSupportedPlatform) {
      return _audioPlayer!.onPlayerStateChanged.map((state) {
        return state == ap.PlayerState.playing;
      });
    } else {
      throw UnimplementedError();
    }
  }

  Stream<bool> get bufferingStream {
    if (apSupportedPlatform) {
      return const Stream.empty();
    } else {
      throw UnimplementedError();
    }
  }

  Stream<PlayerState> get playerStateStream =>
      _audioPlayer!.onPlayerStateChanged
          .map((state) => PlayerState.fromApPlayerState(state));

  // regular info getter

  Future<Duration?> get duration async {
    if (apSupportedPlatform) {
      return await _audioPlayer!.getDuration();
    } else {
      throw UnimplementedError();
    }
  }

  Future<Duration?> get position async {
    if (apSupportedPlatform) {
      return await _audioPlayer!.getCurrentPosition();
    } else {
      throw UnimplementedError();
    }
  }

  Future<Duration?> get bufferedPosition async {
    if (apSupportedPlatform) {
      // audioplayers doesn't have the capability to get buffered position
      return null;
    } else {
      throw UnimplementedError();
    }
  }

  bool get hasSource {
    if (apSupportedPlatform) {
      return _audioPlayer!.source != null;
    } else {
      throw UnimplementedError();
    }
  }

  // states
  bool get isPlaying {
    if (apSupportedPlatform) {
      return _audioPlayer!.state == ap.PlayerState.playing;
    } else {
      throw UnimplementedError();
    }
  }

  bool get isPaused {
    if (apSupportedPlatform) {
      return _audioPlayer!.state == ap.PlayerState.paused;
    } else {
      throw UnimplementedError();
    }
  }

  bool get isStopped {
    if (apSupportedPlatform) {
      return _audioPlayer!.state == ap.PlayerState.stopped;
    } else {
      throw UnimplementedError();
    }
  }

  bool get isCompleted {
    if (apSupportedPlatform) {
      return _audioPlayer!.state == ap.PlayerState.completed;
    } else {
      throw UnimplementedError();
    }
  }

  bool get isBuffering {
    if (apSupportedPlatform) {
      // audioplayers doesn't have the capability to get buffering state
      return false;
    } else {
      throw UnimplementedError();
    }
  }

  Object _resolveUrlType(String url) {
    if (apSupportedPlatform) {
      if (url.startsWith("https")) {
        return ap.UrlSource(url);
      } else {
        return ap.DeviceFileSource(url);
      }
    } else {
      throw UnimplementedError();
    }
  }

  Future<void> preload(String url) async {
    final urlType = _resolveUrlType(url);
    if (apSupportedPlatform && urlType is ap.Source) {
      // audioplayers doesn't have the capability to preload
      return;
    } else {
      throw UnimplementedError();
    }
  }

  Future<void> play(String url) async {
    final urlType = _resolveUrlType(url);
    if (apSupportedPlatform && urlType is ap.Source) {
      await _audioPlayer?.play(urlType);
    } else {
      throw UnimplementedError();
    }
  }

  Future<void> pause() async {
    await _audioPlayer?.pause();
    throw UnimplementedError();
  }

  Future<void> resume() async {
    await _audioPlayer?.resume();
  }

  Future<void> stop() async {
    await _audioPlayer?.stop();
  }

  Future<void> seek(Duration position) async {
    await _audioPlayer?.seek(position);
  }

  Future<void> setVolume(double volume) async {
    await _audioPlayer?.setVolume(volume);
  }

  Future<void> setSpeed(double speed) async {
    await _audioPlayer?.setPlaybackRate(speed);
  }

  Future<void> dispose() async {
    await _audioPlayer?.dispose();
  }
}
