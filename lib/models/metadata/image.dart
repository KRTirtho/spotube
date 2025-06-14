part of 'metadata.dart';

@freezed
class SpotubeImageObject with _$SpotubeImageObject {
  factory SpotubeImageObject({
    required String url,
    int? width,
    int? height,
  }) = _SpotubeImageObject;

  factory SpotubeImageObject.fromJson(Map<String, dynamic> json) =>
      _$SpotubeImageObjectFromJson(json);
}
