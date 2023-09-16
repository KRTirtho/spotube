part of 'audio_player.dart';

final audioPlayer = SpotubeAudioPlayer();

class SpotubeAudioPlayer extends AudioPlayerInterface
    with SpotubeAudioPlayersStreams {
  Object _resolveUrlType(String url) {
    // if (mkSupportedPlatform) {
    return mk.Media(url);
    // } else {
    //   if (url.startsWith("https")) {
    //     return ja.AudioSource.uri(Uri.parse(url));
    //   } else {
    //     return ja.AudioSource.file(url);
    //   }
    // }
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
    // if (mkSupportedPlatform && urlType is mk.Media) {
    await _mkPlayer.open(urlType as mk.Media, play: true);
    // } else {
    //   if (_justAudio?.audioSource is ja.ProgressiveAudioSource &&
    //       (_justAudio?.audioSource as ja.ProgressiveAudioSource)
    //               .uri
    //               .toString() ==
    //           url) {
    //     await _justAudio?.play();
    //   } else {
    //     await _justAudio?.stop();
    //     await _justAudio?.setAudioSource(
    //       urlType as ja.AudioSource,
    //       preload: true,
    //     );
    //     await _justAudio?.play();
    //   }
    // }
  }

  Future<void> pause() async {
    await _mkPlayer.pause();
    // await _justAudio?.pause();
  }

  Future<void> resume() async {
    await _mkPlayer.play();
    // await _justAudio?.play();
  }

  Future<void> stop() async {
    await _mkPlayer.stop();
    // await _justAudio?.stop();
    // await _justAudio?.setShuffleModeEnabled(false);
    // await _justAudio?.setLoopMode(ja.LoopMode.off);
  }

  Future<void> seek(Duration position) async {
    await _mkPlayer.seek(position);
    // await _justAudio?.seek(position);
  }

  /// Volume is between 0 and 1
  Future<void> setVolume(double volume) async {
    assert(volume >= 0 && volume <= 1);
    await _mkPlayer.setVolume(volume * 100);
    // await _justAudio?.setVolume(volume);
  }

  Future<void> setSpeed(double speed) async {
    await _mkPlayer.setRate(speed);
    // await _justAudio?.setSpeed(speed);
  }

  Future<void> dispose() async {
    await _mkPlayer.dispose();
    // await _justAudio?.dispose();
  }

  // Playlist related

  Future<void> openPlaylist(
    List<String> tracks, {
    bool autoPlay = true,
    int initialIndex = 0,
  }) async {
    assert(tracks.isNotEmpty);
    assert(initialIndex <= tracks.length - 1);
    // if (mkSupportedPlatform) {
    await _mkPlayer.open(
      mk.Playlist(
        tracks.map(mk.Media.new).toList(),
        index: initialIndex,
      ),
      play: autoPlay,
    );
    // } else {
    // await _justAudio!.setAudioSource(
    //   ja.ConcatenatingAudioSource(
    //     useLazyPreparation: true,
    //     children:
    //         tracks.map((e) => ja.AudioSource.uri(Uri.parse(e))).toList(),
    //   ),
    //   preload: true,
    //   initialIndex: initialIndex,
    // );
    // if (autoPlay) {
    //   await _justAudio!.play();
    // }
    // }
  }

  List<SpotubeTrack> resolveTracksForSource(List<SpotubeTrack> tracks) {
    return tracks.where((e) => sources.contains(e.ytUri)).toList();
  }

  bool tracksExistsInPlaylist(List<SpotubeTrack> tracks) {
    return resolveTracksForSource(tracks).length == tracks.length;
  }

  List<String> get sources {
    // if (mkSupportedPlatform) {
    return _mkPlayer.playlist.medias.map((e) => e.uri).toList();
    // } else {
    //   return _justAudio!.sequenceState?.effectiveSequence
    //           .map((e) => (e as ja.UriAudioSource).uri.toString())
    //           .toList() ??
    //       <String>[];
    // }
  }

  String? get currentSource {
    // if (mkSupportedPlatform) {
    return _mkPlayer.playlist.medias
        .elementAtOrNull(_mkPlayer.playlist.index)
        ?.uri;
    // } else {
    //   return (_justAudio?.sequenceState?.effectiveSequence
    //               .elementAtOrNull(_justAudio!.sequenceState!.currentIndex)
    //           as ja.UriAudioSource?)
    //       ?.uri
    //       .toString();
    // }
  }

  String? get nextSource {
    // if (mkSupportedPlatform) {

    if (loopMode == PlaybackLoopMode.all &&
        _mkPlayer.playlist.index == _mkPlayer.playlist.medias.length - 1) {
      return sources.first;
    }

    return _mkPlayer.playlist.medias
        .elementAtOrNull(_mkPlayer.playlist.index + 1)
        ?.uri;
    // } else {
    //   return (_justAudio?.sequenceState?.effectiveSequence
    //               .elementAtOrNull(_justAudio!.sequenceState!.currentIndex + 1)
    //           as ja.UriAudioSource?)
    //       ?.uri
    //       .toString();
    // }
  }

  String? get previousSource {
    if (loopMode == PlaybackLoopMode.all && _mkPlayer.playlist.index == 0) {
      return sources.last;
    }

    // if (mkSupportedPlatform) {
    return _mkPlayer.playlist.medias
        .elementAtOrNull(_mkPlayer.playlist.index - 1)
        ?.uri;
    // } else {
    //   return (_justAudio?.sequenceState?.effectiveSequence
    //               .elementAtOrNull(_justAudio!.sequenceState!.currentIndex - 1)
    //           as ja.UriAudioSource?)
    //       ?.uri
    //       .toString();
    // }
  }

  Future<void> skipToNext() async {
    // if (mkSupportedPlatform) {
    await _mkPlayer.next();
    // } else {
    //   await _justAudio!.seekToNext();
    // }
  }

  Future<void> skipToPrevious() async {
    // if (mkSupportedPlatform) {
    await _mkPlayer.previous();
    // } else {
    //   await _justAudio!.seekToPrevious();
    // }
  }

  Future<void> jumpTo(int index) async {
    // if (mkSupportedPlatform) {
    await _mkPlayer.jump(index);
    // } else {
    //   await _justAudio!.seek(Duration.zero, index: index);
    // }
  }

  Future<void> addTrack(String url) async {
    final urlType = _resolveUrlType(url);
    // if (mkSupportedPlatform && urlType is mk.Media) {
    await _mkPlayer.add(urlType as mk.Media);
    // } else {
    //   await (_justAudio!.audioSource as ja.ConcatenatingAudioSource)
    //       .add(urlType as ja.AudioSource);
    // }
  }

  Future<void> addTrackAt(String url, int index) async {
    final urlType = _resolveUrlType(url);
    // if (mkSupportedPlatform && urlType is mk.Media) {
    await _mkPlayer.insert(index, urlType as mk.Media);
    // } else {
    //   await (_justAudio!.audioSource as ja.ConcatenatingAudioSource)
    //       .insert(index, urlType as ja.AudioSource);
    // }
  }

  Future<void> removeTrack(int index) async {
    // if (mkSupportedPlatform) {
    await _mkPlayer.remove(index);
    // } else {
    //   await (_justAudio!.audioSource as ja.ConcatenatingAudioSource)
    //       .removeAt(index);
    // }
  }

  Future<void> moveTrack(int from, int to) async {
    // if (mkSupportedPlatform) {
    await _mkPlayer.move(from, to);
    // } else {
    //   await (_justAudio!.audioSource as ja.ConcatenatingAudioSource)
    //       .move(from, to);
    // }
  }

  Future<void> replaceSource(
    String oldSource,
    String newSource, {
    bool exclusive = false,
  }) async {
    final oldSourceIndex = sources.indexOf(oldSource);
    if (oldSourceIndex == -1) return;

    // if (mkSupportedPlatform) {
    _mkPlayer.replace(oldSource, newSource);
    // } else {
    //   final playlist = _justAudio!.audioSource as ja.ConcatenatingAudioSource;

    //   print('oldSource: $oldSource');
    //   print('newSource: $newSource');
    //   final oldSourceIndexInPlaylist =
    //       _justAudio?.sequenceState?.effectiveSequence.indexWhere(
    //     (e) => (e as ja.UriAudioSource).uri.toString() == oldSource,
    //   );

    //   print('oldSourceIndexInPlaylist: $oldSourceIndexInPlaylist');

    //   // ignores non existing source
    //   if (oldSourceIndexInPlaylist == null || oldSourceIndexInPlaylist == -1) {
    //     return;
    //   }

    //   await playlist.removeAt(oldSourceIndexInPlaylist);
    //   await playlist.insert(
    //     oldSourceIndexInPlaylist,
    //     ja.AudioSource.uri(Uri.parse(newSource)),
    //   );
    // }
  }

  Future<void> clearPlaylist() async {
    // if (mkSupportedPlatform) {
    _mkPlayer.stop();
    // } else {
    //   await (_justAudio!.audioSource as ja.ConcatenatingAudioSource).clear();
    // }
  }

  Future<void> setShuffle(bool shuffle) async {
    // if (mkSupportedPlatform) {
    await _mkPlayer.setShuffle(shuffle);
    // } else {
    //   await _justAudio!.setShuffleModeEnabled(shuffle);
    // }
  }

  Future<void> setLoopMode(PlaybackLoopMode loop) async {
    // if (mkSupportedPlatform) {
    await _mkPlayer.setPlaylistMode(loop.toPlaylistMode());
    // } else {
    //   await _justAudio!.setLoopMode(loop.toLoopMode());
    // }
  }

  Future<void> setAudioNormalization(bool normalize) async {
    await _mkPlayer.setAudioNormalization(normalize);
  }
}
