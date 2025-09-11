part of 'metadata.dart';

@freezed
class SpotubeFullPlaylistObject with _$SpotubeFullPlaylistObject {
  factory SpotubeFullPlaylistObject({
    required String id,
    required String name,
    required String description,
    required String externalUri,
    required SpotubeUserObject owner,
    @Default([]) List<SpotubeImageObject> images,
    @Default([]) List<SpotubeUserObject> collaborators,
    @Default(false) bool collaborative,
    @Default(false) bool public,
  }) = _SpotubeFullPlaylistObject;

  factory SpotubeFullPlaylistObject.fromJson(Map<String, dynamic> json) =>
      _$SpotubeFullPlaylistObjectFromJson(json);
}

@freezed
class SpotubeSimplePlaylistObject with _$SpotubeSimplePlaylistObject {
  factory SpotubeSimplePlaylistObject({
    required String id,
    required String name,
    required String description,
    required String externalUri,
    required SpotubeUserObject owner,
    @Default([]) List<SpotubeImageObject> images,
  }) = _SpotubeSimplePlaylistObject;

  factory SpotubeSimplePlaylistObject.fromJson(Map<String, dynamic> json) =>
      _$SpotubeSimplePlaylistObjectFromJson(json);
}
