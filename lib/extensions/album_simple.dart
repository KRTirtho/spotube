import 'package:spotify/spotify.dart';

extension AlbumExtensions on AlbumSimple {
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
