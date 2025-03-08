import 'dart:async';
import 'package:spotube/services/logger/logger.dart';
import 'package:media_kit/media_kit.dart';
import 'package:flutter_broadcasts/flutter_broadcasts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:audio_session/audio_session.dart';
import 'package:spotube/services/audio_player/playback_state.dart';
import 'package:spotube/utils/platform.dart';

class CustomPlayer extends Player {
  final StreamController<AudioPlaybackState> _playerStateStream = StreamController.broadcast();
  final StreamController<bool> _shuffleStream = StreamController.broadcast();

  late final List<StreamSubscription> _subscriptions;
  bool _shuffled = false;
  int _androidAudioSessionId = 0;
  String _packageName = "";
  AndroidAudioManager? _androidAudioManager;

  CustomPlayer({super.configuration}) {
    nativePlayer.setProperty("network-timeout", "120");
    _initPlatformSpecificSetup();
    _listenToPlayerEvents();
  }

  Future<void> _initPlatformSpecificSetup() async {
    final packageInfo = await PackageInfo.fromPlatform();
    _packageName = packageInfo.packageName;

    if (kIsAndroid) {
      _androidAudioManager = AndroidAudioManager();
      _androidAudioSessionId = await _androidAudioManager!.generateAudioSessionId();
      notifyAudioSessionUpdate(true);
      await _setAndroidAudioSession();
    }
  }

  Future<void> _setAndroidAudioSession() async {
    await nativePlayer.setProperty("audiotrack-session-id", _androidAudioSessionId.toString());
    await nativePlayer.setProperty("ao", "audiotrack,opensles,");
  }

  void _listenToPlayerEvents() {
    _subscriptions = [
      stream.buffering.listen((_) => _playerStateStream.add(AudioPlaybackState.buffering)),
      stream.playing.listen((playing) {
        _playerStateStream.add(playing ? AudioPlaybackState.playing : AudioPlaybackState.paused);
      }),
      stream.completed.listen((isCompleted) {
        if (isCompleted) {
          _playerStateStream.add(AudioPlaybackState.completed);
        }
      }),
      stream.playlist.listen((event) {
        if (event.medias.isEmpty) {
          _playerStateStream.add(AudioPlaybackState.stopped);
        }
      }),
      stream.error.listen((event) {
        AppLogger.reportError('[MediaKitError] \n$event', StackTrace.current);
      }),
    ];
  }

  Future<void> notifyAudioSessionUpdate(bool active) async {
    if (kIsAndroid) {
      sendBroadcast(
        BroadcastMessage(
          name: active
              ? "android.media.action.OPEN_AUDIO_EFFECT_CONTROL_SESSION"
              : "android.media.action.CLOSE_AUDIO_EFFECT_CONTROL_SESSION",
          data: {
            "android.media.extra.AUDIO_SESSION": _androidAudioSessionId,
            "android.media.extra.PACKAGE_NAME": _packageName,
          },
        ),
      );
    }
  }

  bool get shuffled => _shuffled;

  Stream<AudioPlaybackState> get playerStateStream => _playerStateStream.stream;
  Stream<bool> get shuffleStream => _shuffleStream.stream;

  Stream<int> get indexChangeStream {
    int oldIndex = state.playlist.index;
    return stream.playlist.map((event) => event.index).where((newIndex) {
      if (newIndex != oldIndex) {
        oldIndex = newIndex;
        return true;
      }
      return false;
    });
  }

  @override
  Future<void> setShuffle(bool shuffle) async {
    _shuffled = shuffle;
    await super.setShuffle(shuffle);
    _shuffleStream.add(shuffle);

    // Ensure delay before rearranging playlist
    await Future.delayed(const Duration(milliseconds: 100));
    if (shuffle) {
      await move(state.playlist.index, 0);
    }
  }

  @override
  Future<void> stop() async {
    await super.stop();
    _shuffled = false;
    _playerStateStream.add(AudioPlaybackState.stopped);
    _shuffleStream.add(false);
  }

  @override
  Future<void> dispose() async {
    await Future.wait(_subscriptions.map((sub) => sub.cancel()));
    await notifyAudioSessionUpdate(false);
    await _playerStateStream.close();
    await _shuffleStream.close();
    return super.dispose();
  }

  NativePlayer get nativePlayer => platform as NativePlayer;

  Future<void> insert(int index, Media media) async {
    await add(media);
    await move(state.playlist.medias.length, index);
  }

  Future<void> setAudioNormalization(bool normalize) async {
    await nativePlayer.setProperty(
      'af', 
      normalize ? 'dynaudnorm=g=5:f=250:r=0.9:p=0.5' : ''
    );
  }
}
