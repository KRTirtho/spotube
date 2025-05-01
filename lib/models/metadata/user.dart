part of 'metadata.dart';

@freezed
class SpotubeUserObject with _$SpotubeUserObject {
  factory SpotubeUserObject({
    required final String uid,
    required final String name,
    @Default([]) final List<SpotubeImageObject> avatars,
    required final String externalUrl,
    required final String displayName,
  }) = _SpotubeUserObject;

  factory SpotubeUserObject.fromJson(Map<String, dynamic> json) =>
      _$SpotubeUserObjectFromJson(json);
}
