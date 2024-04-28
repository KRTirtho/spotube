import 'dart:async';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/extensions/track.dart';
import 'package:spotube/models/local_track.dart';

import 'package:spotube/provider/blacklist_provider.dart';
import 'package:spotube/provider/history/history.dart';
import 'package:spotube/provider/palette_provider.dart';
import 'package:spotube/provider/proxy_playlist/player_listeners.dart';
import 'package:spotube/provider/proxy_playlist/proxy_playlist.dart';
import 'package:spotube/provider/scrobbler_provider.dart';
import 'package:spotube/provider/server/sourced_track.dart';
import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';
import 'package:spotube/provider/user_preferences/user_preferences_state.dart';
import 'package:spotube/services/audio_player/audio_player.dart';
import 'package:spotube/services/audio_services/audio_services.dart';
import 'package:spotube/provider/discord_provider.dart';

import 'package:spotube/utils/persisted_state_notifier.dart';

class ProxyPlaylistNotifier extends PersistedStateNotifier<ProxyPlaylist> {
  final Ref ref;
  late final AudioServices notificationService;

  ScrobblerNotifier get scrobbler => ref.read(scrobblerProvider.notifier);
  UserPreferences get preferences => ref.read(userPreferencesProvider);
  ProxyPlaylist get playlist => state;
  BlackListNotifier get blacklist => ref.read(blacklistProvider.notifier);
  Discord get discord => ref.read(discordProvider);
  PlaybackHistoryNotifier get history =>
      ref.read(playbackHistoryProvider.notifier);

  List<StreamSubscription> _subscriptions = [];

  ProxyPlaylistNotifier(this.ref) : super(ProxyPlaylist({}), "playlist") {
    AudioServices.create(ref, this).then(
      (value) => notificationService = value,
    );

    _subscriptions = [
      // These are subscription methods from player_listeners.dart
      subscribeToPlaylist(),
      subscribeToSkipSponsor(),
      subscribeToPosition(),
      subscribeToScrobbleChanged(),
    ];
  }
  // Basic methods for adding or removing tracks to playlist

  Future<void> addTrack(Track track) async {
    if (blacklist.contains(track)) return;
    await audioPlayer.addTrack(SpotubeMedia(track));
  }

  Future<void> addTracks(Iterable<Track> tracks) async {
    tracks = blacklist.filter(tracks).toList() as List<Track>;
    for (final track in tracks) {
      await audioPlayer.addTrack(SpotubeMedia(track));
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
    final trackIndex =
        state.tracks.toList().indexWhere((element) => element.id == trackId);
    if (trackIndex == -1) return;
    await audioPlayer.removeTrack(trackIndex);
  }

  Future<void> removeTracks(Iterable<String> tracksIds) async {
    final tracks = state.tracks.map((t) => t.id!).toList();

    for (final track in tracks) {
      final index = tracks.indexOf(track);
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

    state = state.copyWith(collections: {});

    // Giving the initial track a boost so MediaKit won't skip
    // because of timeout
    final intendedActiveTrack = tracks.elementAt(initialIndex);
    if (intendedActiveTrack is! LocalTrack) {
      await ref.read(sourcedTrackProvider(intendedActiveTrack).future);
    }

    await audioPlayer.openPlaylist(
      tracks.asMediaList(),
      initialIndex: initialIndex,
      autoPlay: autoPlay,
    );
  }

  Future<void> jumpTo(int index) async {
    await audioPlayer.jumpTo(index);
  }

  Future<void> jumpToTrack(Track track) async {
    final index =
        state.tracks.toList().indexWhere((element) => element.id == track.id);
    if (index == -1) return;
    await jumpTo(index);
  }

  Future<void> moveTrack(int oldIndex, int newIndex) async {
    if (oldIndex == newIndex ||
        newIndex < 0 ||
        oldIndex < 0 ||
        newIndex > state.tracks.length - 1 ||
        oldIndex > state.tracks.length - 1) return;

    await audioPlayer.moveTrack(oldIndex, newIndex);
  }

  Future<void> addTracksAtFirst(Iterable<Track> tracks) async {
    if (state.tracks.length == 1) {
      return addTracks(tracks);
    }

    tracks = blacklist.filter(tracks).toList() as List<Track>;

    for (int i = 0; i < tracks.length; i++) {
      final track = tracks.elementAt(i);

      await audioPlayer.addTrackAt(
        SpotubeMedia(track),
        (state.active ?? 0) + i + 1,
      );
    }
  }

  Future<void> next() async {
    await audioPlayer.skipToNext();
  }

  Future<void> previous() async {
    await audioPlayer.skipToPrevious();
  }

  Future<void> stop() async {
    state = ProxyPlaylist({});
    await audioPlayer.stop();
    discord.clear();
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
    return ProxyPlaylist.fromJson(json);
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

final proxyPlaylistProvider =
    StateNotifierProvider<ProxyPlaylistNotifier, ProxyPlaylist>(
  (ref) => ProxyPlaylistNotifier(ref),
);
