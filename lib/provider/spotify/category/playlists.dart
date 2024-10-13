part of '../spotify.dart';

class CategoryPlaylistsState extends PaginatedState<PlaylistSimple> {
  CategoryPlaylistsState({
    required super.items,
    required super.offset,
    required super.limit,
    required super.hasMore,
  });

  @override
  CategoryPlaylistsState copyWith({
    List<PlaylistSimple>? items,
    int? offset,
    int? limit,
    bool? hasMore,
  }) {
    return CategoryPlaylistsState(
      items: items ?? this.items,
      offset: offset ?? this.offset,
      limit: limit ?? this.limit,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

class CategoryPlaylistsNotifier extends AutoDisposeFamilyPaginatedAsyncNotifier<
    PlaylistSimple, CategoryPlaylistsState, String> {
  CategoryPlaylistsNotifier() : super();

  @override
  fetch(arg, offset, limit) async {
    final preferences = ref.read(userPreferencesProvider);
    final playlists = await Pages<PlaylistSimple?>(
      spotify,
      "v1/browse/categories/$arg/playlists?country=${preferences.market.name}&locale=${preferences.locale}",
      (json) => json == null ? null : PlaylistSimple.fromJson(json),
      'playlists',
      (json) => PlaylistsFeatured.fromJson(json),
    ).getPage(limit, offset);

    final items = playlists.items?.whereNotNull().toList() ?? [];

    return (
      items: items,
      hasMore: !playlists.isLast,
      nextOffset: playlists.nextOffset,
    );
  }

  @override
  build(arg) async {
    ref.cacheFor();

    ref.watch(spotifyProvider);
    ref.watch(userPreferencesProvider.select((s) => s.locale));
    ref.watch(userPreferencesProvider.select((s) => s.market));

    final (:items, :hasMore, :nextOffset) = await fetch(arg, 0, 8);

    return CategoryPlaylistsState(
      items: items,
      offset: nextOffset,
      limit: 8,
      hasMore: hasMore,
    );
  }
}

final categoryPlaylistsProvider = AutoDisposeAsyncNotifierProviderFamily<
    CategoryPlaylistsNotifier, CategoryPlaylistsState, String>(
  () => CategoryPlaylistsNotifier(),
);
