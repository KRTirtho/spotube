part of 'metadata.dart';

@freezed
class SpotubeSearchResponseObject with _$SpotubeSearchResponseObject {
  factory SpotubeSearchResponseObject({
    required List<SpotubeSimpleAlbumObject> albums,
    required List<SpotubeFullArtistObject> artists,
    required List<SpotubeSimplePlaylistObject> playlists,
    required List<SpotubeFullTrackObject> tracks,
  }) = _SpotubeSearchResponseObject;

  factory SpotubeSearchResponseObject.fromJson(Map<String, dynamic> json) =>
      _$SpotubeSearchResponseObjectFromJson(json);
}
