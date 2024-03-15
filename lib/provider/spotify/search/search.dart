part of '../spotify.dart';

class SearchState<Y> extends PaginatedState<Y> {
  final String query;
  SearchState({
    required super.items,
    required super.offset,
    required super.limit,
    required super.hasMore,
    required this.query,
  });

  @override
  SearchState<Y> copyWith({
    List<Y>? items,
    int? offset,
    int? limit,
    bool? hasMore,
    String? query,
  }) {
    return SearchState(
      items: items ?? this.items,
      offset: offset ?? this.offset,
      limit: limit ?? this.limit,
      hasMore: hasMore ?? this.hasMore,
      query: query ?? this.query,
    );
  }
}

class SearchNotifier<Y>
    extends FamilyPaginatedAsyncNotifier<Y, SearchState<Y>, SearchType> {
  SearchNotifier() : super();

  @override
  fetch(arg, offset, limit) async {
    if (state.value == null) return [];
    final results = await spotify.search
        .get(
          state.value!.query,
          types: [arg],
          market: ref.read(userPreferencesProvider).recommendationMarket,
        )
        .getPage(limit, offset);

    return results.expand((e) => e.items ?? <Y>[]).toList().cast<Y>();
  }

  @override
  build(arg) async {
    ref.watch(spotifyProvider);
    ref.watch(
      userPreferencesProvider.select((value) => value.recommendationMarket),
    );

    final results = await fetch(arg, 0, 10);

    return SearchState<Y>(
      items: results,
      offset: 0,
      limit: 10,
      hasMore: results.length == 10,
      query: "",
    );
  }

  Future<void> search(String query) async {
    if (state.value == null) return;

    state = AsyncData(
      state.value!.copyWith(
        query: query,
      ),
    );

    await update((state) async {
      final results = await fetch(arg, 0, 10);

      return state.copyWith(
        items: results,
        offset: 0,
        limit: 10,
        hasMore: results.length == 10,
      );
    });
  }
}

final searchProvider =
    AsyncNotifierProvider.family<SearchNotifier, SearchState, SearchType>(
  () => SearchNotifier(),
);
