part of 'audio_player.dart';

final audioPlayer = SpotubeAudioPlayer();

class SpotubeAudioPlayer extends AudioPlayerInterface
    with SpotubeAudioPlayersStreams {
  Future<void> pause() async {
    await _mkPlayer.pause();
  }

  Future<void> resume() async {
    await _mkPlayer.play();
  }

  Future<void> stop() async {
    await _mkPlayer.stop();
  }

  Future<void> seek(Duration position) async {
    await _mkPlayer.seek(position);
  }

  /// Volume is between 0 and 1
  Future<void> setVolume(double volume) async {
    assert(volume >= 0 && volume <= 1);
    await _mkPlayer.setVolume(volume * 100);
  }

  Future<void> setSpeed(double speed) async {
    await _mkPlayer.setRate(speed);
  }

  Future<void> setAudioDevice(mk.AudioDevice device) async {
    await _mkPlayer.setAudioDevice(device);
  }

  Future<void> dispose() async {
    await _mkPlayer.dispose();
  }

  // Playlist related

  Future<void> openPlaylist(
    List<mk.Media> tracks, {
    bool autoPlay = true,
    int initialIndex = 0,
  }) async {
    assert(tracks.isNotEmpty);
    assert(initialIndex <= tracks.length - 1);
    await _mkPlayer.open(
      mk.Playlist(tracks, index: initialIndex),
      play: autoPlay,
    );
  }

  List<String> get sources {
    return _mkPlayer.state.playlist.medias.map((e) => e.uri).toList();
  }

  String? get currentSource {
    if (_mkPlayer.state.playlist.index == -1) return null;
    return _mkPlayer.state.playlist.medias
        .elementAtOrNull(_mkPlayer.state.playlist.index)
        ?.uri;
  }

  String? get nextSource {
    if (loopMode == PlaylistMode.loop &&
        _mkPlayer.state.playlist.index ==
            _mkPlayer.state.playlist.medias.length - 1) {
      return sources.first;
    }

    return _mkPlayer.state.playlist.medias
        .elementAtOrNull(_mkPlayer.state.playlist.index + 1)
        ?.uri;
  }

  String? get previousSource {
    if (loopMode == PlaylistMode.loop && _mkPlayer.state.playlist.index == 0) {
      return sources.last;
    }

    return _mkPlayer.state.playlist.medias
        .elementAtOrNull(_mkPlayer.state.playlist.index - 1)
        ?.uri;
  }

  int get currentIndex => _mkPlayer.state.playlist.index;

  Future<void> skipToNext() async {
    await _mkPlayer.next();
  }

  Future<void> skipToPrevious() async {
    await _mkPlayer.previous();
  }

  Future<void> jumpTo(int index) async {
    await _mkPlayer.jump(index);
  }

  Future<void> addTrack(mk.Media media) async {
    await _mkPlayer.add(media);
  }

  Future<void> addTrackAt(mk.Media media, int index) async {
    await _mkPlayer.insert(index, media);
  }

  Future<void> removeTrack(int index) async {
    await _mkPlayer.remove(index);
  }

  Future<void> moveTrack(int from, int to) async {
    await _mkPlayer.move(from, to);
  }

  Future<void> clearPlaylist() async {
    _mkPlayer.stop();
  }

  Future<void> setShuffle(bool shuffle) async {
    await _mkPlayer.setShuffle(shuffle);
  }

  Future<void> setLoopMode(PlaylistMode loop) async {
    await _mkPlayer.setPlaylistMode(loop);
  }

  Future<void> setAudioNormalization(bool normalize) async {
    await _mkPlayer.setAudioNormalization(normalize);
  }

  Future<void> setDemuxerBufferSize(int sizeInBytes) async {
    await _mkPlayer.setDemuxerBufferSize(sizeInBytes);
  }
}
