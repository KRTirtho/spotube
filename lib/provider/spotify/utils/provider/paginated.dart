part of '../../spotify.dart';

mixin PaginatedAsyncNotifierMixin<K, T extends BasePaginatedState<K, int>>
// ignore: invalid_use_of_internal_member
    on AsyncNotifierBase<T> {
  Future<List<K>> fetch(int offset, int limit);

  Future<void> fetchMore() async {
    if (state.value == null || !state.value!.hasMore) return;

    state = AsyncLoadingNext(state.asData!.value);

    state = await AsyncValue.guard(
      () async {
        final items = await fetch(
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

abstract class PaginatedAsyncNotifier<K, T extends BasePaginatedState<K, int>>
    extends AsyncNotifier<T>
    with PaginatedAsyncNotifierMixin<K, T>, SpotifyMixin<T> {}

abstract class AutoDisposePaginatedAsyncNotifier<K,
        T extends BasePaginatedState<K, int>>
    extends AutoDisposeAsyncNotifier<T>
    with PaginatedAsyncNotifierMixin<K, T>, SpotifyMixin<T> {}
