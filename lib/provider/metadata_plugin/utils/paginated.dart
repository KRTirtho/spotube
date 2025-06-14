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
        return newState.copyWith(items: [
          ...state.value!.items as List<K>,
          ...newState.items as List<K>,
        ]) as SpotubePaginationResponseObject<K>;
      },
    );
  }

  Future<List<K>> fetchAll() async {
    if (state.value == null) return [];
    if (!state.value!.hasMore) return state.value!.items as List<K>;

    bool hasMore = true;
    while (hasMore) {
      await update((state) async {
        final newState = await fetch(
          state.nextOffset!,
          state.limit,
        );

        hasMore = newState.hasMore;
        return newState.copyWith(items: [
          ...state.items as List<K>,
          ...newState.items as List<K>,
        ]) as SpotubePaginationResponseObject<K>;
      });
    }

    return state.value!.items as List<K>;
  }
}

abstract class PaginatedAsyncNotifier<K>
    extends AsyncNotifier<SpotubePaginationResponseObject<K>>
    with PaginatedAsyncNotifierMixin<K>, MetadataPluginMixin<K> {}

abstract class AutoDisposePaginatedAsyncNotifier<K>
    extends AutoDisposeAsyncNotifier<SpotubePaginationResponseObject<K>>
    with PaginatedAsyncNotifierMixin<K>, MetadataPluginMixin<K> {}
