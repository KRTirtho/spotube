part of '../spotify.dart';

abstract class PaginatedAsyncNotifier<K, T extends PaginatedState<K>>
    extends AsyncNotifier<T> with SpotifyMixin<T> {
  Future<List<K>> fetch(int offset, int limit);

  Future<void> fetchMore() async {
    if (state.value == null || !state.value!.hasMore) return;

    await update(
      (state) async {
        final items = await fetch(state.offset + state.limit, state.limit);
        return state.copyWith(
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

abstract class FamilyPaginatedAsyncNotifier<K, T extends PaginatedState<K>, A>
    extends FamilyAsyncNotifier<T, A> with SpotifyMixin<T> {
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
