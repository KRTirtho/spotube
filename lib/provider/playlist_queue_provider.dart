import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/models/local_track.dart';
import 'package:spotube/models/spotube_track.dart';
import 'package:spotube/extensions/track.dart';
import 'package:spotube/provider/blacklist_provider.dart';
import 'package:spotube/provider/user_preferences_provider.dart';
import 'package:spotube/services/linux_audio_service.dart';
import 'package:spotube/services/mobile_audio_service.dart';
import 'package:spotube/utils/persisted_state_notifier.dart';
import 'package:spotube/utils/platform.dart';
import 'package:spotube/utils/type_conversion_utils.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' hide Playlist;

final audioPlayer = AudioPlayer();
final youtube = YoutubeExplode();

class PlaylistQueue {
  final Set<Track> tracks;
  final int active;

  Track get activeTrack => tracks.elementAt(active);

  factory PlaylistQueue.fromJson(Map<String, dynamic> json) {
    return PlaylistQueue(
      Set.from(json['tracks'].map(
        (e) {
          final json = Map.castFrom<dynamic, dynamic, String, dynamic>(e);
          if (e["ytTrack"] != null) {
            return SpotubeTrack.fromJson(json);
          } else if (e["path"] != null) {
            return LocalTrack.fromJson(json);
          } else {
            return Track.fromJson(json);
          }
        },
      )),
      active: json['active'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tracks': tracks.map(
        (e) {
          if (e is SpotubeTrack) {
            return e.toJson();
          } else if (e is LocalTrack) {
            return e.toJson();
          } else {
            return e.toJson();
          }
        },
      ).toList(),
      'active': active,
    };
  }

  bool get isLoading =>
      activeTrack is LocalTrack ? false : activeTrack is! SpotubeTrack;

  PlaylistQueue(
    this.tracks, {
    this.active = 0,
  });

  PlaylistQueue copyWith({
    Set<Track>? tracks,
    int? active,
  }) {
    return PlaylistQueue(
      tracks ?? this.tracks,
      active: active ?? this.active,
    );
  }
}

class PlaylistQueueNotifier extends PersistedStateNotifier<PlaylistQueue?> {
  final Ref ref;
  MobileAudioService? mobileService;
  LinuxAudioService? linuxService;

  static final provider =
      StateNotifierProvider<PlaylistQueueNotifier, PlaylistQueue?>(
    (ref) => PlaylistQueueNotifier._(ref),
  );

  static final notifier = provider.notifier;

  PlaylistQueueNotifier._(this.ref) : super(null, "playlist") {
    configure();
  }

  void configure() async {
    if (kIsMobile || kIsMacOS) {
      mobileService = await AudioService.init(
        builder: () => MobileAudioService(ref),
        config: const AudioServiceConfig(
          androidNotificationChannelId: 'com.krtirtho.Spotube',
          androidNotificationChannelName: 'Spotube',
          androidNotificationOngoing: true,
        ),
      );
    }
    if (kIsLinux) {
      linuxService = LinuxAudioService(ref);
    }
    addListener((state) {
      linuxService?.player.updateProperties();
    });

    audioPlayer.onPlayerStateChanged.listen((event) {
      linuxService?.player.updateProperties();
    });

    audioPlayer.onPlayerComplete.listen((event) => next());

    bool isPreSearching = false;

    audioPlayer.onPositionChanged.listen((pos) async {
      if (!isLoaded) return;
      await linuxService?.player.updateProperties();
      final currentDuration = await audioPlayer.getDuration() ?? Duration.zero;

      // when the track progress is above 80%, track isn't the last
      // and is not already fetched and nothing is fetching currently
      if (pos.inSeconds > currentDuration.inSeconds * .8 &&
          state!.active != state!.tracks.length - 1 &&
          state!.tracks.elementAt(state!.active + 1) is! SpotubeTrack &&
          !isPreSearching) {
        isPreSearching = true;
        final tracks = state!.tracks.toList();
        tracks[state!.active + 1] = await SpotubeTrack.fromFetchTrack(
          state!.tracks.elementAt(state!.active + 1),
          preferences,
        );
        state = state!.copyWith(tracks: Set.from(tracks));
        isPreSearching = false;
      }
    });
  }

  // properties

  Set<Track> _tempTracks = {};

  // getters
  UserPreferences get preferences => ref.read(userPreferencesProvider);
  BlackListNotifier get blacklist =>
      ref.read(BlackListNotifier.provider.notifier);

  bool get isLoaded => state != null;
  bool get isShuffled => _tempTracks.isNotEmpty;

  // redirectors
  static bool get isPlaying => audioPlayer.state == PlayerState.playing;
  static bool get isPaused => audioPlayer.state == PlayerState.paused;
  static bool get isStopped => audioPlayer.state == PlayerState.stopped;

  static Stream<Duration> get duration => audioPlayer.onDurationChanged;
  static Stream<Duration> get position => audioPlayer.onPositionChanged;
  static Stream<bool> get playing => audioPlayer.onPlayerStateChanged
      .map((event) => event == PlayerState.playing);

  List<Video> get siblings => state?.isLoading == false
      ? (state!.activeTrack as SpotubeTrack).siblings
      : [];

  // modifiers
  void add(Track track) {
    state = state?.copyWith(
      tracks: state!.tracks..add(track),
    );
  }

  void remove(Track track) {
    state = state?.copyWith(
      tracks: state!.tracks..remove(track),
    );
  }

  void shuffle() {
    if (isShuffled || !isLoaded) return;
    _tempTracks = state?.tracks ?? _tempTracks;
    state = state?.copyWith(
      tracks: {
        state!.activeTrack,
        ..._tempTracks.toList()
          ..removeAt(state!.active)
          ..shuffle()
      },
    );
  }

  void unshuffle() {
    if (!isShuffled || !isLoaded) return;
    state = state?.copyWith(
      tracks: _tempTracks,
    );
    _tempTracks = {};
  }

  Future<void> swapSibling(Video video) async {
    if (!isLoaded || state!.isLoading) return;
    await pause();
    final tracks = state!.tracks.toList();
    final track = await (state!.activeTrack as SpotubeTrack)
        .swappedCopy(video, preferences);
    if (track == null) return;
    tracks[state!.active] = track;

    state = state!.copyWith(tracks: Set.from(tracks));
    await play();
  }

  Future<void> populateSibling() async {
    if (!isLoaded || state!.isLoading) return;
    final tracks = state!.tracks.toList();
    final track = await (state!.activeTrack as SpotubeTrack).populatedCopy();
    tracks[state!.active] = track;
    state = state!.copyWith(tracks: Set.from(tracks));
  }

  Future<void> play() async {
    if (!isLoaded) return;
    await pause();
    await mobileService?.session?.setActive(true);
    final mediaItem = MediaItem(
      id: state!.activeTrack.id!,
      title: state!.activeTrack.name!,
      album: state!.activeTrack.album?.name,
      artist: TypeConversionUtils.artists_X_String(
          state!.activeTrack.artists ?? <ArtistSimple>[]),
      artUri: Uri.parse(
        TypeConversionUtils.image_X_UrlString(
          state!.activeTrack.album?.images,
          placeholder: ImagePlaceholder.online,
        ),
      ),
      duration: state!.activeTrack.duration,
    );
    mobileService?.addItem(mediaItem);
    if (state!.activeTrack is LocalTrack) {
      await audioPlayer.play(
        DeviceFileSource((state!.activeTrack as LocalTrack).path),
        mode: PlayerMode.mediaPlayer,
      );
      return;
    }
    if (state!.activeTrack is! SpotubeTrack) {
      final tracks = state!.tracks.toList();
      tracks[state!.active] = await SpotubeTrack.fromFetchTrack(
        state!.activeTrack,
        preferences,
      );
      state = state!.copyWith(tracks: Set.from(tracks));
    }

    mobileService?.addItem(mediaItem.copyWith(
      duration: (state!.activeTrack as SpotubeTrack).ytTrack.duration,
    ));

    final cached =
        await DefaultCacheManager().getFileFromCache(state!.activeTrack.id!);
    if (preferences.androidBytesPlay && cached != null) {
      await audioPlayer.play(
        DeviceFileSource(cached.file.path),
        mode: PlayerMode.mediaPlayer,
      );
    } else {
      await audioPlayer.play(
        UrlSource((state!.activeTrack as SpotubeTrack).ytUri),
        mode: PlayerMode.mediaPlayer,
      );
    }
  }

  Future<void> playAt(int index) async {
    if (!isLoaded) return;
    state = PlaylistQueue(
      state!.tracks,
      active: index,
    );
    return play();
  }

  void load(Iterable<Track> tracks, {int active = 0}) {
    state = PlaylistQueue(
      Set.from(blacklist.filter(tracks)),
      active: active,
    );
  }

  Future<void> loadAndPlay(Iterable<Track> tracks, {int active = 0}) async {
    load(tracks, active: active);
    await play();
  }

  Future<void> pause() {
    return audioPlayer.pause();
  }

  Future<void> resume() {
    return audioPlayer.resume();
  }

  Future<void> stop() async {
    (mobileService)?.session?.setActive(false);
    state = null;
    _tempTracks = {};
    return audioPlayer.stop();
  }

  Future<void> next() async {
    if (!isLoaded) return;
    if (state!.active == state!.tracks.length - 1) {
      state = PlaylistQueue(
        state!.tracks,
        active: 0,
      );
    } else {
      state = PlaylistQueue(
        state!.tracks,
        active: state!.active + 1,
      );
    }
    return play();
  }

  Future<void> previous() async {
    if (!isLoaded) return;
    if (state!.active == 0) {
      state = PlaylistQueue(
        state!.tracks,
        active: state!.tracks.length - 1,
      );
    } else {
      state = PlaylistQueue(
        state!.tracks,
        active: state!.active - 1,
      );
    }
    return play();
  }

  Future<void> seek(Duration position) async {
    if (!isLoaded) return;
    await audioPlayer.seek(position);
    await resume();
  }

  // utility
  bool isPlayingPlaylist(Iterable<TrackSimple> playlist) {
    if (!isLoaded || playlist.isEmpty) return false;
    if (isShuffled) {
      final trackIds = _tempTracks.map((track) => track.id!);
      return blacklist
          .filter(playlist)
          .every((track) => trackIds.contains(track.id!));
    }
    final trackIds = state!.tracks.map((track) => track.id!);
    return blacklist
        .filter(playlist)
        .every((track) => trackIds.contains(track.id!));
  }

  @override
  PlaylistQueue? fromJson(Map<String, dynamic> json) {
    if (json.isEmpty) return null;
    return PlaylistQueue.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    return state?.toJson() ?? {};
  }
}

class VolumeProvider extends PersistedStateNotifier<double> {
  VolumeProvider() : super(1, 'volume');

  static final provider = StateNotifierProvider<VolumeProvider, double>((ref) {
    return VolumeProvider();
  });

  Future<void> setVolume(double volume) async {
    if (volume > 1) {
      state = 1;
    } else if (volume < 0) {
      state = 0;
    } else {
      state = volume;
    }
    await audioPlayer.setVolume(state);
    await audioPlayer.setVolume(state);
  }

  void increaseVolume() {
    setVolume(state + 0.1);
  }

  void decreaseVolume() {
    setVolume(state - 0.1);
  }

  @override
  double fromJson(Map<String, dynamic> json) {
    return json['volume'] as double;
  }

  @override
  Map<String, dynamic> toJson() {
    return {'volume': state};
  }
}
