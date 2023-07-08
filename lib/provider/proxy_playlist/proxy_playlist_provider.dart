import 'dart:async';
import 'dart:convert';

import 'package:catcher/catcher.dart';
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/shared/image/universal_image.dart';
import 'package:spotube/models/local_track.dart';
import 'package:spotube/models/logger.dart';
import 'package:spotube/models/matched_track.dart';
import 'package:spotube/models/skip_segment.dart';
import 'package:spotube/models/spotube_track.dart';
import 'package:spotube/provider/blacklist_provider.dart';
import 'package:spotube/provider/palette_provider.dart';
import 'package:spotube/provider/proxy_playlist/next_fetcher_mixin.dart';
import 'package:spotube/provider/proxy_playlist/proxy_playlist.dart';
import 'package:spotube/provider/user_preferences_provider.dart';
import 'package:spotube/provider/youtube_provider.dart';
import 'package:spotube/services/audio_player/audio_player.dart';
import 'package:spotube/services/audio_services/audio_services.dart';
import 'package:spotube/services/youtube/youtube.dart';
import 'package:spotube/utils/persisted_state_notifier.dart';
import 'package:spotube/utils/type_conversion_utils.dart';

/// Things implemented:
/// * [x] Sponsor-Block skip
/// * [x] Prefetch next track as [SpotubeTrack] on 80% of current track
/// * [x] Mixed Queue containing both [SpotubeTrack] and [LocalTrack]
/// * [x] Modification of the Queue
///       * [x] Add track at the end
///       * [x] Add track at the beginning
///       * [x] Remove track
///       * [x] Reorder track
/// * [x] Caching and loading of cache of tracks
/// * [x] Shuffling
/// * [x] loop => playlist, track, none
/// * [x] Alternative Track Source
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
  YoutubeEndpoints get youtube => ref.read(youtubeProvider);
  ProxyPlaylist get playlist => state;
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

      (String, List<SkipSegment>)? currentSegments;
      bool isFetchingSegments = false;
      audioPlayer.activeSourceChangedStream.listen((newActiveSource) async {
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

        isFetchingSegments = true;

        isFetchingSegments = false;

        updatePalette();
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

      listenTo60Percent(percent) async {
        if (isPreSearching ||
            audioPlayer.currentSource == null ||
            audioPlayer.nextSource == null) return;
        try {
          isPreSearching = true;

          // TODO: Make repeat mode sensitive changes later
          final oldTrack =
              mapSourcesToTracks([audioPlayer.nextSource!]).firstOrNull;
          final track = await ensureSourcePlayable(audioPlayer.nextSource!);

          if (track != null) {
            state = state.copyWith(tracks: mergeTracks([track], state.tracks));
            if (currentSegments == null ||
                (oldTrack?.id != null &&
                        currentSegments!.$1 != oldTrack!.id!) &&
                    !isFetchingSegments) {
              isFetchingSegments = true;
              currentSegments = (
                audioPlayer.currentSource!,
                await getAndCacheSkipSegments(
                  track.ytTrack.id,
                ),
              );
              isFetchingSegments = false;
            }
          }

          if (oldTrack != null && track != null) {
            await storeTrack(
              oldTrack,
              track,
            );
          }
        } finally {
          isPreSearching = false;

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
        }
      }

      audioPlayer.percentCompletedStream(60).listen(listenTo60Percent);

      // player stops at 99% if nextSource is still not playable
      audioPlayer.percentCompletedStream(99).listen((_) async {
        if (audioPlayer.nextSource == null ||
            isPlayable(audioPlayer.nextSource!)) return;
        await audioPlayer.pause();
      });

      audioPlayer.positionStream.listen((position) async {
        if (preferences.searchMode == SearchMode.youtubeMusic ||
            !preferences.skipNonMusic) return;

        if (currentSegments == null ||
            currentSegments!.$1 != state.activeTrack!.id! &&
                !isFetchingSegments) {
          isFetchingSegments = true;
          currentSegments = (
            audioPlayer.currentSource!,
            await getAndCacheSkipSegments(
              (state.activeTrack as SpotubeTrack).ytTrack.id,
            ),
          );
          isFetchingSegments = false;
        }

        final (_, segments) = currentSegments!;
        if (segments.isEmpty) return;

        for (final segment in segments) {
          if ((position.inSeconds >= segment.start &&
              position.inSeconds < segment.end)) {
            await audioPlayer.seek(Duration(seconds: segment.end));
          }
        }
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
      _ => await SpotubeTrack.fetchFromTrack(track, youtube),
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

  void addCollection(String collectionId) {
    state = state.copyWith(collections: {
      ...state.collections,
      collectionId,
    });
  }

  void removeCollection(String collectionId) {
    state = state.copyWith(collections: {
      ...state.collections..remove(collectionId),
    });
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
    final indexTrack = tracks.elementAtOrNull(initialIndex) ?? tracks.first;

    if (indexTrack is LocalTrack) {
      state = state.copyWith(
        tracks: tracks.toSet(),
        active: initialIndex,
        collections: {},
      );
      await notificationService.addTrack(indexTrack);
    } else {
      final addableTrack = await SpotubeTrack.fetchFromTrack(
        tracks.elementAtOrNull(initialIndex) ?? tracks.first,
        youtube,
      );

      state = state.copyWith(
        tracks: mergeTracks([addableTrack], tracks),
        active: initialIndex,
        collections: {},
      );
      await notificationService.addTrack(addableTrack);
      await storeTrack(
        tracks.elementAt(initialIndex),
        addableTrack,
      );
    }

    await audioPlayer.openPlaylist(
      state.tracks.map(makeAppropriateSource).toList(),
      initialIndex: initialIndex,
      autoPlay: autoPlay,
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

    if (oldTrack != null || track != null) {
      await notificationService.addTrack(track ?? oldTrack!);
    }

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

  Future<void> populateSibling() async {
    if (state.activeTrack is SpotubeTrack) {
      final activeTrackWithSiblingsForSure =
          await (state.activeTrack as SpotubeTrack).populatedCopy(youtube);

      state = state.copyWith(
        tracks: mergeTracks([activeTrackWithSiblingsForSure], state.tracks),
        active: state.tracks.toList().indexWhere(
            (element) => element.id == activeTrackWithSiblingsForSure.id),
      );
    }
  }

  Future<void> swapSibling(YoutubeVideoInfo video) async {
    if (state.activeTrack is SpotubeTrack) {
      await populateSibling();
      final newTrack =
          await (state.activeTrack as SpotubeTrack).swappedCopy(video, youtube);
      if (newTrack == null) return;
      state = state.copyWith(
        tracks: mergeTracks([newTrack], state.tracks),
        active: state.tracks
            .toList()
            .indexWhere((element) => element.id == newTrack.id),
      );
      await audioPlayer.pause();
      await audioPlayer.replaceSource(
        audioPlayer.currentSource!,
        makeAppropriateSource(newTrack),
      );
    }
  }

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

    if (oldTrack != null || track != null) {
      await notificationService.addTrack(track ?? oldTrack!);
    }
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
    if (oldTrack != null || track != null) {
      await notificationService.addTrack(track ?? oldTrack!);
    }
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

  Future<void> updatePalette() async {
    final palette = ref.read(paletteProvider);
    if (!preferences.albumColorSync) {
      if (palette != null) ref.read(paletteProvider.notifier).state = null;
      return;
    }
    return Future.microtask(() async {
      if (state.activeTrack == null) return;

      final palette = await PaletteGenerator.fromImageProvider(
        UniversalImage.imageProvider(
          TypeConversionUtils.image_X_UrlString(
            state.activeTrack?.album?.images,
            placeholder: ImagePlaceholder.albumArt,
          ),
          height: 50,
          width: 50,
        ),
      );
      ref.read(paletteProvider.notifier).state = palette;
    });
  }

  Future<List<SkipSegment>> getAndCacheSkipSegments(String id) async {
    if (!preferences.skipNonMusic ||
        preferences.searchMode != SearchMode.youtube) return [];

    try {
      final cached = await SkipSegment.box.get(id);
      if (cached != null && cached.isNotEmpty) {
        return List.castFrom<dynamic, SkipSegment>(cached);
      }

      final res = await get(Uri(
        scheme: "https",
        host: "sponsor.ajay.app",
        path: "/api/skipSegments",
        queryParameters: {
          "videoID": id,
          "category": [
            'sponsor',
            'selfpromo',
            'interaction',
            'intro',
            'outro',
            'music_offtopic'
          ],
          "actionType": 'skip'
        },
      ));

      if (res.body == "Not Found") {
        return List.castFrom<dynamic, SkipSegment>([]);
      }

      final data = jsonDecode(res.body) as List;
      final segments = data.map((obj) {
        final start = obj["segment"].first.toInt();
        final end = obj["segment"].last.toInt();
        return SkipSegment(
          start,
          end,
        );
      }).toList();
      getLogger('getSkipSegments').v(
        "[SponsorBlock] successfully fetched skip segments for $id",
      );

      await SkipSegment.box.put(
        id,
        segments,
      );
      return List.castFrom<dynamic, SkipSegment>(segments);
    } catch (e, stack) {
      await SkipSegment.box.put(id, []);
      Catcher.reportCheckedError(e, stack);
      return List.castFrom<dynamic, SkipSegment>([]);
    }
  }

  @override
  set state(state) {
    super.state = state;
    if (state.tracks.isEmpty && ref.read(paletteProvider) != null) {
      ref.read(paletteProvider.notifier).state = null;
    } else {
      updatePalette();
    }
  }

  @override
  onInit() async {
    if (state.tracks.isEmpty) return null;
    final oldCollections = state.collections;
    await load(
      state.tracks,
      initialIndex: state.active ?? 0,
      autoPlay: false,
    );
    state = state.copyWith(collections: oldCollections);
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
