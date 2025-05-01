part of 'metadata.dart';

@freezed
class SpotubePlaylistObject with _$SpotubePlaylistObject {
  factory SpotubePlaylistObject({
    required final String uid,
    required final String name,
    @Default([]) final List<SpotubeImageObject> images,
    required final String description,
    required final String externalUrl,
    required final SpotubeUserObject owner,
    @Default([]) final List<SpotubeUserObject> collaborators,
  }) = _SpotubePlaylistObject;

  factory SpotubePlaylistObject.fromJson(Map<String, dynamic> json) =>
      _$SpotubePlaylistObjectFromJson(json);
}
