part of 'metadata.dart';

@freezed
class SpotubeTrackObject with _$SpotubeTrackObject {
  factory SpotubeTrackObject.full({
    required String id,
    required String name,
    required String externalUri,
    @Default([]) List<SpotubeSimpleArtistObject> artists,
    required SpotubeSimpleAlbumObject album,
    required int durationMs,
    required String isrc,
    required bool explicit,
  }) = SpotubeFullTrackObject;

  factory SpotubeTrackObject.simple({
    required String id,
    required String name,
    required String externalUri,
    required int durationMs,
    required bool explicit,
    @Default([]) List<SpotubeSimpleArtistObject> artists,
    SpotubeSimpleAlbumObject? album,
  }) = SpotubeSimpleTrackObject;

  factory SpotubeTrackObject.fromJson(Map<String, dynamic> json) =>
      _$SpotubeTrackObjectFromJson(
        json.containsKey("isrc")
            ? {...json, "runtimeType": "full"}
            : {...json, "runtimeType": "simple"},
      );
}
