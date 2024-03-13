part of '../spotify.dart';

class AlbumReleasesState extends PaginatedState<AlbumSimple> {
  AlbumReleasesState({
    required super.items,
    required super.offset,
    required super.limit,
  });

  @override
  AlbumReleasesState copyWith({
    List<AlbumSimple>? items,
    int? offset,
    int? limit,
  }) {
    return AlbumReleasesState(
      items: items ?? this.items,
      offset: offset ?? this.offset,
      limit: limit ?? this.limit,
    );
  }
}

class AlbumReleasesNotifier
    extends PaginatedAsyncNotifier<AlbumSimple, AlbumReleasesState> {
  AlbumReleasesNotifier() : super();

  @override
  fetch(int offset, int limit) async {
    final market = ref.read(userPreferencesProvider).recommendationMarket;
    final albums = await spotify.browse
        .newReleases(country: market)
        .getPage(offset, limit);
    return albums.items?.toList() ?? [];
  }

  @override
  build() async {
    ref.watch(spotifyProvider);
    ref.watch(
      userPreferencesProvider.select((s) => s.recommendationMarket),
    );
    final albums = await fetch(0, 20);
    return AlbumReleasesState(
      items: albums,
      offset: 0,
      limit: 20,
    );
  }
}

final albumReleasesProvider =
    AsyncNotifierProvider<AlbumReleasesNotifier, AlbumReleasesState>(
  () => AlbumReleasesNotifier(),
);
