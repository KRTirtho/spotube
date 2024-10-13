part of '../../spotify.dart';

typedef PseudoPaginatedProps<T> = ({
  List<T> items,
  int nextOffset,
  bool hasMore,
});

abstract class FamilyPaginatedAsyncNotifier<
    K,
    T extends BasePaginatedState<K, dynamic>,
    A> extends FamilyAsyncNotifier<T, A> with SpotifyMixin<T> {
  Future<PseudoPaginatedProps<K>> fetch(A arg, int offset, int limit);

  Future<void> fetchMore() async {
    if (state.value == null || !state.value!.hasMore) return;

    state = AsyncLoadingNext(state.asData!.value);

    state = await AsyncValue.guard(
      () async {
        final (:items, :hasMore, :nextOffset) = await fetch(
          arg,
          state.value!.offset,
          state.value!.limit,
        );
        return state.value!.copyWith(
          hasMore: hasMore,
          items: [
            ...state.value!.items,
            ...items,
          ],
          offset: nextOffset,
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
        final res = await fetch(
          arg,
          state.offset,
          state.limit,
        );

        hasMore = res.hasMore;
        return state.copyWith(
          items: [...state.items, ...res.items],
          offset: res.nextOffset,
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
  Future<PseudoPaginatedProps<K>> fetch(A arg, int offset, int limit);

  Future<void> fetchMore() async {
    if (state.value == null || !state.value!.hasMore) return;

    state = AsyncLoadingNext(state.asData!.value);

    state = await AsyncValue.guard(
      () async {
        final (:items, :hasMore, :nextOffset) = await fetch(
          arg,
          state.value!.offset,
          state.value!.limit,
        );

        return state.value!.copyWith(
          hasMore: hasMore,
          items: [
            ...state.value!.items,
            ...items,
          ],
          offset: nextOffset,
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
        final res = await fetch(
          arg,
          state.offset,
          state.limit,
        );

        hasMore = res.hasMore;
        return state.copyWith(
          items: [...state.items, ...res.items],
          offset: res.nextOffset,
          hasMore: hasMore,
        ) as T;
      });
    }

    return state.value!.items;
  }
}
