import 'package:hetu_script/hetu_script.dart';
import 'package:hetu_script/values.dart';
import 'package:spotube/models/metadata/metadata.dart';

class MetadataPluginUpdaterEndpoint {
  final Hetu hetu;

  MetadataPluginUpdaterEndpoint(this.hetu);

  HTInstance get hetuMetadataPluginUpdater =>
      (hetu.fetch("metadataPlugin") as HTInstance).memberGet("updater")
          as HTInstance;

  Future<PluginUpdateAvailable?> check(PluginConfiguration pluginConfig) async {
    final result = await hetuMetadataPluginUpdater.invoke(
      "check",
      positionalArgs: [pluginConfig.toJson()],
    );

    return result == null
        ? null
        : PluginUpdateAvailable.fromJson(
            (result as Map).cast<String, dynamic>(),
          );
  }
}
