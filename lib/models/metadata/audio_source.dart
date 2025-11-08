part of 'metadata.dart';

final oneOptionalDecimalFormatter = NumberFormat('0.#', 'en_US');

enum SpotubeMediaCompressionType {
  lossy,
  lossless,
}

@Freezed(unionKey: 'type')
class SpotubeAudioSourceContainerPreset
    with _$SpotubeAudioSourceContainerPreset {
  const SpotubeAudioSourceContainerPreset._();

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

  String getFileExtension() {
    return switch (name) {
      "mp4" => "m4a",
      "webm" => "weba",
      _ => name,
    };
  }
}

@freezed
class SpotubeAudioLossyContainerQuality
    with _$SpotubeAudioLossyContainerQuality {
  const SpotubeAudioLossyContainerQuality._();

  factory SpotubeAudioLossyContainerQuality({
    required int bitrate, // bits per second
  }) = _SpotubeAudioLossyContainerQuality;

  factory SpotubeAudioLossyContainerQuality.fromJson(
          Map<String, dynamic> json) =>
      _$SpotubeAudioLossyContainerQualityFromJson(json);

  @override
  toString() {
    return "${oneOptionalDecimalFormatter.format(bitrate / 1000)}kbps";
  }
}

@freezed
class SpotubeAudioLosslessContainerQuality
    with _$SpotubeAudioLosslessContainerQuality {
  const SpotubeAudioLosslessContainerQuality._();

  factory SpotubeAudioLosslessContainerQuality({
    required int bitDepth, // bit
    required int sampleRate, // hz
  }) = _SpotubeAudioLosslessContainerQuality;

  factory SpotubeAudioLosslessContainerQuality.fromJson(
          Map<String, dynamic> json) =>
      _$SpotubeAudioLosslessContainerQualityFromJson(json);

  @override
  toString() {
    return "${bitDepth}bit • ${oneOptionalDecimalFormatter.format(sampleRate / 1000)}kHz";
  }
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
