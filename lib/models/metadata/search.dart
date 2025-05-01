part of 'metadata.dart';

@freezed
class SpotubeSearchResponseObject with _$SpotubeSearchResponseObject {
  factory SpotubeSearchResponseObject({
    @Default([]) final List<SpotubeTrackObject> tracks,
    @Default([]) final List<SpotubeAlbumObject> albums,
    @Default([]) final List<SpotubeArtistObject> artists,
    @Default([]) final List<SpotubePlaylistObject> playlists,
  }) = _SpotubeSearchResponseObject;

  factory SpotubeSearchResponseObject.fromJson(Map<String, dynamic> json) =>
      _$SpotubeSearchResponseObjectFromJson(json);
}
