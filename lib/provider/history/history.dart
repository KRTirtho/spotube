import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/provider/history/state.dart';
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
  PlaybackHistoryNotifier()
      : super(const PlaybackHistoryState(), "playback_history");

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

  void addTracks(List<TrackSimple> tracks) {
    state = state.copyWith(
      items: [
        ...state.items,
        for (final track in tracks)
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
  (ref) => PlaybackHistoryNotifier(),
);
