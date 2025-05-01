part of 'metadata.dart';

@freezed
class SpotubeTrackObject with _$SpotubeTrackObject {
  factory SpotubeTrackObject({
    required final String uid,
    required final String title,
    @Default([]) final List<SpotubeArtistObject> artists,
    required final SpotubeAlbumObject album,
    required final int durationMs,
    required final String isrc,
    required final String externalUrl,
  }) = _SpotubeTrackObject;

  factory SpotubeTrackObject.fromJson(Map<String, dynamic> json) =>
      _$SpotubeTrackObjectFromJson(json);
}
