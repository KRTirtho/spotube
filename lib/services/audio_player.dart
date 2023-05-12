import 'dart:async';

import 'package:media_kit/media_kit.dart' as mk;
import 'package:just_audio/just_audio.dart' as ja;
import 'package:flutter_desktop_tools/flutter_desktop_tools.dart';

final audioPlayer = SpotubeAudioPlayer();

enum AudioPlaybackState {
  playing,
  paused,
  completed,
  buffering,
  stopped;

  static AudioPlaybackState fromJaPlayerState(ja.PlayerState state) {
    if (state.playing) {
      return AudioPlaybackState.playing;
    }

    switch (state.processingState) {
      case ja.ProcessingState.idle:
        return AudioPlaybackState.stopped;
      case ja.ProcessingState.ready:
        return AudioPlaybackState.paused;
      case ja.ProcessingState.completed:
        return AudioPlaybackState.completed;
      case ja.ProcessingState.loading:
      case ja.ProcessingState.buffering:
        return AudioPlaybackState.buffering;
    }
  }
}

class SpotubeAudioPlayer {
  final MkPlayerWithState? _mkPlayer;
  final ja.AudioPlayer? _justAudio;

  SpotubeAudioPlayer()
      : _mkPlayer = mkSupportedPlatform ? MkPlayerWithState() : null,
        _justAudio = !mkSupportedPlatform ? ja.AudioPlayer() : null;

  /// Whether the current platform supports the audioplayers plugin
  static final bool mkSupportedPlatform =
      DesktopTools.platform.isWindows || DesktopTools.platform.isLinux;

  // stream getters
  Stream<Duration> get durationStream {
    if (mkSupportedPlatform) {
      return _mkPlayer!.streams.duration.asBroadcastStream();
    } else {
      return _justAudio!.durationStream
          .where((event) => event != null)
          .map((event) => event!)
          .asBroadcastStream();
    }
  }

  Stream<Duration> get positionStream {
    if (mkSupportedPlatform) {
      return _mkPlayer!.streams.position.asBroadcastStream();
    } else {
      return _justAudio!.positionStream.asBroadcastStream();
    }
  }

  Stream<Duration> get bufferedPositionStream {
    if (mkSupportedPlatform) {
      // audioplayers doesn't have the capability to get buffered position
      return _mkPlayer!.streams.buffer.asBroadcastStream();
    } else {
      return _justAudio!.bufferedPositionStream.asBroadcastStream();
    }
  }

  Stream<void> get completedStream {
    if (mkSupportedPlatform) {
      return _mkPlayer!.streams.completed.asBroadcastStream();
    } else {
      return _justAudio!.playerStateStream
          .where(
              (event) => event.processingState == ja.ProcessingState.completed)
          .asBroadcastStream();
    }
  }

  Stream<bool> get playingStream {
    if (mkSupportedPlatform) {
      return _mkPlayer!.streams.playing.asBroadcastStream();
    } else {
      return _justAudio!.playingStream.asBroadcastStream();
    }
  }

  Stream<bool> get bufferingStream {
    if (mkSupportedPlatform) {
      return Stream.value(false).asBroadcastStream();
    } else {
      return _justAudio!.playerStateStream
          .map(
            (event) =>
                event.processingState == ja.ProcessingState.buffering ||
                event.processingState == ja.ProcessingState.loading,
          )
          .asBroadcastStream();
    }
  }

  Stream<AudioPlaybackState> get playerStateStream {
    if (mkSupportedPlatform) {
      return _mkPlayer!.playerStateStream.asBroadcastStream();
    } else {
      return _justAudio!.playerStateStream
          .map(AudioPlaybackState.fromJaPlayerState)
          .asBroadcastStream();
    }
  }

  // regular info getter

  Future<Duration?> get duration async {
    if (mkSupportedPlatform) {
      return _mkPlayer!.state.duration;
    } else {
      return _justAudio!.duration;
    }
  }

  Future<Duration?> get position async {
    if (mkSupportedPlatform) {
      return _mkPlayer!.state.position;
    } else {
      return _justAudio!.position;
    }
  }

  Future<Duration?> get bufferedPosition async {
    if (mkSupportedPlatform) {
      // audioplayers doesn't have the capability to get buffered position
      return null;
    } else {
      return null;
    }
  }

  bool get hasSource {
    if (mkSupportedPlatform) {
      return _mkPlayer!.state.playlist.medias.isNotEmpty;
    } else {
      return _justAudio!.audioSource != null;
    }
  }

  // states
  bool get isPlaying {
    if (mkSupportedPlatform) {
      return _mkPlayer!.state.playing;
    } else {
      return _justAudio!.playing;
    }
  }

  bool get isPaused {
    if (mkSupportedPlatform) {
      return !_mkPlayer!.state.playing;
    } else {
      return !isPlaying;
    }
  }

  bool get isStopped {
    if (mkSupportedPlatform) {
      return !hasSource;
    } else {
      return _justAudio!.processingState == ja.ProcessingState.idle;
    }
  }

  Future<bool> get isCompleted async {
    if (mkSupportedPlatform) {
      return _mkPlayer!.state.completed;
    } else {
      return _justAudio!.processingState == ja.ProcessingState.completed;
    }
  }

  bool get isBuffering {
    if (mkSupportedPlatform) {
      // audioplayers doesn't have the capability to get buffering state
      return false;
    } else {
      return _justAudio!.processingState == ja.ProcessingState.buffering ||
          _justAudio!.processingState == ja.ProcessingState.loading;
    }
  }

  Object _resolveUrlType(String url) {
    if (mkSupportedPlatform) {
      return mk.Media(url);
    } else {
      if (url.startsWith("https")) {
        return ja.AudioSource.uri(Uri.parse(url));
      } else {
        return ja.AudioSource.file(url);
      }
    }
  }

  Future<void> preload(String url) async {
    throw UnimplementedError();
    // final urlType = _resolveUrlType(url);
    // if (mkSupportedPlatform && urlType is ap.Source) {
    //   // audioplayers doesn't have the capability to preload
    //   return;
    // } else {
    //   return;
    // }
  }

  Future<void> play(String url) async {
    final urlType = _resolveUrlType(url);
    if (mkSupportedPlatform && urlType is mk.Media) {
      await _mkPlayer?.open(urlType, play: true);
    } else {
      if (_justAudio?.audioSource is ja.ProgressiveAudioSource &&
          (_justAudio?.audioSource as ja.ProgressiveAudioSource)
                  .uri
                  .toString() ==
              url) {
        await _justAudio?.play();
      } else {
        await _justAudio?.stop();
        await _justAudio?.setAudioSource(
          urlType as ja.AudioSource,
          preload: true,
        );
        await _justAudio?.play();
      }
    }
  }

  Future<void> pause() async {
    await _mkPlayer?.pause();
    await _justAudio?.pause();
  }

  Future<void> resume() async {
    await _mkPlayer?.play();
    await _justAudio?.play();
  }

  Future<void> stop() async {
    await _mkPlayer?.pause();
    await _justAudio?.stop();
  }

  Future<void> seek(Duration position) async {
    await _mkPlayer?.seek(position);
    await _justAudio?.seek(position);
  }

  Future<void> setVolume(double volume) async {
    await _mkPlayer?.setVolume(volume);
    await _justAudio?.setVolume(volume);
  }

  Future<void> setSpeed(double speed) async {
    await _mkPlayer?.setRate(speed);
    await _justAudio?.setSpeed(speed);
  }

  Future<void> dispose() async {
    await _mkPlayer?.dispose();
    await _justAudio?.dispose();
  }
}

/// MediaKit [mk.Player] by default doesn't have a state stream.
class MkPlayerWithState extends mk.Player {
  final StreamController<AudioPlaybackState> _playerStateStream;

  late final List<StreamSubscription> _subscriptions;

  MkPlayerWithState({super.configuration})
      : _playerStateStream = StreamController.broadcast() {
    _subscriptions = [
      streams.buffering.listen((event) {
        _playerStateStream.add(AudioPlaybackState.buffering);
      }),
      streams.playing.listen((playing) {
        if (playing) {
          _playerStateStream.add(AudioPlaybackState.playing);
        } else {
          _playerStateStream.add(AudioPlaybackState.paused);
        }
      }),
      streams.completed.listen((event) {
        _playerStateStream.add(AudioPlaybackState.completed);
      }),
      streams.playlist.listen((event) {
        if (event.medias.isEmpty) {
          _playerStateStream.add(AudioPlaybackState.stopped);
        }
      }),
    ];
  }

  Stream<AudioPlaybackState> get playerStateStream => _playerStateStream.stream;

  @override
  FutureOr<void> dispose({int code = 0}) {
    for (var element in _subscriptions) {
      element.cancel();
    }
    return super.dispose(code: code);
  }
}
