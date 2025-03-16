part of '../spotify.dart';

class FeaturedPlaylistsState extends PaginatedState<PlaylistSimple> {
  FeaturedPlaylistsState({
    required super.items,
    required super.offset,
    required super.limit,
    required super.hasMore,
  });

  @override
  FeaturedPlaylistsState copyWith({
    List<PlaylistSimple>? items,
    int? offset,
    int? limit,
    bool? hasMore,
  }) {
    return FeaturedPlaylistsState(
      items: items ?? this.items,
      offset: offset ?? this.offset,
      limit: limit ?? this.limit,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

class FeaturedPlaylistsNotifier
    extends PaginatedAsyncNotifier<PlaylistSimple, FeaturedPlaylistsState> {
  FeaturedPlaylistsNotifier() : super();

  @override
  fetch(int offset, int limit) async {
    final playlists = await spotify.invoke(
      (api) => api.playlists.featured.getPage(limit, offset),
    );

    return playlists.items?.toList() ?? [];
  }

  @override
  build() async {
    ref.watch(spotifyProvider);
    final playlists = await fetch(0, 20);

    return FeaturedPlaylistsState(
      items: playlists,
      offset: 0,
      limit: 20,
      hasMore: playlists.length == 20,
    );
  }
}

final featuredPlaylistsProvider =
    AsyncNotifierProvider<FeaturedPlaylistsNotifier, FeaturedPlaylistsState>(
  () => FeaturedPlaylistsNotifier(),
);
