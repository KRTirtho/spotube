import 'dart:async';

import 'package:audioplayers/audioplayers.dart' as ap;
import 'package:just_audio/just_audio.dart' as ja;
import 'package:flutter_desktop_tools/flutter_desktop_tools.dart';

final audioPlayer = SpotubeAudioPlayer();

enum AudioPlaybackState {
  playing,
  paused,
  completed,
  buffering,
  stopped;

  static AudioPlaybackState fromApPlayerState(ap.PlayerState state) {
    switch (state) {
      case ap.PlayerState.playing:
        return AudioPlaybackState.playing;
      case ap.PlayerState.paused:
        return AudioPlaybackState.paused;
      case ap.PlayerState.stopped:
        return AudioPlaybackState.stopped;
      case ap.PlayerState.completed:
        return AudioPlaybackState.completed;
    }
  }

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

  // static PlayerState fromAapPlayerState(aap.PlayerState state) {
  //   switch (state) {
  //     case aap.PlayerState.play:
  //       return PlayerState.playing;
  //     case aap.PlayerState.pause:
  //       return PlayerState.paused;
  //     case aap.PlayerState.stop:
  //       return PlayerState.stopped;
  //   }
  // }

  ap.PlayerState get asAudioPlayerPlayerState {
    switch (this) {
      case AudioPlaybackState.playing:
        return ap.PlayerState.playing;
      case AudioPlaybackState.paused:
        return ap.PlayerState.paused;
      case AudioPlaybackState.stopped:
        return ap.PlayerState.stopped;
      case AudioPlaybackState.completed:
        return ap.PlayerState.completed;
      case AudioPlaybackState.buffering:
        return ap.PlayerState.paused;
    }
  }
}

class SpotubeAudioPlayer {
  final ap.AudioPlayer? _audioPlayer;
  final ja.AudioPlayer? _justAudio;

  SpotubeAudioPlayer()
      : _audioPlayer = apSupportedPlatform ? ap.AudioPlayer() : null,
        _justAudio = !apSupportedPlatform ? ja.AudioPlayer() : null;

  /// Whether the current platform supports the audioplayers plugin
  static final bool apSupportedPlatform =
      DesktopTools.platform.isWindows || DesktopTools.platform.isLinux;

  // stream getters
  Stream<Duration> get durationStream {
    if (apSupportedPlatform) {
      return _audioPlayer!.onDurationChanged.asBroadcastStream();
    } else {
      return _justAudio!.durationStream
          .where((event) => event != null)
          .map((event) => event!)
          .asBroadcastStream();
    }
  }

  Stream<Duration> get positionStream {
    if (apSupportedPlatform) {
      return _audioPlayer!.onPositionChanged.asBroadcastStream();
    } else {
      return _justAudio!.positionStream.asBroadcastStream();
    }
  }

  Stream<Duration> get bufferedPositionStream {
    if (apSupportedPlatform) {
      // audioplayers doesn't have the capability to get buffered position
      return const Stream<Duration>.empty().asBroadcastStream();
    } else {
      return _justAudio!.bufferedPositionStream.asBroadcastStream();
    }
  }

  Stream<void> get completedStream {
    if (apSupportedPlatform) {
      return _audioPlayer!.onPlayerComplete.asBroadcastStream();
    } else {
      return _justAudio!.playerStateStream
          .where(
              (event) => event.processingState == ja.ProcessingState.completed)
          .asBroadcastStream();
    }
  }

  Stream<bool> get playingStream {
    if (apSupportedPlatform) {
      return _audioPlayer!.onPlayerStateChanged.map((state) {
        return state == ap.PlayerState.playing;
      }).asBroadcastStream();
    } else {
      return _justAudio!.playingStream;
    }
  }

  Stream<bool> get bufferingStream {
    if (apSupportedPlatform) {
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
    if (apSupportedPlatform) {
      return _audioPlayer!.onPlayerStateChanged
          .map((state) => AudioPlaybackState.fromApPlayerState(state))
          .asBroadcastStream();
    } else {
      return _justAudio!.playerStateStream
          .map(AudioPlaybackState.fromJaPlayerState)
          .asBroadcastStream();
    }
  }

  // regular info getter

  Future<Duration?> get duration async {
    if (apSupportedPlatform) {
      return await _audioPlayer!.getDuration();
    } else {
      return _justAudio!.duration;
    }
  }

  Future<Duration?> get position async {
    if (apSupportedPlatform) {
      return await _audioPlayer!.getCurrentPosition();
    } else {
      return _justAudio!.position;
    }
  }

  Future<Duration?> get bufferedPosition async {
    if (apSupportedPlatform) {
      // audioplayers doesn't have the capability to get buffered position
      return null;
    } else {
      return null;
    }
  }

  bool get hasSource {
    if (apSupportedPlatform) {
      return _audioPlayer!.source != null;
    } else {
      return _justAudio!.audioSource != null;
    }
  }

  // states
  bool get isPlaying {
    if (apSupportedPlatform) {
      return _audioPlayer!.state == ap.PlayerState.playing;
    } else {
      return _justAudio!.playing;
    }
  }

  bool get isPaused {
    if (apSupportedPlatform) {
      return _audioPlayer!.state == ap.PlayerState.paused;
    } else {
      return !isPlaying;
    }
  }

  bool get isStopped {
    if (apSupportedPlatform) {
      return _audioPlayer!.state == ap.PlayerState.stopped;
    } else {
      return _justAudio!.processingState == ja.ProcessingState.idle;
    }
  }

  Future<bool> get isCompleted async {
    if (apSupportedPlatform) {
      return _audioPlayer!.state == ap.PlayerState.completed;
    } else {
      return _justAudio!.processingState == ja.ProcessingState.completed;
    }
  }

  bool get isBuffering {
    if (apSupportedPlatform) {
      // audioplayers doesn't have the capability to get buffering state
      return false;
    } else {
      return _justAudio!.processingState == ja.ProcessingState.buffering ||
          _justAudio!.processingState == ja.ProcessingState.loading;
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
      if (url.startsWith("https")) {
        return ja.AudioSource.uri(Uri.parse(url));
      } else {
        return ja.AudioSource.file(url);
      }
    }
  }

  Future<void> preload(String url) async {
    final urlType = _resolveUrlType(url);
    if (apSupportedPlatform && urlType is ap.Source) {
      // audioplayers doesn't have the capability to preload
      return;
    } else {
      return;
    }
  }

  Future<void> play(String url) async {
    final urlType = _resolveUrlType(url);
    if (apSupportedPlatform && urlType is ap.Source) {
      await _audioPlayer?.play(urlType);
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
    await _audioPlayer?.pause();
    await _justAudio?.pause();
  }

  Future<void> resume() async {
    await _audioPlayer?.resume();
    await _justAudio?.play();
  }

  Future<void> stop() async {
    await _audioPlayer?.stop();
    await _justAudio?.stop();
  }

  Future<void> seek(Duration position) async {
    await _audioPlayer?.seek(position);
    await _justAudio?.seek(position);
  }

  Future<void> setVolume(double volume) async {
    await _audioPlayer?.setVolume(volume);
    await _justAudio?.setVolume(volume);
  }

  Future<void> setSpeed(double speed) async {
    await _audioPlayer?.setPlaybackRate(speed);
    await _justAudio?.setSpeed(speed);
  }

  Future<void> dispose() async {
    await _audioPlayer?.dispose();
    await _justAudio?.dispose();
  }
}
