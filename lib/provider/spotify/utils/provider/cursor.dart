part of '../../spotify.dart';

mixin CursorPaginatedAsyncNotifierMixin<K, T extends CursorPaginatedState<K>>
// ignore: invalid_use_of_internal_member
    on AsyncNotifierBase<T> {
  Future<(List<K> items, String nextCursor)> fetch(String? offset, int limit);

  Future<void> fetchMore() async {
    if (state.value == null || !state.value!.hasMore) return;

    state = AsyncLoadingNext(state.asData!.value);

    state = await AsyncValue.guard(
      () async {
        final items = await fetch(state.value!.offset, state.value!.limit);
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
        final items = await fetch(state.offset, state.limit);

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

abstract class CursorPaginatedAsyncNotifier<K,
        T extends CursorPaginatedState<K>> extends AsyncNotifier<T>
    with CursorPaginatedAsyncNotifierMixin<K, T>, SpotifyMixin<T> {}

abstract class AutoDisposeCursorPaginatedAsyncNotifier<K,
        T extends CursorPaginatedState<K>> extends AutoDisposeAsyncNotifier<T>
    with CursorPaginatedAsyncNotifierMixin<K, T>, SpotifyMixin<T> {}
