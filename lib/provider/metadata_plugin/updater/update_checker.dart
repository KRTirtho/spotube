import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/provider/metadata_plugin/metadata_plugin_provider.dart';

final metadataPluginUpdateCheckerProvider =
    FutureProvider<PluginUpdateAvailable?>((ref) async {
  final metadataPluginConfigs = await ref.watch(metadataPluginsProvider.future);
  final metadataPlugin = await ref.watch(metadataPluginProvider.future);

  if (metadataPlugin == null ||
      metadataPluginConfigs.defaultPluginConfig == null) {
    return null;
  }

  return metadataPlugin.updater
      .check(metadataPluginConfigs.defaultPluginConfig!);
});
