part of 'metadata.dart';

enum SpotubeAlbumType {
  album,
  single,
}

@freezed
class SpotubeAlbumObject with _$SpotubeAlbumObject {
  factory SpotubeAlbumObject({
    required final String uid,
    required final String title,
    required final SpotubeArtistObject artist,
    @Default([]) final List<SpotubeImageObject> images,
    required final String releaseDate,
    required final String externalUrl,
    required final SpotubeAlbumType type,
  }) = _SpotubeAlbumObject;

  factory SpotubeAlbumObject.fromJson(Map<String, dynamic> json) =>
      _$SpotubeAlbumObjectFromJson(json);
}
