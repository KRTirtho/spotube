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

  Future<String> get support async {
    final result = await hetuMetadataPluginUpdater.memberGet("support");

    return result as String;
  }

  /// [details] is a map containing the scrobble information, such as:
  /// - [id] -> The unique identifier of the track.
  /// - [title] -> The title of the track.
  /// - [artists] -> List of artists
  ///   - [id] -> The unique identifier of the artist.
  ///   - [name] -> The name of the artist.
  /// - [album] -> The album of the track
  ///   - [id] -> The unique identifier of the album.
  ///   - [name] -> The name of the album.
  /// - [timestamp] -> The timestamp of the scrobble (optional).
  /// - [duration_ms] -> The duration of the track in milliseconds (optional).
  /// - [isrc] -> The ISRC code of the track (optional).
  Future<void> scrobble(Map<String, dynamic> details) {
    return hetuMetadataPluginUpdater.invoke(
      "scrobble",
      positionalArgs: [details],
    );
  }
}
