part of '../spotify.dart';

class ArtistAlbumsState extends PaginatedState<AlbumSimple> {
  ArtistAlbumsState({
    required super.items,
    required super.offset,
    required super.limit,
    required super.hasMore,
  });

  @override
  ArtistAlbumsState copyWith({
    List<AlbumSimple>? items,
    int? offset,
    int? limit,
    bool? hasMore,
  }) {
    return ArtistAlbumsState(
      items: items ?? this.items,
      offset: offset ?? this.offset,
      limit: limit ?? this.limit,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

class ArtistAlbumsNotifier extends FamilyPaginatedAsyncNotifier<AlbumSimple,
    ArtistAlbumsState, String> {
  ArtistAlbumsNotifier() : super();

  @override
  fetch(arg, offset, limit) async {
    final market = ref.read(userPreferencesProvider).recommendationMarket;
    final albums = await spotify.artists
        .albums(arg, country: market)
        .getPage(offset, limit);

    return albums.items?.toList() ?? [];
  }

  @override
  build(arg) async {
    ref.watch(spotifyProvider);
    ref.watch(
      userPreferencesProvider.select((s) => s.recommendationMarket),
    );
    final albums = await fetch(arg, 0, 20);
    return ArtistAlbumsState(
      items: albums,
      offset: 0,
      limit: 20,
      hasMore: albums.length == 20,
    );
  }
}

final artistAlbumsProvider = AsyncNotifierProviderFamily<ArtistAlbumsNotifier,
    ArtistAlbumsState, String>(
  () => ArtistAlbumsNotifier(),
);
