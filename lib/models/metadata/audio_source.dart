part of 'metadata.dart';

enum SpotubeMediaCompressionType {
  lossy,
  lossless,
}

@Freezed(unionKey: 'type')
class SpotubeAudioSourceContainerPreset
    with _$SpotubeAudioSourceContainerPreset {
  @FreezedUnionValue("lossy")
  factory SpotubeAudioSourceContainerPreset.lossy({
    required SpotubeMediaCompressionType type,
    required String name,
    required List<SpotubeAudioLossyContainerQuality> qualities,
  }) = SpotubeAudioSourceContainerPresetLossy;

  @FreezedUnionValue("lossless")
  factory SpotubeAudioSourceContainerPreset.lossless({
    required SpotubeMediaCompressionType type,
    required String name,
    required List<SpotubeAudioLosslessContainerQuality> qualities,
  }) = SpotubeAudioSourceContainerPresetLossless;

  factory SpotubeAudioSourceContainerPreset.fromJson(
          Map<String, dynamic> json) =>
      _$SpotubeAudioSourceContainerPresetFromJson(json);
}

@freezed
class SpotubeAudioLossyContainerQuality
    with _$SpotubeAudioLossyContainerQuality {
  factory SpotubeAudioLossyContainerQuality({
    required double bitrate,
  }) = _SpotubeAudioLossyContainerQuality;

  factory SpotubeAudioLossyContainerQuality.fromJson(
          Map<String, dynamic> json) =>
      _$SpotubeAudioLossyContainerQualityFromJson(json);
}

@freezed
class SpotubeAudioLosslessContainerQuality
    with _$SpotubeAudioLosslessContainerQuality {
  factory SpotubeAudioLosslessContainerQuality({
    required int bitDepth,
    required double sampleRate,
  }) = _SpotubeAudioLosslessContainerQuality;

  factory SpotubeAudioLosslessContainerQuality.fromJson(
          Map<String, dynamic> json) =>
      _$SpotubeAudioLosslessContainerQualityFromJson(json);
}

@freezed
class SpotubeAudioSourceMatchObject with _$SpotubeAudioSourceMatchObject {
  factory SpotubeAudioSourceMatchObject({
    required String id,
    required String title,
    required List<String> artists,
    required Duration duration,
    String? thumbnail,
    required String externalUri,
  }) = _SpotubeAudioSourceMatchObject;

  factory SpotubeAudioSourceMatchObject.fromJson(Map<String, dynamic> json) =>
      _$SpotubeAudioSourceMatchObjectFromJson(json);
}

@freezed
class SpotubeAudioSourceStreamObject with _$SpotubeAudioSourceStreamObject {
  factory SpotubeAudioSourceStreamObject({
    required String url,
    required String container,
    required SpotubeMediaCompressionType type,
    String? codec,
    double? bitrate,
    int? bitDepth,
    double? sampleRate,
  }) = _SpotubeAudioSourceStreamObject;

  factory SpotubeAudioSourceStreamObject.fromJson(Map<String, dynamic> json) =>
      _$SpotubeAudioSourceStreamObjectFromJson(json);
}
