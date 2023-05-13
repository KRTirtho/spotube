import 'dart:async';

import 'package:media_kit/media_kit.dart';
import 'package:spotube/services/audio_player/playback_state.dart';

/// MediaKit [Player] by default doesn't have a state stream.
/// This class adds a state stream to the [Player] class.
class MkPlayerWithState extends Player {
  final StreamController<AudioPlaybackState> _playerStateStream;
  final StreamController<bool> _shuffleStream;
  final StreamController<PlaylistMode> _loopModeStream;

  late final List<StreamSubscription> _subscriptions;

  bool _shuffled;
  PlaylistMode _loopMode;

  MkPlayerWithState({super.configuration})
      : _playerStateStream = StreamController.broadcast(),
        _shuffleStream = StreamController.broadcast(),
        _loopModeStream = StreamController.broadcast(),
        _shuffled = false,
        _loopMode = PlaylistMode.none {
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

  bool get shuffled => _shuffled;
  PlaylistMode get loopMode => _loopMode;

  Stream<AudioPlaybackState> get playerStateStream => _playerStateStream.stream;
  Stream<bool> get shuffleStream => _shuffleStream.stream;
  Stream<PlaylistMode> get loopModeStream => _loopModeStream.stream;

  @override
  Future<void> setShuffle(bool shuffle) async {
    _shuffled = shuffle;
    await super.setShuffle(shuffle);
    _shuffleStream.add(shuffle);
  }

  @override
  Future<void> setPlaylistMode(PlaylistMode playlistMode) async {
    _loopMode = playlistMode;
    await super.setPlaylistMode(playlistMode);
    _loopModeStream.add(playlistMode);
  }

  Future<void> stop() async {
    pause();
    _loopMode = PlaylistMode.none;
    _shuffled = false;
    for (int i = 0; i < state.playlist.medias.length; i++) {
      await remove(i);
    }
  }

  @override
  FutureOr<void> dispose({int code = 0}) {
    for (var element in _subscriptions) {
      element.cancel();
    }
    return super.dispose(code: code);
  }
}
