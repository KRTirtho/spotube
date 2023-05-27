import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:piped_client/piped_client.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/shared/image/universal_image.dart';
import 'package:spotube/models/local_track.dart';
import 'package:spotube/models/spotube_track.dart';
import 'package:spotube/provider/blacklist_provider.dart';
import 'package:spotube/provider/palette_provider.dart';
import 'package:spotube/provider/proxy_playlist/next_fetcher_mixin.dart';
import 'package:spotube/provider/proxy_playlist/proxy_playlist.dart';
import 'package:spotube/provider/user_preferences_provider.dart';
import 'package:spotube/services/audio_player/audio_player.dart';
import 'package:spotube/services/audio_services/audio_services.dart';
import 'package:spotube/utils/persisted_state_notifier.dart';
import 'package:spotube/utils/type_conversion_utils.dart';

/// Things to implement:
/// * [x] Sponsor-Block skip
/// * [x] Prefetch next track as [SpotubeTrack] on 80% of current track
/// * [ ] Mixed Queue containing both [SpotubeTrack] and [LocalTrack]
/// * [ ] Modification of the Queue
///       * [x] Add track at the end
///       * [x] Add track at the beginning
///       * [x] Remove track
///       * [ ] Reorder track
/// * [x] Caching and loading of cache of tracks
/// * [x] Shuffling
/// * [x] loop => playlist, track, none
/// * [ ] Alternative Track Source
/// * [x] Blacklisting of tracks and artist
///
/// Don'ts:
/// * It'll not have any proxy method for [SpotubeAudioPlayer]
/// * It'll not store any sort of player state e.g playing, paused, shuffled etc
///   * For that, use [SpotubeAudioPlayer]

class ProxyPlaylistNotifier extends PersistedStateNotifier<ProxyPlaylist>
    with NextFetcher {
  final Ref ref;
  late final AudioServices notificationService;

  UserPreferences get preferences => ref.read(userPreferencesProvider);
  BlackListNotifier get blacklist =>
      ref.read(BlackListNotifier.provider.notifier);

  static final provider =
      StateNotifierProvider<ProxyPlaylistNotifier, ProxyPlaylist>(
    (ref) => ProxyPlaylistNotifier(ref),
  );

  static AlwaysAliveRefreshable<ProxyPlaylistNotifier> get notifier =>
      provider.notifier;

  ProxyPlaylistNotifier(this.ref) : super(ProxyPlaylist({}), "playlist") {
    () async {
      notificationService = await AudioServices.create(ref, this);

      audioPlayer.activeSourceChangedStream.listen((newActiveSource) {
        final newActiveTrack =
            mapSourcesToTracks([newActiveSource]).firstOrNull;

        if (newActiveTrack == null ||
            newActiveTrack.id == state.activeTrack?.id) {
          return;
        }

        notificationService.addTrack(newActiveTrack);
        state = state.copyWith(
          active: state.tracks
              .toList()
              .indexWhere((element) => element.id == newActiveTrack.id),
        );

        if (preferences.albumColorSync) {
          updatePalette();
        }
      });

      audioPlayer.shuffledStream.listen((event) {
        final newlyOrderedTracks = mapSourcesToTracks(audioPlayer.sources);

        final newActiveIndex = newlyOrderedTracks.indexWhere(
          (element) => element.id == state.activeTrack?.id,
        );

        if (newActiveIndex == -1) return;

        state = state.copyWith(
          tracks: newlyOrderedTracks.toSet(),
          active: newActiveIndex,
        );
      });

      bool isPreSearching = false;
      audioPlayer.percentCompletedStream(60).listen((percent) async {
        if (isPreSearching || audioPlayer.currentSource == null) return;
        try {
          isPreSearching = true;

          // TODO: Make repeat mode sensitive changes later
          final oldTrack =
              mapSourcesToTracks([audioPlayer.nextSource!]).firstOrNull;
          final track = await ensureSourcePlayable(audioPlayer.nextSource!);

          if (track != null) {
            state = state.copyWith(tracks: mergeTracks([track], state.tracks));
          }

          /// Sometimes fetching can take a lot of time, so we need to check
          /// if next source is playable or not at 99% progress. If not, then
          /// it'll be paused automatically
          ///
          /// After fetching the nextSource and replacing it, we need to check
          /// if the player is paused or not. If it is paused, then we need to
          /// resume it to skip to next track
          if (audioPlayer.isPaused) {
            await audioPlayer.resume();
          }

          if (oldTrack != null && track != null) {
            await storeTrack(
              oldTrack,
              track,
            );
          }
        } finally {
          isPreSearching = false;
        }
      });

      // player stops at 99% if nextSource is still not playable
      audioPlayer.percentCompletedStream(99).listen((_) async {
        if (audioPlayer.nextSource == null ||
            isPlayable(audioPlayer.nextSource!)) return;
        await audioPlayer.pause();
      });
    }();
  }

  Future<SpotubeTrack?> ensureSourcePlayable(String source) async {
    if (isPlayable(source)) return null;

    final track = mapSourcesToTracks([source]).firstOrNull;

    if (track == null || track is LocalTrack) {
      return null;
    }

    final nthFetchedTrack = switch (track.runtimeType) {
      SpotubeTrack => track as SpotubeTrack,
      _ => await SpotubeTrack.fetchFromTrack(track, preferences),
    };

    await audioPlayer.replaceSource(
      source,
      nthFetchedTrack.ytUri,
    );

    return nthFetchedTrack;
  }

  // Basic methods for adding or removing tracks to playlist

  Future<void> addTrack(Track track) async {
    if (blacklist.contains(track)) return;
    state = state.copyWith(tracks: {...state.tracks, track});
    await audioPlayer.addTrack(makeAppropriateSource(track));
  }

  Future<void> addTracks(Iterable<Track> tracks) async {
    tracks = blacklist.filter(tracks).toList() as List<Track>;
    state = state.copyWith(tracks: {...state.tracks, ...tracks});
    for (final track in tracks) {
      await audioPlayer.addTrack(makeAppropriateSource(track));
    }
  }

  // TODO: Safely Remove playing tracks

  Future<void> removeTrack(String trackId) async {
    final track =
        state.tracks.firstWhereOrNull((element) => element.id == trackId);
    if (track == null) return;
    state = state.copyWith(tracks: {...state.tracks..remove(track)});
    final index = audioPlayer.sources.indexOf(makeAppropriateSource(track));
    if (index == -1) return;
    await audioPlayer.removeTrack(index);
  }

  Future<void> removeTracks(Iterable<String> tracksIds) async {
    final tracks =
        state.tracks.where((element) => tracksIds.contains(element.id));

    state = state.copyWith(tracks: {
      ...state.tracks..removeWhere((element) => tracksIds.contains(element.id))
    });

    for (final track in tracks) {
      final index = audioPlayer.sources.indexOf(makeAppropriateSource(track));
      if (index == -1) continue;
      await audioPlayer.removeTrack(index);
    }
  }

  Future<void> load(
    Iterable<Track> tracks, {
    int initialIndex = 0,
    bool autoPlay = false,
  }) async {
    tracks = blacklist.filter(tracks).toList() as List<Track>;
    final addableTrack = await SpotubeTrack.fetchFromTrack(
        tracks.elementAt(initialIndex), preferences);

    state = state.copyWith(
      tracks: mergeTracks([addableTrack], tracks),
      active: initialIndex,
    );

    await audioPlayer.openPlaylist(
      state.tracks.map(makeAppropriateSource).toList(),
      initialIndex: initialIndex,
      autoPlay: autoPlay,
    );

    await storeTrack(
      tracks.elementAt(initialIndex),
      addableTrack,
    );
  }

  Future<void> jumpTo(int index) async {
    final oldTrack =
        mapSourcesToTracks([audioPlayer.currentSource!]).firstOrNull;
    state = state.copyWith(active: index);
    await audioPlayer.pause();
    final track = await ensureSourcePlayable(audioPlayer.sources[index]);
    if (track != null) {
      state = state.copyWith(
        tracks: mergeTracks([track], state.tracks),
        active: index,
      );
    }
    await audioPlayer.jumpTo(index);

    if (oldTrack != null && track != null) {
      await storeTrack(
        oldTrack,
        track,
      );
    }
  }

  Future<void> jumpToTrack(Track track) async {
    final index =
        state.tracks.toList().indexWhere((element) => element.id == track.id);
    if (index == -1) return;
    await jumpTo(index);
  }

  // TODO: add safe guards for active/playing track that needs to be moved
  Future<void> moveTrack(int oldIndex, int newIndex) async {
    if (oldIndex == newIndex ||
        newIndex < 0 ||
        oldIndex < 0 ||
        newIndex > state.tracks.length - 1 ||
        oldIndex > state.tracks.length - 1) return;

    final tracks = state.tracks.toList();
    final track = tracks.removeAt(oldIndex);
    tracks.insert(newIndex, track);
    state = state.copyWith(tracks: {...tracks});

    await audioPlayer.moveTrack(oldIndex, newIndex);
  }

  Future<void> addTracksAtFirst(Iterable<Track> tracks) async {
    tracks = blacklist.filter(tracks).toList() as List<Track>;
    final destIndex = state.active != null ? state.active! + 1 : 0;
    final newTracks = state.tracks.toList()..insertAll(destIndex, tracks);
    state = state.copyWith(tracks: newTracks.toSet());

    tracks.forEachIndexed((index, track) async {
      audioPlayer.addTrackAt(
        makeAppropriateSource(track),
        destIndex + index,
      );
    });
  }

  Future<void> populateSibling() async {}
  Future<void> swapSibling(PipedSearchItem video) async {}

  Future<void> next() async {
    if (audioPlayer.nextSource == null) return;
    final oldTrack = mapSourcesToTracks([audioPlayer.nextSource!]).firstOrNull;
    state = state.copyWith(
      active: state.tracks
          .toList()
          .indexWhere((element) => element.id == oldTrack?.id),
    );
    await audioPlayer.pause();
    final track = await ensureSourcePlayable(audioPlayer.nextSource!);
    if (track != null) {
      state = state.copyWith(
        tracks: mergeTracks([track], state.tracks),
        active: state.tracks
            .toList()
            .indexWhere((element) => element.id == track.id),
      );
    }
    await audioPlayer.skipToNext();

    if (oldTrack != null && track != null) {
      await storeTrack(
        oldTrack,
        track,
      );
    }
  }

  Future<void> previous() async {
    if (audioPlayer.previousSource == null) return;
    final oldTrack =
        mapSourcesToTracks([audioPlayer.previousSource!]).firstOrNull;
    state = state.copyWith(
      active: state.tracks
          .toList()
          .indexWhere((element) => element.id == oldTrack?.id),
    );
    await audioPlayer.pause();
    final track = await ensureSourcePlayable(audioPlayer.previousSource!);
    if (track != null) {
      state = state.copyWith(
        tracks: mergeTracks([track], state.tracks),
        active: state.tracks
            .toList()
            .indexWhere((element) => element.id == track.id),
      );
    }
    await audioPlayer.skipToPrevious();
    if (oldTrack != null && track != null) {
      await storeTrack(
        oldTrack,
        track,
      );
    }
  }

  Future<void> stop() async {
    state = ProxyPlaylist({});
    await audioPlayer.stop();
  }

  Future<void> updatePalette() {
    return Future.microtask(() async {
      final activeTrack = state.tracks.firstWhereOrNull(
        (track) =>
            track is SpotubeTrack && track.ytUri == audioPlayer.currentSource,
      );

      if (activeTrack == null) return;

      final palette = await PaletteGenerator.fromImageProvider(
        UniversalImage.imageProvider(
          TypeConversionUtils.image_X_UrlString(
            activeTrack.album?.images,
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
    super.state = state;
    if (state.tracks.isEmpty && ref.read(paletteProvider) != null) {
      ref.read(paletteProvider.notifier).state = null;
    }
  }

  @override
  onInit() {
    return load(
      state.tracks,
      initialIndex: state.active ?? 0,
      autoPlay: false,
    );
  }

  @override
  FutureOr<ProxyPlaylist> fromJson(Map<String, dynamic> json) {
    return ProxyPlaylist.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    final json = state.toJson();
    return json;
  }
}
