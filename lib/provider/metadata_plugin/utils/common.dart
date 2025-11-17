// ignore: implementation_imports
import 'package:riverpod/src/async_notifier.dart';
import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/models/metadata/metadata.dart';

import 'package:spotube/provider/metadata_plugin/metadata_plugin_provider.dart';
import 'package:spotube/services/metadata/errors/exceptions.dart';
import 'package:spotube/services/metadata/metadata.dart';

extension PaginationExtension<T> on AsyncValue<T> {
  bool get isLoadingNextPage => this is AsyncData && this is AsyncLoadingNext;
}

mixin MetadataPluginMixin<K>
// ignore: invalid_use_of_internal_member
    on AsyncNotifierBase<SpotubePaginationResponseObject<K>> {
  Future<MetadataPlugin> get metadataPlugin async {
    final plugin = await ref.read(metadataPluginProvider.future);

    if (plugin == null) {
      throw MetadataPluginException.noDefaultMetadataPlugin();
    }

    return plugin;
  }
}

extension AutoDisposeAsyncNotifierCacheFor
// ignore: deprecated_member_use
    on AutoDisposeAsyncNotifierProviderRef {
  // When invoked keeps your provider alive for [duration]
  // ignore: unused_element
  void cacheFor([Duration duration = const Duration(minutes: 5)]) {
    final link = keepAlive();
    final timer = Timer(duration, () => link.close());
    onDispose(() => timer.cancel());
  }
}

// ignore: deprecated_member_use
extension AutoDisposeCacheFor on AutoDisposeRef {
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
