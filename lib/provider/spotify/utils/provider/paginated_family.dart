part of '../../spotify.dart';

abstract class FamilyPaginatedAsyncNotifier<
    K,
    T extends BasePaginatedState<K, dynamic>,
    A> extends FamilyAsyncNotifier<T, A> with SpotifyMixin<T> {
  Future<List<K>> fetch(A arg, int offset, int limit);

  Future<void> fetchMore() async {
    if (state.value == null || !state.value!.hasMore) return;

    state = AsyncLoadingNext(state.asData!.value);

    state = await AsyncValue.guard(
      () async {
        final items = await fetch(
          arg,
          state.value!.offset + state.value!.limit,
          state.value!.limit,
        );
        return state.value!.copyWith(
          hasMore: items.length == state.value!.limit,
          items: [
            ...state.value!.items,
            ...items,
          ],
          offset: state.value!.offset + state.value!.limit,
        ) as T;
      },
    );
  }

  Future<List<K>> fetchAll() async {
    if (state.value == null) return [];
    if (!state.value!.hasMore) return state.value!.items;

    bool hasMore = true;
    while (hasMore) {
      await update((state) async {
        final items = await fetch(
          arg,
          state.offset + state.limit,
          state.limit,
        );

        hasMore = items.length == state.limit;
        return state.copyWith(
          items: [...state.items, ...items],
          offset: state.offset + state.limit,
          hasMore: hasMore,
        ) as T;
      });
    }

    return state.value!.items;
  }
}

abstract class AutoDisposeFamilyPaginatedAsyncNotifier<
    K,
    T extends BasePaginatedState<K, dynamic>,
    A> extends AutoDisposeFamilyAsyncNotifier<T, A> with SpotifyMixin<T> {
  Future<List<K>> fetch(A arg, int offset, int limit);

  Future<void> fetchMore() async {
    if (state.value == null || !state.value!.hasMore) return;

    state = AsyncLoadingNext(state.asData!.value);

    state = await AsyncValue.guard(
      () async {
        final items = await fetch(
          arg,
          state.value!.offset + state.value!.limit,
          state.value!.limit,
        );
        return state.value!.copyWith(
          hasMore: items.length == state.value!.limit,
          items: [
            ...state.value!.items,
            ...items,
          ],
          offset: state.value!.offset + state.value!.limit,
        ) as T;
      },
    );
  }

  Future<List<K>> fetchAll() async {
    if (state.value == null) return [];
    if (!state.value!.hasMore) return state.value!.items;

    bool hasMore = true;
    while (hasMore) {
      await update((state) async {
        final items = await fetch(
          arg,
          state.offset + state.limit,
          state.limit,
        );

        hasMore = items.length == state.limit;
        return state.copyWith(
          items: [...state.items, ...items],
          offset: state.offset + state.limit,
          hasMore: hasMore,
        ) as T;
      });
    }

    return state.value!.items;
  }
}
