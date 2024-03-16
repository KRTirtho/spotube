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

class CategoryPlaylistsNotifier extends FamilyPaginatedAsyncNotifier<
    PlaylistSimple, CategoryPlaylistsState, String> {
  CategoryPlaylistsNotifier() : super();

  @override
  fetch(arg, offset, limit) async {
    final preferences = ref.read(userPreferencesProvider);
    final playlists = await Pages<PlaylistSimple?>(
      spotify,
      "v1/browse/categories/$arg/playlists?country=${preferences.recommendationMarket.name}&locale=${preferences.locale}",
      (json) => json == null ? null : PlaylistSimple.fromJson(json),
      'playlists',
      (json) => PlaylistsFeatured.fromJson(json),
    ).getPage(limit, offset);

    return playlists.items?.whereNotNull().toList() ?? [];
  }

  @override
  build(arg) async {
    ref.watch(spotifyProvider);
    ref.watch(userPreferencesProvider.select((s) => s.locale));
    ref.watch(userPreferencesProvider.select((s) => s.recommendationMarket));

    final playlists = await fetch(arg, 0, 8);

    return CategoryPlaylistsState(
      items: playlists,
      offset: 0,
      limit: 8,
      hasMore: playlists.length == 8,
    );
  }
}

final categoryPlaylistsProvider = AsyncNotifierProviderFamily<
    CategoryPlaylistsNotifier, CategoryPlaylistsState, String>(
  () => CategoryPlaylistsNotifier(),
);
