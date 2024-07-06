part of '../spotify.dart';

final searchTermStateProvider = StateProvider.autoDispose<String>(
  (ref) {
    ref.cacheFor(const Duration(minutes: 2));
    return "";
  },
);

class SearchState<Y> extends PaginatedState<Y> {
  SearchState({
    required super.items,
    required super.offset,
    required super.limit,
    required super.hasMore,
  });

  @override
  SearchState<Y> copyWith({
    List<Y>? items,
    int? offset,
    int? limit,
    bool? hasMore,
  }) {
    return SearchState(
      items: items ?? this.items,
      offset: offset ?? this.offset,
      limit: limit ?? this.limit,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

class SearchNotifier<Y> extends AutoDisposeFamilyPaginatedAsyncNotifier<Y,
    SearchState<Y>, SearchType> {
  SearchNotifier() : super();

  @override
  fetch(arg, offset, limit) async {
    if (state.value == null) return [];
    final results = await spotify.search
        .get(
          ref.read(searchTermStateProvider),
          types: [arg],
          market: ref.read(userPreferencesProvider).market,
        )
        .getPage(limit, offset);

    return results.expand((e) => e.items ?? <Y>[]).toList().cast<Y>();
  }

  @override
  build(arg) async {
    ref.cacheFor(const Duration(minutes: 2));

    ref.watch(searchTermStateProvider);
    ref.watch(spotifyProvider);
    ref.watch(
      userPreferencesProvider.select((value) => value.market),
    );

    final results = await fetch(arg, 0, 10);

    return SearchState<Y>(
      items: results,
      offset: 0,
      limit: 10,
      hasMore: results.length == 10,
    );
  }
}

final searchProvider = AsyncNotifierProvider.autoDispose
    .family<SearchNotifier, SearchState, SearchType>(
  () => SearchNotifier(),
);
