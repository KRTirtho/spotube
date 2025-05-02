part of 'metadata.dart';

@freezed
class SpotubeFeedObject with _$SpotubeFeedObject {
  factory SpotubeFeedObject({
    required final String uid,
    required final String name,
    required final String externalUrl,
    @Default([]) final List<SpotubeImageObject> images,
  }) = _SpotubeFeedObject;

  factory SpotubeFeedObject.fromJson(Map<String, dynamic> json) =>
      _$SpotubeFeedObjectFromJson(json);
}
