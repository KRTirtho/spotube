part of 'metadata.dart';

enum SectionItemType {
  @JsonValue("Playlist")
  playlist,
  @JsonValue("Album")
  album,
  @JsonValue("Artist")
  artist
}

@Freezed(unionKey: "itemType")
class SpotubeBrowseSectionObject with _$SpotubeBrowseSectionObject {
  @FreezedUnionValue("Album")
  factory SpotubeBrowseSectionObject.album({
    required String id,
    required String title,
    required String externalUri,
    required SectionItemType itemType,
    required List<SpotubeSimpleAlbumObject> items,
  }) = SpotubeBrowseAlbumSectionObject;

  @FreezedUnionValue("Artist")
  factory SpotubeBrowseSectionObject.artist({
    required String id,
    required String title,
    required String externalUri,
    required SectionItemType itemType,
    required List<SpotubeSimpleArtistObject> items,
  }) = SpotubeBrowseArtistSectionObject;

  @FreezedUnionValue("Playlist")
  factory SpotubeBrowseSectionObject.playlist({
    required String id,
    required String title,
    required String externalUri,
    required SectionItemType itemType,
    required List<SpotubeSimplePlaylistObject> items,
  }) = SpotubeBrowsePlaylistSectionObject;

  factory SpotubeBrowseSectionObject.fromJson(Map<String, Object?> json) =>
      _$SpotubeBrowseSectionObjectFromJson(json);
}
