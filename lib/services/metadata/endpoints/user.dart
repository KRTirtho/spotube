import 'package:hetu_script/hetu_script.dart';
import 'package:spotube/models/metadata/metadata.dart';

class MetadataPluginUserEndpoint {
  final Hetu hetu;
  MetadataPluginUserEndpoint(this.hetu);

  Future<SpotubeUserObject> me() async {
    final raw = await hetu.eval("metadataPlugin.user.me()") as Map;

    return SpotubeUserObject.fromJson(
      raw.cast<String, dynamic>(),
    );
  }
}
