import 'package:hetu_script/hetu_script.dart';
import 'package:hetu_script/values.dart';
import 'package:spotube/models/metadata/metadata.dart';

class MetadataPluginAudioSourceEndpoint {
  final Hetu hetu;
  MetadataPluginAudioSourceEndpoint(this.hetu);

  HTInstance get hetuMetadataAudioSource =>
      (hetu.fetch("metadataPlugin") as HTInstance).memberGet("audioSource")
          as HTInstance;

  List<SpotubeAudioSourceContainerPreset> get supportedPresets {
    final raw = hetuMetadataAudioSource.memberGet("supportedPresets") as List;

    return raw
        .map((e) => SpotubeAudioSourceContainerPreset.fromJson(e))
        .toList();
  }

  Future<List<SpotubeAudioSourceMatchObject>> matches(
    SpotubeFullTrackObject track,
  ) async {
    final raw = await hetuMetadataAudioSource
        .invoke("matches", positionalArgs: [track.toJson()]) as List;

    return raw.map((e) => SpotubeAudioSourceMatchObject.fromJson(e)).toList();
  }

  Future<List<SpotubeAudioSourceStreamObject>> streams(
    SpotubeAudioSourceMatchObject match,
  ) async {
    final raw = await hetuMetadataAudioSource
        .invoke("streams", positionalArgs: [match.toJson()]) as List;

    return raw.map((e) => SpotubeAudioSourceStreamObject.fromJson(e)).toList();
  }
}
