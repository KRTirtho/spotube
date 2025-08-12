/// Web stubs mínimos para compilar. NO hacen llamadas reales.
/// Añade campos a medida que el código los requiera.

class ExternalUrls { final Map<String, String>? data; ExternalUrls({this.data}); }
class Followers { final int? total; Followers({this.total}); }

class User {
  final String? id;
  final String? displayName;
  final List<SImage>? images;
  User({this.id, this.displayName, this.images});
}

class ArtistSimple { final String? name; ArtistSimple({this.name}); }

class Artist extends ArtistSimple {
  final String? id;
  final List<SImage>? images;
  final int? popularity;
  final Followers? followers;
  Artist({this.id, super.name, this.images, this.popularity, this.followers});
}

class SImage { 
  String? url; 
  int? height; 
  int? width;
  SImage({this.url, this.height, this.width});
}
typedef Image = SImage;

enum AlbumType { album, single, compilation, unknown }
enum Market { us, gb, ca, de, fr, it, es, au, jp, br, mx, ar, co, pe, cl, ve, ec, uy, py, bo, gf, sr, gy, fk, gt, bz, sv, hn, ni, cr, pa, cu, jm, ht, do_, pr, vi, ai, gp, mq, bl, mf, ag, dm, ms, kn, lc, vc, gd, tt, bb, tc, ky, bm, bs }

class TrackLink { final String? href; final String? id; TrackLink({this.href, this.id}); }

class TracksLink { final String? href; final int? total; TracksLink({this.href, this.total}); }

class Paging<T> {
  final List<T>? items;
  final String? href;
  final int? limit;
  final String? next;
  final int? offset;
  final String? previous;
  final int? total;
  Paging({this.items, this.href, this.limit, this.next, this.offset, this.previous, this.total});
}

class TrackSimple {
  final String? id;
  final String? name;
  final List<ArtistSimple>? artists;
  final int? durationMs;
  final bool? explicit_;
  final ExternalUrls? externalUrls;
  final int? popularity;
  final Duration? duration;
  TrackSimple({this.id, this.name, this.artists, this.durationMs, this.explicit_, this.externalUrls, this.popularity, this.duration});
}

class AlbumSimple {
  final String? id;
  final String? name;
  final AlbumType? albumType;
  final List<Image>? images;
  final List<ArtistSimple>? artists;
  final String? releaseDate;
  AlbumSimple({this.id, this.name, this.albumType, this.images, this.artists, this.releaseDate});
}

class Album extends AlbumSimple {
  Album({super.id, super.name, super.albumType, super.images, super.artists, super.releaseDate});
}

class PlaylistSimple {
  final String? id;
  final String? name;
  final List<Image>? images;
  final User? owner;
  final String? description;
  PlaylistSimple({this.id, this.name, this.images, this.owner, this.description});
}

class Playlist extends PlaylistSimple {
  final Followers? followers;
  Playlist({super.id, super.name, super.images, super.owner, super.description, this.followers});
}

class Track extends TrackSimple {
  final AlbumSimple? album;
  Track({super.id, super.name, super.artists, super.durationMs, super.explicit_, super.externalUrls, super.popularity, super.duration, this.album});
}

class Category {
  final String? id;
  final String? name;
  final List<Image>? icons;
  Category({this.id, this.name, this.icons});
}

class SpotifyApi {
  SpotifyApi(dynamic credentials);
  SpotifyApi.withAccessToken(String token);
  dynamic get albums => _AlbumsApi();
}

class SpotifyApiCredentials {
  final String? clientId;
  final String? clientSecret;
  final String? accessToken;
  final String? refreshToken;
  final String? redirectUri;
  final List<String>? scopes;
  
  SpotifyApiCredentials({
    this.clientId,
    this.clientSecret,
    this.accessToken,
    this.refreshToken,
    this.redirectUri,
    this.scopes,
  });
}

class _AlbumsApi {
  Future<Album> get(String? id) async => Album();
}

enum SearchType { track, album, artist, playlist }

class SMTCWindows {
  static SMTCWindows get instance => SMTCWindows._();
  SMTCWindows._();
  Future<void> enableSmtc() async {}
  Future<void> disableSmtc() async {}
}

/// Utiles que aparecen en extensiones:
class Metadata { 
  final List<Picture>? pictures;
  final Map<String, dynamic>? picture;
  Metadata({this.pictures, this.picture}); 
}
class Picture { final String? mimeType; final List<int>? bytes; Picture({this.mimeType, this.bytes}); }
