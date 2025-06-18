part of 'metadata.dart';

@freezed
class SpotubeTrackObject with _$SpotubeTrackObject {
  factory SpotubeTrackObject.local({
    required String id,
    required String name,
    required String externalUri,
    @Default([]) List<SpotubeSimpleArtistObject> artists,
    required SpotubeSimpleAlbumObject album,
    required int durationMs,
    required String path,
  }) = SpotubeLocalTrackObject;

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
            : json.containsKey("path")
                ? {...json, "runtimeType": "local"}
                : {...json, "runtimeType": "simple"},
      );
}

extension AsMediaListSpotubeTrackObject on Iterable<SpotubeTrackObject> {
  List<SpotubeMedia> asMediaList() {
    return map((track) => SpotubeMedia(track)).toList();
  }
}

extension ToMetadataSpotubeFullTrackObject on SpotubeFullTrackObject {
  Metadata toMetadata({
    required int fileLength,
    Uint8List? imageBytes,
  }) {
    return Metadata(
      title: name,
      artist: artists.map((a) => a.name).join(", "),
      album: album.name,
      albumArtist: artists.map((a) => a.name).join(", "),
      year: album.releaseDate == null
          ? 1970
          : DateTime.parse(album.releaseDate!).year,
      durationMs: durationMs.toDouble(),
      fileSize: BigInt.from(fileLength),
      picture: imageBytes != null
          ? Picture(
              data: imageBytes,
              // Spotify images are always JPEGs
              mimeType: 'image/jpeg',
            )
          : null,
    );
  }
}
