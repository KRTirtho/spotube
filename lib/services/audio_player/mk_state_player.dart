import 'dart:async';

import 'package:collection/collection.dart';
import 'package:media_kit/media_kit.dart';
// ignore: implementation_imports
import 'package:media_kit/src/models/playable.dart';
import 'package:spotube/services/audio_player/playback_state.dart';

/// MediaKit [Player] by default doesn't have a state stream.
/// This class adds a state stream to the [Player] class.
class MkPlayerWithState extends Player {
  final StreamController<AudioPlaybackState> _playerStateStream;
  final StreamController<Playlist> _playlistStream;
  final StreamController<bool> _shuffleStream;
  final StreamController<PlaylistMode> _loopModeStream;

  late final List<StreamSubscription> _subscriptions;

  bool _shuffled;
  PlaylistMode _loopMode;

  Playlist? _playlist;
  List<Media>? _tempMedias;

  MkPlayerWithState({super.configuration})
      : _playerStateStream = StreamController.broadcast(),
        _shuffleStream = StreamController.broadcast(),
        _loopModeStream = StreamController.broadcast(),
        _playlistStream = StreamController.broadcast(),
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
      streams.completed.listen((event) async {
        _playerStateStream.add(AudioPlaybackState.completed);
        if (!event || _playlist == null) return;

        if (loopMode == PlaylistMode.single) {
          await super.open(_playlist!.medias[_playlist!.index], play: true);
        } else {
          await next();
        }
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
  Playlist get playlist => _playlist ?? const Playlist([], index: -1);

  Stream<AudioPlaybackState> get playerStateStream => _playerStateStream.stream;
  Stream<bool> get shuffleStream => _shuffleStream.stream;
  Stream<PlaylistMode> get loopModeStream => _loopModeStream.stream;
  Stream<Playlist> get playlistStream => _playlistStream.stream;
  Stream<int> get indexChangeStream {
    int index = playlist.index;
    return playlistStream.map((event) => event.index).where((event) {
      if (event != index) {
        index = event;
        return true;
      }
      return false;
    });
  }

  set playlist(Playlist playlist) {
    _playlist = playlist;
    _playlistStream.add(playlist);
  }

  @override
  Future<void> setShuffle(bool shuffle) async {
    _shuffled = shuffle;
    await super.setShuffle(shuffle);
    _shuffleStream.add(shuffle);
    if (shuffle) {
      _tempMedias = _playlist!.medias;
      final active = _playlist!.medias[_playlist!.index];
      final newMedias = _playlist!.medias.toList()..shuffle();
      playlist = _playlist!.copyWith(
        medias: newMedias,
        index: newMedias.indexOf(active),
      );
    } else {
      if (_tempMedias == null) return;
      playlist = _playlist!.copyWith(
        medias: _tempMedias!,
        index: _tempMedias?.indexOf(
          _playlist!.medias[_playlist!.index],
        ),
      );
      _tempMedias = null;
    }
  }

  @override
  Future<void> setPlaylistMode(PlaylistMode playlistMode) async {
    _loopMode = playlistMode;
    await super.setPlaylistMode(playlistMode);
    _loopModeStream.add(playlistMode);
  }

  Future<void> stop() async {
    await pause();

    _loopMode = PlaylistMode.none;
    _shuffled = false;
    _playlist = null;
    _tempMedias = null;
    _playerStateStream.add(AudioPlaybackState.stopped);

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

  @override
  Future<void> open(
    Playable playable, {
    bool play = true,
  }) async {
    if (playable is Playlist) {
      playlist = playable;
      super.open(playable.medias[playable.index], play: play);
    }
    await super.open(playable, play: play);
  }

  @override
  FutureOr<void> next() {
    if (_playlist == null || _playlist!.index + 1 >= _playlist!.medias.length) {
      return null;
    }

    if (loopMode == PlaylistMode.loop &&
        _playlist!.index == _playlist!.medias.length - 1) {
      playlist = _playlist!.copyWith(index: 0);
    } else {
      playlist = _playlist!.copyWith(index: _playlist!.index + 1);
    }

    return super.open(_playlist!.medias[_playlist!.index], play: true);
  }

  @override
  FutureOr<void> previous() {
    if (_playlist == null || _playlist!.index - 1 < 0) return null;

    if (loopMode == PlaylistMode.loop && _playlist!.index == 0) {
      playlist = _playlist!.copyWith(index: _playlist!.medias.length - 1);
    } else {
      playlist = _playlist!.copyWith(index: _playlist!.index - 1);
    }

    return super.open(_playlist!.medias[_playlist!.index], play: true);
  }

  @override
  FutureOr<void> jump(int index) {
    if (_playlist == null || index < 0 || index >= _playlist!.medias.length) {
      return null;
    }

    playlist = _playlist!.copyWith(index: index);
    return super.open(_playlist!.medias[_playlist!.index], play: true);
  }

  @override
  FutureOr<void> move(int from, int to) {
    if (_playlist == null ||
        from >= _playlist!.medias.length ||
        to >= _playlist!.medias.length) return null;

    final active = _playlist!.medias[_playlist!.index];
    final newPlaylist = _playlist!.copyWith(
      medias: _playlist!.medias.mapIndexed((index, element) {
        if (index == from) {
          return _playlist!.medias[to];
        } else if (index == to) {
          return _playlist!.medias[from];
        }
        return element;
      }).toList(),
    );
    playlist = _playlist!.copyWith(
      index: newPlaylist.medias.indexOf(active),
      medias: newPlaylist.medias,
    );
  }

  @override
  FutureOr<void> add(Media media) {
    if (_playlist == null) return null;

    playlist = _playlist!.copyWith(
      medias: [..._playlist!.medias, media],
    );

    if (shuffled && _tempMedias != null) {
      _tempMedias!.add(media);
    }
  }

  @override
  FutureOr<void> remove(int index) async {
    if (_playlist == null || index >= _playlist!.medias.length) return null;

    final item = _playlist!.medias.elementAtOrNull(index);
    if (shuffled && _tempMedias != null && item != null) {
      _tempMedias!.remove(item);
    }

    if (_playlist!.index == index) {
      final hasNext = _playlist!.index + 1 < _playlist!.medias.length;
      final hasPrevious = _playlist!.index - 1 >= 0;

      if (hasNext) {
        playlist = _playlist!.copyWith(
          index: _playlist!.index + 1,
          medias: _playlist!.medias..removeAt(index),
        );
        super.open(_playlist!.medias[_playlist!.index], play: true);
      } else if (hasPrevious) {
        playlist = _playlist!.copyWith(
          index: _playlist!.index - 1,
          medias: _playlist!.medias..removeAt(index),
        );
        super.open(_playlist!.medias[_playlist!.index], play: true);
      } else {
        playlist = _playlist!.copyWith(
          medias: _playlist!.medias..removeAt(index),
          index: -1,
        );
        await stop();
      }
    } else {
      final active = _playlist!.medias[_playlist!.index];
      final newMedias = _playlist!.medias..removeAt(index);
      playlist = _playlist!.copyWith(
        medias: newMedias,
        index: newMedias.indexOf(active),
      );
    }
  }
}
