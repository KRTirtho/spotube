import 'package:hetu_script/hetu_script.dart';
import 'package:hetu_script/values.dart';
import 'package:spotube/models/metadata/metadata.dart';

class MetadataPluginCore {
  final Hetu hetu;

  MetadataPluginCore(this.hetu);

  HTInstance get hetuMetadataPluginUpdater =>
      (hetu.fetch("metadataPlugin") as HTInstance).memberGet("core")
          as HTInstance;

  Future<PluginUpdateAvailable?> checkUpdate(
    PluginConfiguration pluginConfig,
  ) async {
    final result = await hetuMetadataPluginUpdater.invoke(
      "checkUpdate",
      positionalArgs: [pluginConfig.toJson()],
    );

    return result == null
        ? null
        : PluginUpdateAvailable.fromJson(
            (result as Map).cast<String, dynamic>(),
          );
  }
}
