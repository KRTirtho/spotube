import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/provider/metadata_plugin/utils/common.dart';

abstract class FamilyPaginatedAsyncNotifier<K, A>
    extends FamilyAsyncNotifier<SpotubePaginationResponseObject<K>, A>
    with MetadataPluginMixin<K> {
  Future<SpotubePaginationResponseObject<K>> fetch(int offset, int limit);

  Future<void> fetchMore() async {
    if (state.value == null || !state.value!.hasMore) return;

    final oldState = state.value;

    try {
      state = AsyncLoadingNext(state.asData!.value);

      final newState = await fetch(
        state.value!.nextOffset!,
        state.value!.limit,
      );

      final oldItems =
          state.value!.items.isEmpty ? <K>[] : state.value!.items.cast<K>();
      final items = newState.items.isEmpty ? <K>[] : newState.items.cast<K>();

      state = AsyncData(newState.copyWith(items: <K>[...oldItems, ...items]));
    } finally {
      state = AsyncData(oldState!);
    }
  }

  Future<List<K>> fetchAll() async {
    if (state.value == null) return [];
    if (!state.value!.hasMore) return state.value!.items.cast<K>();

    bool hasMore = true;
    while (hasMore) {
      await update((state) async {
        final newState = await fetch(
          state.nextOffset!,
          state.limit,
        );

        hasMore = newState.hasMore;
        final oldItems = state.items.isEmpty ? <K>[] : state.items.cast<K>();
        final items = newState.items.isEmpty ? <K>[] : newState.items.cast<K>();
        return newState.copyWith(items: <K>[...oldItems, ...items]);
      });
    }

    return state.value!.items.cast<K>();
  }
}

abstract class AutoDisposeFamilyPaginatedAsyncNotifier<K, A>
    extends AutoDisposeFamilyAsyncNotifier<SpotubePaginationResponseObject<K>,
        A> with MetadataPluginMixin<K> {
  Future<SpotubePaginationResponseObject<K>> fetch(int offset, int limit);

  Future<void> fetchMore() async {
    if (state.value == null || !state.value!.hasMore) return;
    final oldState = state.value;

    try {
      state = AsyncLoadingNext(state.value!);

      final newState = await fetch(
        state.value!.nextOffset!,
        state.value!.limit,
      );

      state = AsyncData(
        newState.copyWith(items: [
          ...state.value!.items.cast<K>(),
          ...newState.items.cast<K>(),
        ]),
      );
    } finally {
      state = AsyncData(oldState!);
    }
  }

  Future<List<K>> fetchAll() async {
    if (state.value == null) return [];
    if (!state.value!.hasMore) return state.value!.items.cast<K>();

    bool hasMore = true;
    while (hasMore) {
      await update((state) async {
        final newState = await fetch(
          state.nextOffset!,
          state.limit,
        );

        hasMore = newState.hasMore;
        return newState.copyWith(items: [
          ...state.items.cast<K>(),
          ...newState.items.cast<K>(),
        ]);
      });
    }

    return state.value!.items.cast<K>();
  }
}
