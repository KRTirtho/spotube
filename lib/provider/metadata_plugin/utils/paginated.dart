import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/models/metadata/metadata.dart';
// ignore: implementation_imports
import 'package:riverpod/src/async_notifier.dart';
import 'package:spotube/provider/metadata_plugin/metadata_plugin_provider.dart';
import 'package:spotube/services/metadata/metadata.dart';

mixin MetadataPluginMixin<K>
// ignore: invalid_use_of_internal_member
    on AsyncNotifierBase<SpotubePaginationResponseObject<K>> {
  Future<MetadataPlugin?> get metadataPlugin async =>
      await ref.read(metadataPluginProvider.future);
}

// ignore: deprecated_member_use
extension on AutoDisposeAsyncNotifierProviderRef {
  // When invoked keeps your provider alive for [duration]
  // ignore: unused_element
  void cacheFor([Duration duration = const Duration(minutes: 5)]) {
    final link = keepAlive();
    final timer = Timer(duration, () => link.close());
    onDispose(() => timer.cancel());
  }
}

// ignore: deprecated_member_use
extension on AutoDisposeRef {
  // When invoked keeps your provider alive for [duration]
  // ignore: unused_element
  void cacheFor([Duration duration = const Duration(minutes: 5)]) {
    final link = keepAlive();
    final timer = Timer(duration, () => link.close());
    onDispose(() => timer.cancel());
  }
}

// ignore: subtype_of_sealed_class
class AsyncLoadingNext<T> extends AsyncData<T> {
  const AsyncLoadingNext(super.value);
}

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
