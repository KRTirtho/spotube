class MusicMetadata {
  final String? title;
  final String? artist;
  final String? album;
  final String? albumArtist;
  final String? thumbnail;

  const MusicMetadata({
    this.title,
    this.artist,
    this.album,
    this.albumArtist,
    this.thumbnail,
  });
}

enum PlaybackStatus {
  Closed,
  Changing,
  Stopped,
  Playing,
  Paused,
}

enum PressedButton {
  play,
  pause,
  next,
  previous,
  fastForward,
  rewind,
  stop,
  record,
  channelUp,
  channelDown;

  static PressedButton fromString(String button) {
    switch (button) {
      case 'play':
        return PressedButton.play;
      case 'pause':
        return PressedButton.pause;
      case 'next':
        return PressedButton.next;
      case 'previous':
        return PressedButton.previous;
      case 'fast_forward':
        return PressedButton.fastForward;
      case 'rewind':
        return PressedButton.rewind;
      case 'stop':
        return PressedButton.stop;
      case 'record':
        return PressedButton.record;
      case 'channel_up':
        return PressedButton.channelUp;
      case 'channel_down':
        return PressedButton.channelDown;
      default:
        throw Exception('Unknown button: $button');
    }
  }
}

class SMTCConfig {
  final bool playEnabled;
  final bool pauseEnabled;
  final bool stopEnabled;
  final bool nextEnabled;
  final bool prevEnabled;
  final bool fastForwardEnabled;
  final bool rewindEnabled;

  const SMTCConfig({
    required this.playEnabled,
    required this.pauseEnabled,
    required this.stopEnabled,
    required this.nextEnabled,
    required this.prevEnabled,
    required this.fastForwardEnabled,
    required this.rewindEnabled,
  });
}

enum RepeatMode {
  none,
  track,
  list;

  static RepeatMode fromString(String value) {
    switch (value) {
      case 'none':
        return none;
      case 'track':
        return track;
      case 'list':
        return list;
      default:
        throw Exception('Unknown repeat mode: $value');
    }
  }

  String get asString => toString().split('.').last;
}

class PlaybackTimeline {
  final int startTimeMs;
  final int endTimeMs;
  final int positionMs;
  final int? minSeekTimeMs;
  final int? maxSeekTimeMs;

  const PlaybackTimeline({
    required this.startTimeMs,
    required this.endTimeMs,
    required this.positionMs,
    this.minSeekTimeMs,
    this.maxSeekTimeMs,
  });
}

class SMTCWindows {
  SMTCWindows({
    SMTCConfig? config,
    PlaybackTimeline? timeline,
    MusicMetadata? metadata,
    PlaybackStatus? status,
    bool? shuffleEnabled,
    RepeatMode? repeatMode,
    bool? enabled,
  });

  SMTCConfig get config => throw UnimplementedError();
  PlaybackTimeline get timeline => throw UnimplementedError();
  MusicMetadata get metadata => throw UnimplementedError();
  PlaybackStatus? get status => throw UnimplementedError();
  Stream<PressedButton> get buttonPressStream => throw UnimplementedError();
  Stream<bool> get shuffleChangeStream => throw UnimplementedError();
  Stream<RepeatMode> get repeatModeChangeStream => throw UnimplementedError();

  bool get isPlayEnabled => config.playEnabled;
  bool get isPauseEnabled => config.pauseEnabled;
  bool get isStopEnabled => config.stopEnabled;
  bool get isNextEnabled => config.nextEnabled;
  bool get isPrevEnabled => config.prevEnabled;
  bool get isFastForwardEnabled => config.fastForwardEnabled;
  bool get isRewindEnabled => config.rewindEnabled;

  bool get isShuffleEnabled => throw UnimplementedError();
  RepeatMode get repeatMode => throw UnimplementedError();
  bool get enabled => throw UnimplementedError();

  Duration? get startTime => Duration(milliseconds: timeline.startTimeMs);
  Duration? get endTime => Duration(milliseconds: timeline.endTimeMs);
  Duration? get position => Duration(milliseconds: timeline.positionMs);
  Duration? get minSeekTime => timeline.minSeekTimeMs == null
      ? null
      : Duration(milliseconds: timeline.minSeekTimeMs!);
  Duration? get maxSeekTime => timeline.maxSeekTimeMs == null
      ? null
      : Duration(milliseconds: timeline.maxSeekTimeMs!);

  Future<void> updateConfig(SMTCConfig config) {
    throw UnimplementedError();
  }

  Future<void> updateTimeline(PlaybackTimeline timeline) {
    throw UnimplementedError();
  }

  Future<void> updateMetadata(MusicMetadata metadata) {
    throw UnimplementedError();
  }

  Future<void> clearMetadata() {
    throw UnimplementedError();
  }

  Future<void> dispose() async {
    throw UnimplementedError();
  }

  Future<void> disableSmtc() {
    throw UnimplementedError();
  }

  Future<void> enableSmtc() {
    throw UnimplementedError();
  }

  Future<void> setPlaybackStatus(PlaybackStatus status) async {
    throw UnimplementedError();
  }

  Future<void> setIsPlayEnabled(bool enabled) {
    throw UnimplementedError();
  }

  Future<void> setIsPauseEnabled(bool enabled) {
    throw UnimplementedError();
  }

  Future<void> setIsStopEnabled(bool enabled) {
    throw UnimplementedError();
  }

  Future<void> setIsNextEnabled(bool enabled) {
    throw UnimplementedError();
  }

  Future<void> setIsPrevEnabled(bool enabled) {
    throw UnimplementedError();
  }

  Future<void> setIsFastForwardEnabled(bool enabled) {
    throw UnimplementedError();
  }

  Future<void> setIsRewindEnabled(bool enabled) {
    throw UnimplementedError();
  }

  Future<void> setTimeline(PlaybackTimeline timeline) {
    return updateTimeline(timeline);
  }

  Future<void> setTitle(String title) {
    throw UnimplementedError();
  }

  Future<void> setArtist(String artist) {
    throw UnimplementedError();
  }

  Future<void> setAlbum(String album) {
    throw UnimplementedError();
  }

  Future<void> setAlbumArtist(String albumArtist) {
    throw UnimplementedError();
  }

  Future<void> setThumbnail(String thumbnail) {
    throw UnimplementedError();
  }

  Future<void> setPosition(Duration position) {
    throw UnimplementedError();
  }

  Future<void> setStartTime(Duration startTime) {
    throw UnimplementedError();
  }

  Future<void> setEndTime(Duration endTime) {
    throw UnimplementedError();
  }

  Future<void> setMaxSeekTime(Duration maxSeekTime) {
    throw UnimplementedError();
  }

  Future<void> setMinSeekTime(Duration minSeekTime) {
    throw UnimplementedError();
  }

  Future<void> setShuffleEnabled(bool enabled) {
    throw UnimplementedError();
  }

  Future<void> setRepeatMode(RepeatMode repeatMode) {
    throw UnimplementedError();
  }
}
