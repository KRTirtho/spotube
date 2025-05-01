part of 'metadata.dart';

@freezed
class SpotubeArtistObject with _$SpotubeArtistObject {
  factory SpotubeArtistObject({
    required final String uid,
    required final String name,
    @Default([]) final List<SpotubeImageObject> images,
    required final String externalUrl,
  }) = _SpotubeArtistObject;

  factory SpotubeArtistObject.fromJson(Map<String, dynamic> json) =>
      _$SpotubeArtistObjectFromJson(json);
}
