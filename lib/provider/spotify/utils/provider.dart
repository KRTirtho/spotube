part of '../spotify.dart';

abstract class PaginatedAsyncNotifier<K, T extends BasePaginatedState<K, int>>
    extends AsyncNotifier<T> with SpotifyMixin<T> {
  Future<List<K>> fetch(int offset, int limit);

  Future<void> fetchMore() async {
    if (state.value == null || !state.value!.hasMore) return;

    await update(
      (state) async {
        final items = await fetch(state.offset + state.limit, state.limit);
        return state.copyWith(
          hasMore: items.length == state.limit,
          items: [
            ...state.items,
            ...items,
          ],
          offset: state.offset + state.limit,
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

    await update(
      (state) async {
        final items = await fetch(state.offset, state.limit);
        return state.copyWith(
          hasMore: items.$1.length == state.limit,
          items: [
            ...state.items,
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

    await update(
      (state) async {
        final items = await fetch(
          arg,
          state.offset + state.limit,
          state.limit,
        );
        return state.copyWith(
          hasMore: items.length == state.limit,
          items: [
            ...state.items,
            ...items,
          ],
          offset: state.offset + state.limit,
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

    await update(
      (state) async {
        final items = await fetch(
          arg,
          state.offset,
          state.limit,
        );
        return state.copyWith(
          hasMore: items.$1.length == state.limit,
          items: [
            ...state.items,
            ...items.$1,
          ],
          offset: items.$2,
        ) as T;
      },
    );
  }
}
