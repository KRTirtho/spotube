part of '../spotify.dart';

class AlbumTracksState extends PaginatedState<TrackSimple> {
  AlbumTracksState({
    required super.items,
    required super.offset,
    required super.limit,
  });

  @override
  AlbumTracksState copyWith({
    List<TrackSimple>? items,
    int? offset,
    int? limit,
  }) {
    return AlbumTracksState(
      items: items ?? this.items,
      offset: offset ?? this.offset,
      limit: limit ?? this.limit,
    );
  }
}

class AlbumTracksNotifier extends FamilyPaginatedAsyncNotifier<TrackSimple,
    AlbumTracksState, String> {
  AlbumTracksNotifier() : super();

  @override
  fetch(arg, offset, limit) async {
    final tracks = await spotify.albums.tracks(arg).getPage(offset, limit);
    return tracks.items?.toList() ?? [];
  }

  @override
  build(arg) async {
    ref.watch(spotifyProvider);
    final tracks = await fetch(arg, 0, 20);
    return AlbumTracksState(
      items: tracks,
      offset: 0,
      limit: 20,
    );
  }
}

final albumTracksProvider =
    AsyncNotifierProviderFamily<AlbumTracksNotifier, AlbumTracksState, String>(
  () => AlbumTracksNotifier(),
);
