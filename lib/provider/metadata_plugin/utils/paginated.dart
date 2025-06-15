import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/models/metadata/metadata.dart';
// ignore: implementation_imports
import 'package:riverpod/src/async_notifier.dart';
import 'package:spotube/provider/metadata_plugin/utils/common.dart';

mixin PaginatedAsyncNotifierMixin<K>
    // ignore: invalid_use_of_internal_member
    on AsyncNotifierBase<SpotubePaginationResponseObject<K>> {
  Future<SpotubePaginationResponseObject<K>> fetch(int offset, int limit);

  Future<void> fetchMore() async {
    if (state.value == null || !state.value!.hasMore) return;

    state = AsyncLoadingNext(state.asData!.value);

    state = await AsyncValue.guard(
      () async {
        final newState = await fetch(
          state.value!.nextOffset!,
          state.value!.limit,
        );

        final oldItems =
            state.value!.items.isEmpty ? <K>[] : state.value!.items.cast<K>();
        final items = newState.items.isEmpty ? <K>[] : newState.items.cast<K>();

        return newState.copyWith(items: <K>[...oldItems, ...items])
            as SpotubePaginationResponseObject<K>;
      },
    );
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
        return newState.copyWith(items: <K>[...oldItems, ...items])
            as SpotubePaginationResponseObject<K>;
      });
    }

    return state.value!.items.cast<K>();
  }
}

abstract class PaginatedAsyncNotifier<K>
    extends AsyncNotifier<SpotubePaginationResponseObject<K>>
    with PaginatedAsyncNotifierMixin<K>, MetadataPluginMixin<K> {}

abstract class AutoDisposePaginatedAsyncNotifier<K>
    extends AutoDisposeAsyncNotifier<SpotubePaginationResponseObject<K>>
    with PaginatedAsyncNotifierMixin<K>, MetadataPluginMixin<K> {}
