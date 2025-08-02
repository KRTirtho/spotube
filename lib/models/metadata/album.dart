part of 'metadata.dart';

enum SpotubeAlbumType {
  album,
  single,
  compilation,
}

@freezed
class SpotubeFullAlbumObject with _$SpotubeFullAlbumObject {
  factory SpotubeFullAlbumObject({
    required String id,
    required String name,
    required List<SpotubeSimpleArtistObject> artists,
    @Default([]) List<SpotubeImageObject> images,
    required String releaseDate,
    required String externalUri,
    required int totalTracks,
    required SpotubeAlbumType albumType,
    String? recordLabel,
    List<String>? genres,
  }) = _SpotubeFullAlbumObject;

  factory SpotubeFullAlbumObject.fromJson(Map<String, dynamic> json) =>
      _$SpotubeFullAlbumObjectFromJson(json);
}

@freezed
class SpotubeSimpleAlbumObject with _$SpotubeSimpleAlbumObject {
  factory SpotubeSimpleAlbumObject({
    required String id,
    required String name,
    required String externalUri,
    required List<SpotubeSimpleArtistObject> artists,
    @Default([]) List<SpotubeImageObject> images,
    required SpotubeAlbumType albumType,
    String? releaseDate,
  }) = _SpotubeSimpleAlbumObject;

  factory SpotubeSimpleAlbumObject.fromJson(Map<String, dynamic> json) =>
      _$SpotubeSimpleAlbumObjectFromJson(json);
}
