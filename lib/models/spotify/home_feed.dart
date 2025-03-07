import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spotify/spotify.dart';

part 'home_feed.freezed.dart';
part 'home_feed.g.dart';

@freezed
class SpotifySectionPlaylist with _$SpotifySectionPlaylist {
  const SpotifySectionPlaylist._();

  const factory SpotifySectionPlaylist({
    required String description,
    required String format,
    required List<SpotifySectionItemImage> images,
    required String name,
    required String owner,
    required String uri,
  }) = _SpotifySectionPlaylist;

  factory SpotifySectionPlaylist.fromJson(Map<String, dynamic> json) =>
      _$SpotifySectionPlaylistFromJson(json);

  String get id => uri.split(":").last;

  Playlist get asPlaylist {
    return Playlist()
      ..id = id
      ..name = name
      ..description = description
      ..collaborative = false
      ..images = images.map((e) => e.asImage).toList()
      ..owner = (User()..displayName = owner)
      ..uri = uri
      ..type = "playlist";
  }
}

@freezed
class SpotifySectionArtist with _$SpotifySectionArtist {
  const SpotifySectionArtist._();

  const factory SpotifySectionArtist({
    required String name,
    required String uri,
    required List<SpotifySectionItemImage> images,
  }) = _SpotifySectionArtist;

  factory SpotifySectionArtist.fromJson(Map<String, dynamic> json) =>
      _$SpotifySectionArtistFromJson(json);

  String get id => uri.split(":").last;

  Artist get asArtist {
    return Artist()
      ..id = id
      ..name = name
      ..images = images.map((e) => e.asImage).toList()
      ..type = "artist"
      ..uri = uri;
  }
}

@freezed
class SpotifySectionAlbum with _$SpotifySectionAlbum {
  const SpotifySectionAlbum._();

  const factory SpotifySectionAlbum({
    required List<SpotifySectionAlbumArtist> artists,
    required List<SpotifySectionItemImage> images,
    required String name,
    required String uri,
  }) = _SpotifySectionAlbum;

  factory SpotifySectionAlbum.fromJson(Map<String, dynamic> json) =>
      _$SpotifySectionAlbumFromJson(json);

  String get id => uri.split(":").last;

  Album get asAlbum {
    return Album()
      ..id = id
      ..name = name
      ..artists = artists.map((a) => a.asArtist).toList()
      ..albumType = AlbumType.album
      ..images = images.map((e) => e.asImage).toList()
      ..uri = uri;
  }
}

@freezed
class SpotifySectionAlbumArtist with _$SpotifySectionAlbumArtist {
  const SpotifySectionAlbumArtist._();

  const factory SpotifySectionAlbumArtist({
    required String name,
    required String uri,
  }) = _SpotifySectionAlbumArtist;

  factory SpotifySectionAlbumArtist.fromJson(Map<String, dynamic> json) =>
      _$SpotifySectionAlbumArtistFromJson(json);

  String get id => uri.split(":").last;

  Artist get asArtist {
    return Artist()
      ..id = id
      ..name = name
      ..type = "artist"
      ..uri = uri;
  }
}

@freezed
class SpotifySectionItemImage with _$SpotifySectionItemImage {
  const SpotifySectionItemImage._();

  const factory SpotifySectionItemImage({
    required num? height,
    required String url,
    required num? width,
  }) = _SpotifySectionItemImage;

  factory SpotifySectionItemImage.fromJson(Map<String, dynamic> json) =>
      _$SpotifySectionItemImageFromJson(json);

  Image get asImage {
    return Image()
      ..height = height?.toInt()
      ..width = width?.toInt()
      ..url = url;
  }
}

@freezed
class SpotifyHomeFeedSectionItem with _$SpotifyHomeFeedSectionItem {
  factory SpotifyHomeFeedSectionItem({
    required String typename,
    SpotifySectionPlaylist? playlist,
    SpotifySectionArtist? artist,
    SpotifySectionAlbum? album,
  }) = _SpotifyHomeFeedSectionItem;

  factory SpotifyHomeFeedSectionItem.fromJson(Map<String, dynamic> json) =>
      _$SpotifyHomeFeedSectionItemFromJson(json);
}

@freezed
class SpotifyHomeFeedSection with _$SpotifyHomeFeedSection {
  factory SpotifyHomeFeedSection({
    required String typename,
    String? title,
    required String uri,
    required List<SpotifyHomeFeedSectionItem> items,
  }) = _SpotifyHomeFeedSection;

  factory SpotifyHomeFeedSection.fromJson(Map<String, dynamic> json) =>
      _$SpotifyHomeFeedSectionFromJson(json);
}

@freezed
class SpotifyHomeFeed with _$SpotifyHomeFeed {
  factory SpotifyHomeFeed({
    required String greeting,
    required List<SpotifyHomeFeedSection> sections,
  }) = _SpotifyHomeFeed;

  factory SpotifyHomeFeed.fromJson(Map<String, dynamic> json) =>
      _$SpotifyHomeFeedFromJson(json);
}

Map<String, dynamic> transformSectionItemTypeJsonMap(
    Map<String, dynamic> json) {
  final data = json["content"]["data"];
  final objType = json["content"]["data"]["__typename"];
  return {
    "typename": json["content"]["__typename"],
    if (objType == "Playlist")
      "playlist": {
        "name": data["name"],
        "description": data["description"],
        "format": data["format"],
        "images": (data["images"]["items"] as List)
            .expand((j) => j["sources"] as dynamic)
            .toList()
            .cast<Map<String, dynamic>>(),
        "owner": data["ownerV2"]["data"]["name"],
        "uri": data["uri"]
      },
    if (objType == "Artist")
      "artist": {
        "name": data["profile"]["name"],
        "uri": data["uri"],
        "images": data["visuals"]["avatarImage"]["sources"],
      },
    if (objType == "Album")
      "album": {
        "name": data["name"],
        "uri": data["uri"],
        "images": data["coverArt"]["sources"],
        "artists": data["artists"]["items"]
            .map(
              (artist) => {
                "name": artist["profile"]["name"],
                "uri": artist["uri"],
              },
            )
            .toList()
      },
  };
}

Map<String, dynamic> transformSectionItemJsonMap(Map<String, dynamic> json) {
  return {
    "typename": json["data"]["__typename"],
    "title": json["data"]?["title"]?["text"],
    "uri": json["uri"],
    "items": (json["sectionItems"]["items"] as List)
        .map(
          (data) =>
              transformSectionItemTypeJsonMap(data as Map<String, dynamic>)
                  as dynamic,
        )
        .where(
          (w) =>
              w["playlist"] != null ||
              w["artist"] != null ||
              w["album"] != null,
        )
        .toList()
        .cast<Map<String, dynamic>>()
  };
}

Map<String, dynamic> transformHomeFeedJsonMap(Map<String, dynamic> json) {
  return {
    "greeting": json["data"]["home"]["greeting"]["text"],
    "sections":
        (json["data"]["home"]["sectionContainer"]["sections"]["items"] as List)
            .map(
              (item) =>
                  transformSectionItemJsonMap(item as Map<String, dynamic>)
                      as dynamic,
            )
            .toList()
            .cast<Map<String, dynamic>>()
  };
}
