import 'dart:async';

import 'package:media_kit/media_kit.dart';
import 'package:spotube/services/audio_player/playback_state.dart';

/// MediaKit [Player] by default doesn't have a state stream.
/// This class adds a state stream to the [Player] class.
class MkPlayerWithState extends Player {
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
