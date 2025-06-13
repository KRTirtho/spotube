import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/provider/metadata_plugin/metadata_plugin_provider.dart';

class MetadataAuthenticationNotifier extends AsyncNotifier<bool> {
  MetadataAuthenticationNotifier();
  @override
  build() async {
    final metadataApi = await ref.watch(metadataPluginApiProvider.future);

    if (metadataApi?.signatureFlags.requiresAuth != true) {
      return false;
    }

    final subscription = metadataApi?.authenticatedStream.listen((event) {
      state = AsyncValue.data(event);
    });

    ref.onDispose(() {
      subscription?.cancel();
    });

    return await metadataApi?.isAuthenticated() ?? false;
  }

  Future<void> login() async {
    final metadataApi = await ref.read(metadataPluginApiProvider.future);

    if (metadataApi == null || !metadataApi.signatureFlags.requiresAuth) {
      return;
    }

    await metadataApi.authenticate();
  }

  Future<void> logout() async {
    final metadataApi = await ref.read(metadataPluginApiProvider.future);

    if (metadataApi == null || !metadataApi.signatureFlags.requiresAuth) {
      return;
    }

    await metadataApi.logout();
  }
}

final metadataAuthenticatedProvider =
    AsyncNotifierProvider<MetadataAuthenticationNotifier, bool>(
  () => MetadataAuthenticationNotifier(),
);
