part of 'metadata.dart';

@freezed
class SpotubeImageObject with _$SpotubeImageObject {
  factory SpotubeImageObject({
    required final String url,
    required final int width,
    required final int height,
  }) = _SpotubeImageObject;

  factory SpotubeImageObject.fromJson(Map<String, dynamic> json) =>
      _$SpotubeImageObjectFromJson(json);
}
