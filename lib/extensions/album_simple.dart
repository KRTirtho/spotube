import 'package:spotify/spotify.dart';

extension AlbumExtensions on AlbumSimple {
  Map<String, dynamic> toJson() {
    return {
      "albumType": albumType?.name,
      "id": id,
      "name": name,
      "images": images
          ?.map((image) => {
                "height": image.height,
                "url": image.url,
                "width": image.width,
              })
          .toList(),
    };
  }

  Album toAlbum() {
    Album album = Album();
    album.albumType = albumType;
    album.artists = artists;
    album.availableMarkets = availableMarkets;
    album.externalUrls = externalUrls;
    album.href = href;
    album.id = id;
    album.images = images;
    album.name = name;
    album.releaseDate = releaseDate;
    album.releaseDatePrecision = releaseDatePrecision;
    album.tracks = tracks;
    album.type = type;
    album.uri = uri;
    return album;
  }
}
