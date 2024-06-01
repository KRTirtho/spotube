import 'dart:async';

import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/provider/history/state.dart';
import 'package:spotube/provider/spotify_provider.dart';
import 'package:spotube/utils/persisted_state_notifier.dart';

class PlaybackHistoryState {
  final List<PlaybackHistoryItem> items;
  const PlaybackHistoryState({this.items = const []});

  factory PlaybackHistoryState.fromJson(Map<String, dynamic> json) {
    return PlaybackHistoryState(
      items: json["items"]
              ?.map(
                (json) => PlaybackHistoryItem.fromJson(json),
              )
              .toList()
              .cast<PlaybackHistoryItem>() ??
          <PlaybackHistoryItem>[],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "items": items.map((s) => s.toJson()).toList(),
    };
  }

  PlaybackHistoryState copyWith({
    List<PlaybackHistoryItem>? items,
  }) {
    return PlaybackHistoryState(items: items ?? this.items);
  }
}

class PlaybackHistoryNotifier
    extends PersistedStateNotifier<PlaybackHistoryState> {
  final Ref ref;
  PlaybackHistoryNotifier(this.ref)
      : super(const PlaybackHistoryState(), "playback_history");

  SpotifyApi get spotify => ref.read(spotifyProvider);

  @override
  FutureOr<PlaybackHistoryState> fromJson(Map<String, dynamic> json) =>
      PlaybackHistoryState.fromJson(json);

  @override
  Map<String, dynamic> toJson() {
    return state.toJson();
  }

  void addPlaylists(List<PlaylistSimple> playlists) {
    state = state.copyWith(
      items: [
        ...state.items,
        for (final playlist in playlists)
          PlaybackHistoryItem.playlist(
              date: DateTime.now(), playlist: playlist),
      ],
    );
  }

  void addAlbums(List<AlbumSimple> albums) {
    state = state.copyWith(
      items: [
        ...state.items,
        for (final album in albums)
          PlaybackHistoryItem.album(date: DateTime.now(), album: album),
      ],
    );
  }

  void addTrack(Track track) async {
    // For some reason Track's artists images are `null`
    // so we need to fetch them from the API
    final artists =
        await spotify.artists.list(track.artists!.map((e) => e.id!).toList());

    track.artists = artists.toList();

    state = state.copyWith(
      items: [
        ...state.items,
        PlaybackHistoryItem.track(date: DateTime.now(), track: track),
      ],
    );
  }

  void clear() {
    state = state.copyWith(items: []);
  }
}

final playbackHistoryProvider =
    StateNotifierProvider<PlaybackHistoryNotifier, PlaybackHistoryState>(
  (ref) => PlaybackHistoryNotifier(ref),
);

typedef PlaybackHistoryGrouped = ({
  List<PlaybackHistoryTrack> tracks,
  List<PlaybackHistoryAlbum> albums,
  List<PlaybackHistoryPlaylist> playlists,
});

final playbackHistoryGroupedProvider = Provider<PlaybackHistoryGrouped>((ref) {
  final history = ref.watch(playbackHistoryProvider);
  final tracks = history.items
      .whereType<PlaybackHistoryTrack>()
      .sorted((a, b) => b.date.compareTo(a.date))
      .toList();
  final albums = history.items
      .whereType<PlaybackHistoryAlbum>()
      .sorted((a, b) => b.date.compareTo(a.date))
      .toList();
  final playlists = history.items
      .whereType<PlaybackHistoryPlaylist>()
      .sorted((a, b) => b.date.compareTo(a.date))
      .toList();

  return (
    tracks: tracks,
    albums: albums,
    playlists: playlists,
  );
});
