part of '../../spotify.dart';

abstract class FamilyCursorPaginatedAsyncNotifier<
    K,
    T extends CursorPaginatedState<K>,
    A> extends FamilyAsyncNotifier<T, A> with SpotifyMixin<T> {
  Future<(List<K> items, String nextCursor)> fetch(
    A arg,
    String? offset,
    int limit,
  );

  Future<void> fetchMore() async {
    if (state.value == null || !state.value!.hasMore) return;

    state = AsyncLoadingNext(state.asData!.value);

    state = await AsyncValue.guard(
      () async {
        final items = await fetch(arg, state.value!.offset, state.value!.limit);
        return state.value!.copyWith(
          hasMore: items.$1.length == state.value!.limit,
          items: [
            ...state.value!.items,
            ...items.$1,
          ],
          offset: items.$2,
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
          state.offset,
          state.limit,
        );

        hasMore = items.$1.length == state.limit;
        return state.copyWith(
          items: [...state.items, ...items.$1],
          offset: items.$2,
          hasMore: hasMore,
        ) as T;
      });
    }

    return state.value!.items;
  }
}

abstract class AutoDisposeFamilyCursorPaginatedAsyncNotifier<
    K,
    T extends CursorPaginatedState<K>,
    A> extends AutoDisposeFamilyAsyncNotifier<T, A> with SpotifyMixin<T> {
  Future<(List<K> items, String nextCursor)> fetch(
    A arg,
    String? offset,
    int limit,
  );

  Future<void> fetchMore() async {
    if (state.value == null || !state.value!.hasMore) return;

    state = AsyncLoadingNext(state.asData!.value);

    state = await AsyncValue.guard(
      () async {
        final items = await fetch(arg, state.value!.offset, state.value!.limit);
        return state.value!.copyWith(
          hasMore: items.$1.length == state.value!.limit,
          items: [
            ...state.value!.items,
            ...items.$1,
          ],
          offset: items.$2,
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
          state.offset,
          state.limit,
        );

        hasMore = items.$1.length == state.limit;
        return state.copyWith(
          items: [...state.items, ...items.$1],
          offset: items.$2,
          hasMore: hasMore,
        ) as T;
      });
    }

    return state.value!.items;
  }
}
