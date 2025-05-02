part of 'metadata.dart';

SpotubePaginationResponseObject<SpotubeTrackObject> _paginationTracksFromJson(
  Map<String, dynamic> json,
) {
  return SpotubePaginationResponseObject<SpotubeTrackObject>.fromJson(
    json,
    (json) => SpotubeTrackObject.fromJson(json),
  );
}

SpotubePaginationResponseObject<SpotubeAlbumObject> _paginationAlbumsFromJson(
  Map<String, dynamic> json,
) {
  return SpotubePaginationResponseObject<SpotubeAlbumObject>.fromJson(
    json,
    (json) => SpotubeAlbumObject.fromJson(json),
  );
}

SpotubePaginationResponseObject<SpotubeArtistObject> _paginationArtistsFromJson(
  Map<String, dynamic> json,
) {
  return SpotubePaginationResponseObject<SpotubeArtistObject>.fromJson(
    json,
    (json) => SpotubeArtistObject.fromJson(json),
  );
}

SpotubePaginationResponseObject<SpotubePlaylistObject>
    _paginationPlaylistsFromJson(
  Map<String, dynamic> json,
) {
  return SpotubePaginationResponseObject<SpotubePlaylistObject>.fromJson(
    json,
    (json) => SpotubePlaylistObject.fromJson(json),
  );
}

Map<String, dynamic>? _paginationToJson(
  SpotubePaginationResponseObject? instance,
) {
  return instance?.toJson((item) => item.toJson());
}

@freezed
class SpotubeSearchResponseObject with _$SpotubeSearchResponseObject {
  factory SpotubeSearchResponseObject({
    @JsonKey(
      fromJson: _paginationTracksFromJson,
      toJson: _paginationToJson,
    )
    final SpotubePaginationResponseObject<SpotubeTrackObject>? tracks,
    @JsonKey(
      fromJson: _paginationAlbumsFromJson,
      toJson: _paginationToJson,
    )
    final SpotubePaginationResponseObject<SpotubeAlbumObject>? albums,
    @JsonKey(
      fromJson: _paginationArtistsFromJson,
      toJson: _paginationToJson,
    )
    final SpotubePaginationResponseObject<SpotubeArtistObject>? artists,
    @JsonKey(
      fromJson: _paginationPlaylistsFromJson,
      toJson: _paginationToJson,
    )
    final SpotubePaginationResponseObject<SpotubePlaylistObject>? playlists,
  }) = _SpotubeSearchResponseObject;

  factory SpotubeSearchResponseObject.fromJson(Map<String, dynamic> json) =>
      _$SpotubeSearchResponseObjectFromJson(json);
}
