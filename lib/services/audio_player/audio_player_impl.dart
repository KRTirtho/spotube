final audioPlayer = SpotubeAudioPlayer();

class SpotubeAudioPlayer extends AudioPlayerInterface with SpotubeAudioPlayersStreams {
  // Playback control methods
  Future<void> pause() async => await player.pause();

  Future<void> resume() async => await player.play();

  Future<void> stop() async => await player.stop();

  Future<void> seek(Duration position) async => await player.seek(position);

  /// Set volume between 0 and 1
  Future<void> setVolume(double volume) async {
    assert(volume >= 0 && volume <= 1);
    await player.setVolume(volume * 100);
  }

  Future<void> setSpeed(double speed) async => await player.setRate(speed);

  Future<void> setAudioDevice(mk.AudioDevice device) async => await player.setAudioDevice(device);

  Future<void> dispose() async => await player.dispose();

  // Playlist control methods
  Future<void> openPlaylist(
    List<mk.Media> tracks, {
    bool autoPlay = true,
    int initialIndex = 0,
  }) async {
    assert(tracks.isNotEmpty);
    assert(initialIndex <= tracks.length - 1);

    await player.open(
      mk.Playlist(tracks, index: initialIndex),
      play: autoPlay,
    );
  }

  // Helper methods for playlist sources
  List<String> get sources => player.state.playlist.medias.map((e) => e.uri).toList();

  String? get currentSource {
    final index = player.state.playlist.index;
    if (index == -1) return null;
    return player.state.playlist.medias.elementAtOrNull(index)?.uri;
  }

  String? get nextSource {
    final isLastTrack = player.state.playlist.index == player.state.playlist.medias.length - 1;
    if (loopMode == PlaylistMode.loop && isLastTrack) return sources.first;

    return player.state.playlist.medias.elementAtOrNull(player.state.playlist.index + 1)?.uri;
  }

  String? get previousSource {
    if (loopMode == PlaylistMode.loop && player.state.playlist.index == 0) return sources.last;

    return player.state.playlist.medias.elementAtOrNull(player.state.playlist.index - 1)?.uri;
  }

  int get currentIndex => player.state.playlist.index;

  // Playlist navigation methods
  Future<void> skipToNext() async => await player.next();

  Future<void> skipToPrevious() async => await player.previous();

  Future<void> jumpTo(int index) async => await player.jump(index);

  // Playlist management methods
  Future<void> addTrack(mk.Media media) async => await player.add(media);

  Future<void> addTrackAt(mk.Media media, int index) async => await player.insert(index, media);

  Future<void> removeTrack(int index) async => await player.remove(index);

  Future<void> moveTrack(int from, int to) async => await player.move(from, to);

  Future<void> clearPlaylist() async => await player.stop();

  // Shuffle and loop mode control
  Future<void> setShuffle(bool shuffle) async => await player.setShuffle(shuffle);

  Future<void> setLoopMode(PlaylistMode loop) async => await player.setPlaylistMode(loop);

  Future<void> setAudioNormalization(bool normalize) async => await player.setAudioNormalization(normalize);
}
