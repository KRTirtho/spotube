import 'package:spotify/spotify.dart';

Album simpleAlbumToAlbum(AlbumSimple albumSimple) {
  Album album = Album();
  album.albumType = albumSimple.albumType;
  album.artists = albumSimple.artists;
  album.availableMarkets = albumSimple.availableMarkets;
  album.externalUrls = albumSimple.externalUrls;
  album.href = albumSimple.href;
  album.id = albumSimple.id;
  album.images = albumSimple.images;
  album.name = albumSimple.name;
  album.releaseDate = albumSimple.releaseDate;
  album.releaseDatePrecision = albumSimple.releaseDatePrecision;
  album.tracks = albumSimple.tracks;
  album.type = albumSimple.type;
  album.uri = albumSimple.uri;
  return album;
}
