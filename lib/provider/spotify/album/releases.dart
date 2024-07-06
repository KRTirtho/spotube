part of '../spotify.dart';

class AlbumReleasesState extends PaginatedState<Album> {
  AlbumReleasesState({
    required super.items,
    required super.offset,
    required super.limit,
    required super.hasMore,
  });

  @override
  AlbumReleasesState copyWith({
    List<Album>? items,
    int? offset,
    int? limit,
    bool? hasMore,
  }) {
    return AlbumReleasesState(
      items: items ?? this.items,
      offset: offset ?? this.offset,
      limit: limit ?? this.limit,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

class AlbumReleasesNotifier
    extends PaginatedAsyncNotifier<Album, AlbumReleasesState> {
  AlbumReleasesNotifier() : super();

  @override
  fetch(int offset, int limit) async {
    final market = ref.read(userPreferencesProvider).market;

    final albums = await spotify.browse
        .newReleases(country: market)
        .getPage(limit, offset);

    return albums.items?.map((album) => album.toAlbum()).toList() ?? [];
  }

  @override
  build() async {
    ref.watch(spotifyProvider);
    ref.watch(
      userPreferencesProvider.select((s) => s.market),
    );
    ref.watch(allFollowedArtistsProvider);

    final albums = await fetch(0, 20);

    return AlbumReleasesState(
      items: albums,
      offset: 0,
      limit: 20,
      hasMore: albums.length == 20,
    );
  }
}

final albumReleasesProvider =
    AsyncNotifierProvider<AlbumReleasesNotifier, AlbumReleasesState>(
  () => AlbumReleasesNotifier(),
);

final userArtistAlbumReleasesProvider = Provider<List<Album>>((ref) {
  final newReleases = ref.watch(albumReleasesProvider);
  final userArtistsQuery = ref.watch(allFollowedArtistsProvider);

  if (newReleases.isLoading || userArtistsQuery.isLoading) {
    return const [];
  }

  final userArtists =
      userArtistsQuery.asData?.value.map((s) => s.id!).toList() ?? const [];

  final allReleases = newReleases.asData?.value.items;
  final userArtistReleases = allReleases?.where((album) {
    return album.artists?.any((artist) => userArtists.contains(artist.id!)) ==
        true;
  }).toList();

  if (userArtistReleases?.isEmpty == true) {
    return allReleases?.toList() ?? [];
  }
  return userArtistReleases ?? [];
});
