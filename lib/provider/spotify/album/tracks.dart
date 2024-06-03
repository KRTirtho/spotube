part of '../spotify.dart';

class AlbumTracksState extends PaginatedState<Track> {
  AlbumTracksState({
    required super.items,
    required super.offset,
    required super.limit,
    required super.hasMore,
  });

  @override
  AlbumTracksState copyWith({
    List<Track>? items,
    int? offset,
    int? limit,
    bool? hasMore,
  }) {
    return AlbumTracksState(
      items: items ?? this.items,
      offset: offset ?? this.offset,
      limit: limit ?? this.limit,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

class AlbumTracksNotifier extends AutoDisposeFamilyPaginatedAsyncNotifier<Track,
    AlbumTracksState, AlbumSimple> {
  AlbumTracksNotifier() : super();

  @override
  fetch(arg, offset, limit) async {
    final tracks = await spotify.albums.tracks(arg.id!).getPage(limit, offset);
    return tracks.items?.map((e) => e.asTrack(arg)).toList() ?? [];
  }

  @override
  build(arg) async {
    ref.cacheFor();

    ref.watch(spotifyProvider);
    final tracks = await fetch(arg, 0, 20);
    return AlbumTracksState(
      items: tracks,
      offset: 0,
      limit: 20,
      hasMore: tracks.length == 20,
    );
  }
}

final albumTracksProvider = AutoDisposeAsyncNotifierProviderFamily<
    AlbumTracksNotifier, AlbumTracksState, AlbumSimple>(
  () => AlbumTracksNotifier(),
);
