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
    final items = tracks.items?.map((e) => e.asTrack(arg)).toList() ?? [];

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
    final (:items, :nextOffset, :hasMore) = await fetch(arg, 0, 20);
    return AlbumTracksState(
      items: items,
      offset: nextOffset,
      limit: 20,
      hasMore: hasMore,
    );
  }
}

final albumTracksProvider = AutoDisposeAsyncNotifierProviderFamily<
    AlbumTracksNotifier, AlbumTracksState, AlbumSimple>(
  () => AlbumTracksNotifier(),
);
