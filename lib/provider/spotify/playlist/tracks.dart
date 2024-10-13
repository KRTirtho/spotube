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

class PlaylistTracksNotifier extends AutoDisposeFamilyPaginatedAsyncNotifier<
    Track, PlaylistTracksState, String> {
  PlaylistTracksNotifier() : super();

  @override
  fetch(arg, offset, limit) async {
    final tracks = await spotify.playlists
        .getTracksByPlaylistId(arg)
        .getPage(limit, offset);

    /// Filter out tracks with null id because some personal playlists
    /// may contain local tracks that are not available in the Spotify catalog
    final items = tracks.items
            ?.where((track) => track.id != null && track.type == "track")
            .toList() ??
        <Track>[];

    return (
      items: items,
      hasMore: !tracks.isLast,
      nextOffset: tracks.nextOffset,
    );
  }

  @override
  build(arg) async {
    ref.cacheFor();

    ref.watch(spotifyProvider);
    final (items: tracks, :hasMore, :nextOffset) = await fetch(arg, 0, 20);

    return PlaylistTracksState(
      items: tracks,
      offset: nextOffset,
      limit: 20,
      hasMore: hasMore,
    );
  }
}

final playlistTracksProvider = AutoDisposeAsyncNotifierProviderFamily<
    PlaylistTracksNotifier, PlaylistTracksState, String>(
  () => PlaylistTracksNotifier(),
);
