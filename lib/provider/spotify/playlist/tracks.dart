part of '../spotify.dart';

class PlaylistTracksState extends PaginatedState<Track> {
  PlaylistTracksState({
    required super.items,
    required super.offset,
    required super.limit,
    required super.hasMore,
  });

  @override
  PlaylistTracksState copyWith({
    List<Track>? items,
    int? offset,
    int? limit,
    bool? hasMore,
  }) {
    return PlaylistTracksState(
      items: items ?? this.items,
      offset: offset ?? this.offset,
      limit: limit ?? this.limit,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

class PlaylistTracksNotifier
    extends FamilyPaginatedAsyncNotifier<Track, PlaylistTracksState, String> {
  PlaylistTracksNotifier() : super();

  @override
  fetch(arg, offset, limit) async {
    final tracks = await spotify.playlists
        .getTracksByPlaylistId(arg)
        .getPage(limit, offset);

    return tracks.items?.toList() ?? <Track>[];
  }

  @override
  build(arg) async {
    ref.watch(spotifyProvider);
    final tracks = await fetch(arg, 0, 20);

    return PlaylistTracksState(
      items: tracks,
      offset: 0,
      limit: 20,
      hasMore: tracks.length == 20,
    );
  }
}

final playlistTracksProvider = AsyncNotifierProviderFamily<
    PlaylistTracksNotifier, PlaylistTracksState, String>(
  () => PlaylistTracksNotifier(),
);
