import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/shared/image/universal_image.dart';
import 'package:spotube/models/local_track.dart';
import 'package:spotube/models/spotube_track.dart';
import 'package:spotube/extensions/track.dart';
import 'package:spotube/provider/blacklist_provider.dart';
import 'package:spotube/provider/palette_provider.dart';
import 'package:spotube/provider/user_preferences_provider.dart';
import 'package:spotube/services/audio_player.dart';
import 'package:spotube/services/audio_services/audio_services.dart';
import 'package:spotube/utils/persisted_state_notifier.dart';
import 'package:spotube/utils/type_conversion_utils.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' hide Playlist;
import 'package:collection/collection.dart';

class PlaylistQueue {
  final Set<Track> tracks;
  final Set<Track> tempTracks;
  final bool loop;
  final int active;

  Track get activeTrack => tracks.elementAt(active);

  static Future<PlaylistQueue> fromJson(
      Map<String, dynamic> json, UserPreferences preferences) async {
    final List? tracks = json['tracks'];
    final List? tempTracks = json['tempTracks'];
    return PlaylistQueue(
      Set.from(
        await Future.wait(
          tracks?.mapIndexed(
                (i, e) async {
                  final jsonTrack =
                      Map.castFrom<dynamic, dynamic, String, dynamic>(e);

                  if (e["path"] != null) {
                    return LocalTrack.fromJson(jsonTrack);
                  } else if (i == json["active"] && !json.containsKey("path")) {
                    return await SpotubeTrack.fetchFromTrack(
                      Track.fromJson(jsonTrack),
                      preferences,
                    );
                  } else {
                    return Track.fromJson(jsonTrack);
                  }
                },
              ) ??
              [],
        ),
      ),
      active: json['active'],
      tempTracks: Set.from(
        await Future.wait(
          tempTracks?.mapIndexed(
                (i, e) async {
                  final jsonTrack =
                      Map.castFrom<dynamic, dynamic, String, dynamic>(e);

                  if (e["path"] != null) {
                    return LocalTrack.fromJson(jsonTrack);
                  } else if (i == json["active"] && !json.containsKey("path")) {
                    return await SpotubeTrack.fetchFromTrack(
                      Track.fromJson(jsonTrack),
                      preferences,
                    );
                  } else {
                    return Track.fromJson(jsonTrack);
                  }
                },
              ) ??
              [],
        ),
      ),
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
      'tempTracks': tempTracks.map(
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
    };
  }

  bool get isLoading =>
      activeTrack is LocalTrack ? false : activeTrack is! SpotubeTrack;
  bool get isShuffled => tempTracks.isNotEmpty;
  bool get isLooping => loop;

  PlaylistQueue(
    this.tracks, {
    required this.tempTracks,
    this.active = 0,
    this.loop = false,
  }) : assert(active < tracks.length && active >= 0, "Invalid active index");

  PlaylistQueue copyWith({
    Set<Track>? tracks,
    Set<Track>? tempTracks,
    int? active,
    bool? loop,
  }) {
    return PlaylistQueue(
      tracks ?? this.tracks,
      active: active ?? this.active,
      tempTracks: tempTracks ?? this.tempTracks,
      loop: loop ?? this.loop,
    );
  }
}

class PlaylistQueueNotifier extends PersistedStateNotifier<PlaylistQueue?> {
  final Ref ref;

  AudioServices? audioServices;

  static final provider =
      StateNotifierProvider<PlaylistQueueNotifier, PlaylistQueue?>(
    (ref) => PlaylistQueueNotifier._(ref),
  );

  static final notifier = provider.notifier;

  PlaylistQueueNotifier._(this.ref) : super(null, "playlist") {
    configure();
  }

  void configure() async {
    audioServices = await AudioServices.create(ref, this);

    audioPlayer.onPlayerComplete.listen((event) async {
      if (!isLoaded) return;
      if (state!.isLooping) {
        await audioPlayer.seek(Duration.zero);
        await audioPlayer.resume();
      } else {
        await next();
      }
    });

    bool isPreSearching = false;

    audioPlayer.onPositionChanged.listen((pos) async {
      if (!isLoaded) return;
      final currentDuration = await audioPlayer.getDuration() ?? Duration.zero;

      // skip all the activeTrack.skipSegments
      if (state?.isLoading != true &&
          state?.activeTrack is SpotubeTrack &&
          (state?.activeTrack as SpotubeTrack?)?.skipSegments.isNotEmpty ==
              true &&
          preferences.skipSponsorSegments) {
        for (final segment
            in (state!.activeTrack as SpotubeTrack).skipSegments) {
          if ((pos.inSeconds >= segment["start"]! &&
              pos.inSeconds < segment["end"]!)) {
            await audioPlayer.seek(Duration(seconds: segment["end"]!));
          }
        }
      }

      // when the track progress is above 80%, track isn't the last
      // and is not already fetched and nothing is fetching currently
      if (pos.inSeconds > currentDuration.inSeconds * .8 &&
          state!.active != state!.tracks.length - 1 &&
          state!.tracks.elementAt(state!.active + 1) is! SpotubeTrack &&
          !isPreSearching) {
        isPreSearching = true;
        final tracks = state!.tracks.toList();
        tracks[state!.active + 1] = await SpotubeTrack.fetchFromTrack(
          state!.tracks.elementAt(state!.active + 1),
          preferences,
        );
        state = state!.copyWith(tracks: Set.from(tracks));
        isPreSearching = false;
      }
    });
  }

  // properties

  // getters
  UserPreferences get preferences => ref.read(userPreferencesProvider);
  BlackListNotifier get blacklist =>
      ref.read(BlackListNotifier.provider.notifier);

  bool get isLoaded => state != null;

  // redirectors
  static bool get isPlaying => audioPlayer.state == PlayerState.playing;
  static bool get isPaused => audioPlayer.state == PlayerState.paused;
  static bool get isStopped => audioPlayer.state == PlayerState.stopped;

  static Stream<Duration> get duration =>
      audioPlayer.onDurationChanged.asBroadcastStream();
  static Stream<Duration> get position =>
      audioPlayer.onPositionChanged.asBroadcastStream();
  static Stream<bool> get playing => audioPlayer.onPlayerStateChanged
      .map((event) => event == PlayerState.playing)
      .asBroadcastStream();

  List<Video> get siblings => state?.isLoading == false
      ? (state!.activeTrack as SpotubeTrack).siblings
      : [];

  // modifiers
  void add(List<Track> tracks) {
    if (!isLoaded) {
      loadAndPlay(tracks);
    } else {
      state = state?.copyWith(
        tracks: state!.tracks..addAll(tracks),
      );
    }
  }

  void playNext(List<Track> tracks) {
    if (!isLoaded) {
      loadAndPlay(tracks);
    } else {
      final stateTracks = state!.tracks.toList();

      stateTracks.insertAll(state!.active + 1, tracks);

      state = state?.copyWith(tracks: Set.from(stateTracks));
    }
  }

  void remove(List<Track> tracks) {
    if (!isLoaded) return;
    final trackIds = tracks.map((e) => e.id!).toSet();
    final newTracks = state!.tracks.whereNot(
      (element) => trackIds.contains(element.id),
    );

    if (newTracks.isEmpty) {
      stop();
      return;
    }
    state = state?.copyWith(
      tracks: newTracks.toSet(),
      active: !newTracks.contains(state!.activeTrack)
          ? state!.active > newTracks.length - 1
              ? newTracks.length - 1
              : state!.active
          : null,
    );
    if (state!.isLoading) {
      play();
    }
  }

  void shuffle() {
    if (!isLoaded || state!.isShuffled) return;
    state = state?.copyWith(
      tempTracks: state!.tracks,
      tracks: {
        state!.activeTrack,
        ...state!.tracks.toList()
          ..removeAt(state!.active)
          ..shuffle()
      },
      active: 0,
    );
  }

  void unshuffle() {
    if (!isLoaded || !state!.isShuffled) return;
    state = state?.copyWith(
      tracks: state!.tempTracks,
      active: state!.tempTracks
          .toList()
          .indexWhere((element) => element.id == state!.activeTrack.id),
      tempTracks: {},
    );
  }

  void loop() {
    if (!isLoaded || state!.isLooping) return;
    state = state?.copyWith(
      loop: true,
    );
  }

  void unloop() {
    if (!isLoaded || !state!.isLooping) return;
    state = state?.copyWith(
      loop: false,
    );
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
    audioServices?.activateSession();
    await audioServices?.addTrack(state!.activeTrack);
    if (state!.activeTrack is LocalTrack) {
      await audioPlayer.play(
        DeviceFileSource((state!.activeTrack as LocalTrack).path),
        mode: PlayerMode.mediaPlayer,
      );
      return;
    }
    if (state!.activeTrack is! SpotubeTrack) {
      final tracks = state!.tracks.toList();
      tracks[state!.active] = await SpotubeTrack.fetchFromTrack(
        state!.activeTrack,
        preferences,
      );
      final tempTracks = state!.tempTracks
          .map((e) =>
              e.id == tracks[state!.active].id ? tracks[state!.active] : e)
          .toList();

      state = state!.copyWith(
        tracks: Set.from(tracks),
        tempTracks: Set.from(tempTracks),
      );
    }

    audioServices?.addTrack(state!.activeTrack);

    final cached =
        await DefaultCacheManager().getFileFromCache(state!.activeTrack.id!);
    if (preferences.predownload && cached != null) {
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

  Future<void> playTrack(Track track) async {
    if (!isLoaded) return;
    final active =
        state!.tracks.toList().indexWhere((element) => element.id == track.id);
    if (active == -1) return;
    state = state!.copyWith(active: active);
    return play();
  }

  void load(Iterable<Track> tracks, {int active = 0}) {
    final activeTrack = tracks.elementAt(active);
    final filtered = Set.from(blacklist.filter(tracks));
    state = PlaylistQueue(
      Set.from(blacklist.filter(tracks)),
      tempTracks: {},
      active: filtered
          .toList()
          .indexWhere((element) => element.id == activeTrack.id),
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
    audioServices?.deactivateSession();
    state = null;

    return audioPlayer.stop();
  }

  Future<void> next() async {
    if (!isLoaded) return;
    if (state!.active == state!.tracks.length - 1) {
      state = state!.copyWith(
        active: 0,
      );
    } else {
      state = state!.copyWith(
        active: state!.active + 1,
      );
    }
    return play();
  }

  Future<void> previous() async {
    if (!isLoaded) return;
    if (state!.active == 0) {
      state = state!.copyWith(
        active: state!.tracks.length - 1,
      );
    } else {
      state = state!.copyWith(
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

    final trackIds = (state!.isShuffled ? state!.tempTracks : state!.tracks)
        .map((track) => track.id!);
    return blacklist
        .filter(playlist)
        .every((track) => trackIds.contains(track.id!));
  }

  bool isTrackOnQueue(TrackSimple track) {
    if (!isLoaded) return false;
    if (state!.isShuffled) {
      final trackIds = state!.tempTracks.map((track) => track.id!);
      return trackIds.contains(track.id!);
    }
    final trackIds = state!.tracks.map((track) => track.id!);
    return trackIds.contains(track.id!);
  }

  void reorder(int oldIndex, int newIndex) {
    if (!isLoaded) return;

    final tracks = state!.tracks.toList();
    final track = tracks.removeAt(oldIndex);
    tracks.insert(newIndex, track);
    final active =
        tracks.indexWhere((element) => element.id == state!.activeTrack.id);
    state = state!.copyWith(tracks: Set.from(tracks), active: active);
  }

  Future<void> updatePalette() {
    return Future.microtask(() async {
      final palette = await PaletteGenerator.fromImageProvider(
        UniversalImage.imageProvider(
          TypeConversionUtils.image_X_UrlString(
            state?.activeTrack.album?.images,
            placeholder: ImagePlaceholder.albumArt,
          ),
          height: 50,
          width: 50,
        ),
      );
      ref.read(paletteProvider.notifier).state = palette;
    });
  }

  @override
  set state(state) {
    if (preferences.albumColorSync &&
        state != null &&
        state.active != this.state?.active) {
      updatePalette();
    } else if (state == null && ref.read(paletteProvider) != null) {
      ref.read(paletteProvider.notifier).state = null;
    }
    super.state = state;
  }

  @override
  Future<PlaylistQueue>? fromJson(Map<String, dynamic> json) {
    if (json.isEmpty) return null;
    return PlaylistQueue.fromJson(json, preferences);
  }

  @override
  Map<String, dynamic> toJson() {
    return state?.toJson() ?? {};
  }

  @override
  void dispose() {
    audioServices?.dispose();
    super.dispose();
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
