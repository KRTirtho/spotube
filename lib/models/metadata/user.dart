part of 'metadata.dart';

@freezed
class SpotubeUserObject with _$SpotubeUserObject {
  factory SpotubeUserObject({
    required final String id,
    required final String name,
    @Default([]) final List<SpotubeImageObject> images,
    required final String externalUri,
  }) = _SpotubeUserObject;

  factory SpotubeUserObject.fromJson(Map<String, dynamic> json) =>
      _$SpotubeUserObjectFromJson(json);
}
