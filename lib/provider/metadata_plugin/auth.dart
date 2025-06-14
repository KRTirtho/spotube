import 'dart:async';

import 'package:riverpod/riverpod.dart';
import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/provider/metadata_plugin/metadata_plugin_provider.dart';

class MetadataPluginAuthenticatedNotifier extends AsyncNotifier<bool> {
  @override
  FutureOr<bool> build() async {
    final defaultPluginConfig = ref.watch(metadataPluginsProvider);
    if (defaultPluginConfig.asData?.value.defaultPluginConfig?.abilities
            .contains(PluginAbilities.authentication) !=
        true) {
      return false;
    }

    final defaultPlugin = await ref.watch(metadataPluginProvider.future);
    if (defaultPlugin == null) {
      return false;
    }

    final sub = defaultPlugin.auth.authStateStream.listen((event) {
      state = AsyncData(defaultPlugin.auth.isAuthenticated());
    });

    ref.onDispose(() {
      sub.cancel();
    });

    return defaultPlugin.auth.isAuthenticated();
  }
}

final metadataPluginAuthenticatedProvider =
    AsyncNotifierProvider<MetadataPluginAuthenticatedNotifier, bool>(
  MetadataPluginAuthenticatedNotifier.new,
);
