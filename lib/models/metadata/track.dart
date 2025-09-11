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

  factory SpotubeTrackObject.localTrackFromFile(
    File file, {
    Metadata? metadata,
    String? art,
  }) {
    return SpotubeLocalTrackObject(
      id: file.absolute.path,
      name: metadata?.title ?? basenameWithoutExtension(file.path),
      externalUri: "file://${file.absolute.path}",
      artists: metadata?.artist?.split(",").map((a) {
            return SpotubeSimpleArtistObject(
              id: a.trim(),
              name: a.trim(),
              externalUri: "file://${file.absolute.path}",
            );
          }).toList() ??
          [
            SpotubeSimpleArtistObject(
              id: "unknown",
              name: "Unknown Artist",
              externalUri: "file://${file.absolute.path}",
            ),
          ],
      album: SpotubeSimpleAlbumObject(
        albumType: SpotubeAlbumType.album,
        id: metadata?.album ?? "unknown",
        name: metadata?.album ?? "Unknown Album",
        externalUri: "file://${file.absolute.path}",
        artists: [
          SpotubeSimpleArtistObject(
            id: metadata?.albumArtist ?? "unknown",
            name: metadata?.albumArtist ?? "Unknown Artist",
            externalUri: "file://${file.absolute.path}",
          ),
        ],
        releaseDate:
            metadata?.year != null ? "${metadata!.year}-01-01" : "1970-01-01",
        images: [
          if (art != null)
            SpotubeImageObject(
              url: art,
              width: 300,
              height: 300,
            ),
        ],
      ),
      durationMs: metadata?.durationMs?.toInt() ?? 0,
      path: file.path,
    );
  }

  factory SpotubeTrackObject.fromJson(Map<String, dynamic> json) =>
      _$SpotubeTrackObjectFromJson(
        json.containsKey("path")
            ? {...json, "runtimeType": "local"}
            : {...json, "runtimeType": "full"},
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
    String? mimeType,
  }) {
    return Metadata(
      title: name,
      artist: artists.map((a) => a.name).join(", "),
      album: album.name,
      albumArtist: artists.map((a) => a.name).join(", "),
      year: album.releaseDate == null
          ? 1970
          : DateTime.tryParse(album.releaseDate!)?.year ??
              int.tryParse(album.releaseDate!) ??
              1970,
      durationMs: durationMs.toDouble(),
      fileSize: BigInt.from(fileLength),
      picture: imageBytes != null
          ? Picture(
              data: imageBytes,
              mimeType: mimeType ??
                  lookupMimeType("", headerBytes: imageBytes) ??
                  "image/jpeg",
            )
          : null,
    );
  }
}
