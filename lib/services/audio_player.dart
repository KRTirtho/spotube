import 'dart:async';

import 'package:audioplayers/audioplayers.dart' as ap;
import 'package:assets_audio_player/assets_audio_player.dart' as aap;
import 'package:flutter_desktop_tools/flutter_desktop_tools.dart';

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

  static PlayerState fromAapPlayerState(aap.PlayerState state) {
    switch (state) {
      case aap.PlayerState.play:
        return PlayerState.playing;
      case aap.PlayerState.pause:
        return PlayerState.paused;
      case aap.PlayerState.stop:
        return PlayerState.stopped;
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
  final aap.AssetsAudioPlayer? _assetsAudioPlayer;

  SpotubeAudioPlayer()
      : _audioPlayer = apSupportedPlatform ? ap.AudioPlayer() : null,
        _assetsAudioPlayer =
            !apSupportedPlatform ? aap.AssetsAudioPlayer.newPlayer() : null;

  /// Whether the current platform supports the audioplayers plugin
  static final bool apSupportedPlatform =
      DesktopTools.platform.isWindows || DesktopTools.platform.isLinux;

  // stream getters
  Stream<Duration> get durationStream {
    if (apSupportedPlatform) {
      return _audioPlayer!.onDurationChanged.asBroadcastStream();
    } else {
      return _assetsAudioPlayer!.onReadyToPlay
          .where((event) => event != null)
          .map((event) => event!.duration)
          .asBroadcastStream();
    }
  }

  Stream<Duration> get positionStream {
    if (apSupportedPlatform) {
      return _audioPlayer!.onPositionChanged.asBroadcastStream();
    } else {
      return _assetsAudioPlayer!.currentPosition.asBroadcastStream();
    }
  }

  Stream<Duration> get bufferedPositionStream {
    if (apSupportedPlatform) {
      // audioplayers doesn't have the capability to get buffered position
      return const Stream<Duration>.empty().asBroadcastStream();
    } else {
      return const Stream<Duration>.empty().asBroadcastStream();
    }
  }

  Stream<void> get completedStream {
    if (apSupportedPlatform) {
      return _audioPlayer!.onPlayerComplete.asBroadcastStream();
    } else {
      int lastValue = 0;
      return positionStream.where(
        (pos) {
          final posS = pos.inSeconds;
          final duration = _assetsAudioPlayer
                  ?.current.valueOrNull?.audio.duration.inSeconds ??
              0;
          final isComplete =
              posS > 0 && duration > 0 && posS == duration && posS != lastValue;

          if (isComplete) lastValue = posS;
          return isComplete;
        },
      ).asBroadcastStream();
    }
  }

  Stream<bool> get playingStream {
    if (apSupportedPlatform) {
      return _audioPlayer!.onPlayerStateChanged.map((state) {
        return state == ap.PlayerState.playing;
      }).asBroadcastStream();
    } else {
      return _assetsAudioPlayer!.isPlaying.asBroadcastStream();
    }
  }

  Stream<bool> get bufferingStream {
    if (apSupportedPlatform) {
      return Stream.value(false).asBroadcastStream();
    } else {
      return _assetsAudioPlayer!.isBuffering.asBroadcastStream();
    }
  }

  Stream<PlayerState> get playerStateStream {
    if (apSupportedPlatform) {
      return _audioPlayer!.onPlayerStateChanged
          .map((state) => PlayerState.fromApPlayerState(state))
          .asBroadcastStream();
    } else {
      return _assetsAudioPlayer!.playerState
          .map(PlayerState.fromAapPlayerState)
          .asBroadcastStream();
    }
  }

  // regular info getter

  Future<Duration?> get duration async {
    if (apSupportedPlatform) {
      return await _audioPlayer!.getDuration();
    } else {
      return _assetsAudioPlayer!.current.valueOrNull?.audio.duration;
    }
  }

  Future<Duration?> get position async {
    if (apSupportedPlatform) {
      return await _audioPlayer!.getCurrentPosition();
    } else {
      return _assetsAudioPlayer!.currentPosition.valueOrNull;
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
      return _assetsAudioPlayer!.current.valueOrNull != null;
    }
  }

  // states
  bool get isPlaying {
    if (apSupportedPlatform) {
      return _audioPlayer!.state == ap.PlayerState.playing;
    } else {
      return _assetsAudioPlayer!.isPlaying.valueOrNull ?? false;
    }
  }

  bool get isPaused {
    if (apSupportedPlatform) {
      return _audioPlayer!.state == ap.PlayerState.paused;
    } else {
      return !isPlaying && hasSource;
    }
  }

  bool get isStopped {
    if (apSupportedPlatform) {
      return _audioPlayer!.state == ap.PlayerState.stopped;
    } else {
      return !isPlaying && !hasSource;
    }
  }

  Future<bool> get isCompleted async {
    if (apSupportedPlatform) {
      return _audioPlayer!.state == ap.PlayerState.completed;
    } else {
      return !isPlaying && hasSource && await position == await duration;
    }
  }

  bool get isBuffering {
    if (apSupportedPlatform) {
      // audioplayers doesn't have the capability to get buffering state
      return false;
    } else {
      return _assetsAudioPlayer!.isBuffering.valueOrNull ?? false;
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
        return aap.Audio.network(url);
      } else {
        return aap.Audio.file(url);
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
      await _assetsAudioPlayer?.stop();
      await _assetsAudioPlayer?.open(
        urlType as aap.Playable,
        autoStart: true,
        audioFocusStrategy: const aap.AudioFocusStrategy.request(
          resumeAfterInterruption: true,
        ),
        loopMode: aap.LoopMode.none,
        playInBackground: aap.PlayInBackground.enabled,
        headPhoneStrategy: aap.HeadPhoneStrategy.pauseOnUnplugPlayOnPlug,
        showNotification: false,
        respectSilentMode: true,
      );
    }
  }

  Future<void> pause() async {
    await _audioPlayer?.pause();
    await _assetsAudioPlayer?.pause();
  }

  Future<void> resume() async {
    await _audioPlayer?.resume();
    await _assetsAudioPlayer?.play();
  }

  Future<void> stop() async {
    await _audioPlayer?.stop();
    await _assetsAudioPlayer?.stop();
  }

  Future<void> seek(Duration position) async {
    await _audioPlayer?.seek(position);
    await _assetsAudioPlayer?.seek(position);
  }

  Future<void> setVolume(double volume) async {
    await _audioPlayer?.setVolume(volume);
    await _assetsAudioPlayer?.setVolume(volume);
  }

  Future<void> setSpeed(double speed) async {
    await _audioPlayer?.setPlaybackRate(speed);
    await _assetsAudioPlayer?.setPlaySpeed(speed);
  }

  Future<void> dispose() async {
    await _audioPlayer?.dispose();
    await _assetsAudioPlayer?.dispose();
  }
}
