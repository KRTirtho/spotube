part of 'metadata.dart';

@freezed
class SpotubeFullTrackObject with _$SpotubeFullTrackObject {
  factory SpotubeFullTrackObject({
    required String id,
    required String name,
    required String externalUri,
    @Default([]) List<SpotubeSimpleArtistObject> artists,
    required SpotubeSimpleAlbumObject album,
    required int durationMs,
    required String isrc,
    required bool explicit,
  }) = _SpotubeFullTrackObject;

  factory SpotubeFullTrackObject.fromJson(Map<String, dynamic> json) =>
      _$SpotubeFullTrackObjectFromJson(json);
}

@freezed
class SpotubeSimpleTrackObject with _$SpotubeSimpleTrackObject {
  factory SpotubeSimpleTrackObject({
    required String id,
    required String name,
    required String externalUri,
    required int durationMs,
    required bool explicit,
    @Default([]) List<SpotubeSimpleArtistObject> artists,
    SpotubeSimpleAlbumObject? album,
  }) = _SpotubeSimpleTrackObject;

  factory SpotubeSimpleTrackObject.fromJson(Map<String, dynamic> json) =>
      _$SpotubeSimpleTrackObjectFromJson(json);
}
