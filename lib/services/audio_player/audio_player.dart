import 'dart:async';

import 'package:collection/collection.dart';
import 'package:media_kit/media_kit.dart' as mk;
import 'package:just_audio/just_audio.dart' as ja;
import 'package:flutter_desktop_tools/flutter_desktop_tools.dart';
import 'package:spotube/models/spotube_track.dart';
import 'package:spotube/services/audio_player/loop_mode.dart';
import 'package:spotube/services/audio_player/mk_state_player.dart';
import 'package:spotube/services/audio_player/playback_state.dart';

final audioPlayer = SpotubeAudioPlayer();

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

  /// Stream that emits when the player is almost (%) complete
  Stream<int> percentCompletedStream(double percent) {
    return positionStream
        .asyncMap(
          (position) async => (await duration)?.inSeconds == 0
              ? 0
              : (position.inSeconds / (await duration)!.inSeconds * 100)
                  .toInt(),
        )
        .where((event) => event >= percent)
        .asBroadcastStream();
  }

  Stream<bool> get playingStream {
    if (mkSupportedPlatform) {
      return _mkPlayer!.streams.playing.asBroadcastStream();
    } else {
      return _justAudio!.playingStream.asBroadcastStream();
    }
  }

  Stream<bool> get shuffledStream {
    if (mkSupportedPlatform) {
      return _mkPlayer!.shuffleStream.asBroadcastStream();
    } else {
      return _justAudio!.shuffleModeEnabledStream.asBroadcastStream();
    }
  }

  Stream<PlaybackLoopMode> get loopModeStream {
    if (mkSupportedPlatform) {
      return _mkPlayer!.loopModeStream
          .map(PlaybackLoopMode.fromPlaylistMode)
          .asBroadcastStream();
    } else {
      return _justAudio!.loopModeStream
          .map(PlaybackLoopMode.fromLoopMode)
          .asBroadcastStream();
    }
  }

  Stream<double> get volumeStream {
    if (mkSupportedPlatform) {
      return _mkPlayer!.streams.volume
          .map((event) => event / 100)
          .asBroadcastStream();
    } else {
      return _justAudio!.volumeStream.asBroadcastStream();
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

  Stream<int> get currentIndexChangedStream {
    if (mkSupportedPlatform) {
      return _mkPlayer!.streams.playlist
          .map((event) => event.index)
          .asBroadcastStream();
    } else {
      return _justAudio!.sequenceStateStream
          .map((event) => event?.currentIndex ?? -1)
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

  Future<bool> get isShuffled async {
    if (mkSupportedPlatform) {
      return _mkPlayer!.shuffled;
    } else {
      return _justAudio!.shuffleModeEnabled;
    }
  }

  Future<PlaybackLoopMode> get loopMode async {
    if (mkSupportedPlatform) {
      return PlaybackLoopMode.fromPlaylistMode(_mkPlayer!.loopMode);
    } else {
      return PlaybackLoopMode.fromLoopMode(_justAudio!.loopMode);
    }
  }

  /// Returns the current volume of the player, between 0 and 1
  double get volume {
    if (mkSupportedPlatform) {
      return _mkPlayer!.state.volume / 100;
    } else {
      return _justAudio!.volume;
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
    await _mkPlayer?.stop();
    await _justAudio?.stop();
  }

  Future<void> seek(Duration position) async {
    await _mkPlayer?.seek(position);
    await _justAudio?.seek(position);
  }

  /// Volume is between 0 and 1
  Future<void> setVolume(double volume) async {
    assert(volume >= 0 && volume <= 1);
    await _mkPlayer?.setVolume(volume * 100);
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

  // Playlist related

  Future<void> openPlaylist(
    List<String> tracks, {
    bool autoPlay = true,
    int initialIndex = 0,
  }) async {
    assert(tracks.isNotEmpty);
    assert(initialIndex <= tracks.length - 1);
    if (mkSupportedPlatform) {
      await _mkPlayer!.open(
        mk.Playlist(
          tracks.map(mk.Media.new).toList(),
          index: initialIndex,
        ),
        play: autoPlay,
      );
    } else {
      await _justAudio!.setAudioSource(
        ja.ConcatenatingAudioSource(
          useLazyPreparation: true,
          children:
              tracks.map((e) => ja.AudioSource.uri(Uri.parse(e))).toList(),
        ),
        preload: true,
        initialIndex: initialIndex,
      );
      if (autoPlay) {
        await _justAudio!.play();
      }
    }
  }

  List<SpotubeTrack> resolveTracksForSource(List<SpotubeTrack> tracks) {
    return tracks.where((e) => sources.contains(e.ytUri)).toList();
  }

  bool tracksExistsInPlaylist(List<SpotubeTrack> tracks) {
    return resolveTracksForSource(tracks).length == tracks.length;
  }

  List<String> get sources {
    if (mkSupportedPlatform) {
      return _mkPlayer!.state.playlist.medias.map((e) => e.uri).toList();
    } else {
      return (_justAudio!.audioSource as ja.ConcatenatingAudioSource)
          .children
          .map((e) => (e as ja.UriAudioSource).uri.toString())
          .toList();
    }
  }

  int get currentIndex {
    if (mkSupportedPlatform) {
      return _mkPlayer!.state.playlist.index;
    } else {
      return _justAudio!.sequenceState?.currentIndex ?? -1;
    }
  }

  Future<void> skipToNext() async {
    if (mkSupportedPlatform) {
      await _mkPlayer!.next();
    } else {
      await _justAudio!.seekToNext();
    }
  }

  Future<void> skipToPrevious() async {
    if (mkSupportedPlatform) {
      await _mkPlayer!.previous();
    } else {
      await _justAudio!.seekToPrevious();
    }
  }

  Future<void> jumpTo(int index) async {
    if (mkSupportedPlatform) {
      await _mkPlayer!.jump(index);
    } else {
      await _justAudio!.seek(Duration.zero, index: index);
    }
  }

  Future<void> addTrack(String url) async {
    final urlType = _resolveUrlType(url);
    if (mkSupportedPlatform && urlType is mk.Media) {
      await _mkPlayer!.add(urlType);
    } else {
      await (_justAudio!.audioSource as ja.ConcatenatingAudioSource)
          .add(urlType as ja.AudioSource);
    }
  }

  Future<void> removeTrack(int index) async {
    if (mkSupportedPlatform) {
      await _mkPlayer!.remove(index);
    } else {
      await (_justAudio!.audioSource as ja.ConcatenatingAudioSource)
          .removeAt(index);
    }
  }

  Future<void> moveTrack(int from, int to) async {
    if (mkSupportedPlatform) {
      await _mkPlayer!.move(from, to);
    } else {
      await (_justAudio!.audioSource as ja.ConcatenatingAudioSource)
          .move(from, to);
    }
  }

  Future<void> replaceSource(
    String oldSource,
    String newSource, {
    bool exclusive = false,
  }) async {
    final oldSourceIndex = sources.indexOf(oldSource);
    if (oldSourceIndex == -1) return;

    if (mkSupportedPlatform) {
      final sourcesCp = sources.toList();
      sourcesCp[oldSourceIndex] = newSource;

      await _mkPlayer!.open(
        mk.Playlist(
          sourcesCp.map(mk.Media.new).toList(),
          index: currentIndex,
        ),
        play: false,
      );
      if (exclusive) await jumpTo(oldSourceIndex);
    } else {
      await addTrack(newSource);
      await removeTrack(oldSourceIndex);

      int newSourceIndex = sources.indexOf(newSource);
      while (newSourceIndex == -1) {
        await Future.delayed(const Duration(milliseconds: 100));
        newSourceIndex = sources.indexOf(newSource);
      }
      await moveTrack(newSourceIndex, oldSourceIndex);
      newSourceIndex = sources.indexOf(newSource);
      while (newSourceIndex != oldSourceIndex) {
        await Future.delayed(const Duration(milliseconds: 100));
        await moveTrack(newSourceIndex, oldSourceIndex);
        newSourceIndex = sources.indexOf(newSource);
      }
    }
  }

  Future<void> clearPlaylist() async {
    if (mkSupportedPlatform) {
      await Future.wait(
        _mkPlayer!.state.playlist.medias.mapIndexed(
          (i, e) async => await _mkPlayer!.remove(i),
        ),
      );
    } else {
      await (_justAudio!.audioSource as ja.ConcatenatingAudioSource).clear();
    }
  }

  Future<void> setShuffle(bool shuffle) async {
    if (mkSupportedPlatform) {
      await _mkPlayer!.setShuffle(shuffle);
    } else {
      await _justAudio!.setShuffleModeEnabled(shuffle);
    }
  }

  Future<void> setLoopMode(PlaybackLoopMode loop) async {
    if (mkSupportedPlatform) {
      await _mkPlayer!.setPlaylistMode(loop.toPlaylistMode());
    } else {
      await _justAudio!.setLoopMode(loop.toLoopMode());
    }
  }
}
