part of '../spotify.dart';

class ArtistAlbumsState extends PaginatedState<Album> {
  ArtistAlbumsState({
    required super.items,
    required super.offset,
    required super.limit,
    required super.hasMore,
  });

  @override
  ArtistAlbumsState copyWith({
    List<Album>? items,
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

class ArtistAlbumsNotifier extends AutoDisposeFamilyPaginatedAsyncNotifier<
    Album, ArtistAlbumsState, String> {
  ArtistAlbumsNotifier() : super();

  @override
  fetch(arg, offset, limit) async {
    final market = ref.read(userPreferencesProvider).market;
    final albums = await spotify.artists
        .albums(arg, country: market)
        .getPage(limit, offset);

    final items = albums.items?.toList() ?? [];

    return (
      items: items,
      hasMore: !albums.isLast,
      nextOffset: albums.nextOffset,
    );
  }

  @override
  build(arg) async {
    ref.cacheFor();

    ref.watch(spotifyProvider);
    ref.watch(
      userPreferencesProvider.select((s) => s.market),
    );
    final (:items, :hasMore, :nextOffset) = await fetch(arg, 0, 20);
    return ArtistAlbumsState(
      items: items,
      offset: nextOffset,
      limit: 20,
      hasMore: hasMore,
    );
  }
}

final artistAlbumsProvider = AutoDisposeAsyncNotifierProviderFamily<
    ArtistAlbumsNotifier, ArtistAlbumsState, String>(
  () => ArtistAlbumsNotifier(),
);
