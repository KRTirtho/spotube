part of '../spotify.dart';

abstract class PaginatedAsyncNotifier<K, T extends BasePaginatedState<K, int>>
    extends AsyncNotifier<T> with SpotifyMixin<T> {
  Future<List<K>> fetch(int offset, int limit);

  Future<void> fetchMore() async {
    if (state.value == null || !state.value!.hasMore) return;
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(
      () async {
        final items = await fetch(
            state.value!.offset + state.value!.limit, state.value!.limit);
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
}

abstract class CursorPaginatedAsyncNotifier<K,
        T extends CursorPaginatedState<K>> extends AsyncNotifier<T>
    with SpotifyMixin<T> {
  Future<(List<K> items, String nextCursor)> fetch(String? offset, int limit);

  Future<void> fetchMore() async {
    if (state.value == null || !state.value!.hasMore) return;

    state = const AsyncValue.loading();

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
}

abstract class FamilyPaginatedAsyncNotifier<
    K,
    T extends BasePaginatedState<K, dynamic>,
    A> extends FamilyAsyncNotifier<T, A> with SpotifyMixin<T> {
  Future<List<K>> fetch(A arg, int offset, int limit);

  Future<void> fetchMore() async {
    if (state.value == null || !state.value!.hasMore) return;

    state = const AsyncLoading();

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
}

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

    state = const AsyncLoading();

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
}
