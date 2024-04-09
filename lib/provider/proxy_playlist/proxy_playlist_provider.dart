import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/shared/image/universal_image.dart';
import 'package:spotube/extensions/image.dart';
import 'package:spotube/models/local_track.dart';

import 'package:spotube/provider/blacklist_provider.dart';
import 'package:spotube/provider/palette_provider.dart';
import 'package:spotube/provider/proxy_playlist/next_fetcher_mixin.dart';
import 'package:spotube/provider/proxy_playlist/player_listeners.dart';
import 'package:spotube/provider/proxy_playlist/proxy_playlist.dart';
import 'package:spotube/provider/scrobbler_provider.dart';
import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';
import 'package:spotube/provider/user_preferences/user_preferences_state.dart';
import 'package:spotube/services/audio_player/audio_player.dart';
import 'package:spotube/services/audio_services/audio_services.dart';
import 'package:spotube/provider/discord_provider.dart';
import 'package:spotube/services/sourced_track/models/source_info.dart';
import 'package:spotube/services/sourced_track/sourced_track.dart';

import 'package:spotube/utils/persisted_state_notifier.dart';

class ProxyPlaylistNotifier extends PersistedStateNotifier<ProxyPlaylist>
    with NextFetcher {
  final Ref ref;
  late final AudioServices notificationService;

  ScrobblerNotifier get scrobbler => ref.read(scrobblerProvider.notifier);
  UserPreferences get preferences => ref.read(userPreferencesProvider);
  ProxyPlaylist get playlist => state;
  BlackListNotifier get blacklist =>
      ref.read(BlackListNotifier.provider.notifier);
  Discord get discord => ref.read(discordProvider);

  static final provider =
      StateNotifierProvider<ProxyPlaylistNotifier, ProxyPlaylist>(
    (ref) => ProxyPlaylistNotifier(ref),
  );

  static AlwaysAliveRefreshable<ProxyPlaylistNotifier> get notifier =>
      provider.notifier;

  List<StreamSubscription> _subscriptions = [];

  ProxyPlaylistNotifier(this.ref) : super(ProxyPlaylist({}), "playlist") {
    AudioServices.create(ref, this).then(
      (value) => notificationService = value,
    );

    _subscriptions = [
      // These are subscription methods from player_listeners.dart
      subscribeToSourceChanges(),
      subscribeToPercentCompletion(),
      subscribeToShuffleChanges(),
      subscribeToSkipSponsor(),
      subscribeToScrobbleChanged(),
    ];
  }

  Future<SourcedTrack?> ensureSourcePlayable(String source) async {
    if (isPlayable(source)) return null;

    final track = mapSourcesToTracks([source]).firstOrNull;

    if (track == null || track is LocalTrack) {
      return null;
    }

    final nthFetchedTrack = switch (track.runtimeType) {
      SourcedTrack() => track as SourcedTrack,
      _ => await SourcedTrack.fetchFromTrack(ref: ref, track: track),
    };

    await audioPlayer.replaceSource(
      source,
      nthFetchedTrack.url,
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
      discord.updatePresence(indexTrack);
    } else {
      final addableTrack = await SourcedTrack.fetchFromTrack(
        ref: ref,
        track: tracks.elementAtOrNull(initialIndex) ?? tracks.first,
      ).catchError((e, stackTrace) {
        return SourcedTrack.fetchFromTrack(
          ref: ref,
          track: tracks.elementAtOrNull(initialIndex + 1) ?? tracks.first,
        );
      });

      state = state.copyWith(
        tracks: mergeTracks([addableTrack], tracks),
        active: initialIndex,
        collections: {},
      );
      await notificationService.addTrack(addableTrack);
      discord.updatePresence(addableTrack);
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
      discord.updatePresence(track ?? oldTrack!);
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
    if (state.tracks.length == 1) {
      return addTracks(tracks);
    }

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
    if (state.activeTrack is SourcedTrack) {
      final activeTrackWithSiblingsForSure =
          await (state.activeTrack as SourcedTrack).copyWithSibling();

      state = state.copyWith(
        tracks: mergeTracks([activeTrackWithSiblingsForSure], state.tracks),
        active: state.tracks.toList().indexWhere(
            (element) => element.id == activeTrackWithSiblingsForSure.id),
      );
    }
  }

  Future<void> swapSibling(SourceInfo sibling) async {
    if (state.activeTrack is SourcedTrack) {
      await populateSibling();
      final newTrack =
          await (state.activeTrack as SourcedTrack).swapWithSibling(sibling);
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
      discord.updatePresence(track ?? oldTrack!);
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
      discord.updatePresence(track ?? oldTrack!);
    }
  }

  Future<void> stop() async {
    state = ProxyPlaylist({});
    await audioPlayer.stop();
    discord.clear();
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
          (state.activeTrack?.album?.images).asUrlString(
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
      initialIndex: max(state.active ?? 0, 0),
      autoPlay: false,
    );
    state = state.copyWith(collections: oldCollections);
  }

  @override
  FutureOr<ProxyPlaylist> fromJson(Map<String, dynamic> json) {
    return ProxyPlaylist.fromJson(json, ref);
  }

  @override
  Map<String, dynamic> toJson() {
    final json = state.toJson();
    return json;
  }

  @override
  void dispose() {
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    super.dispose();
  }
}
