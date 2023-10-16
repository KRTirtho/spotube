import 'package:spotify/spotify.dart';
import 'package:spotube/extensions/album_simple.dart';
import 'package:spotube/extensions/artist_simple.dart';

class LocalTrack extends Track {
  final String path;

  LocalTrack.fromTrack({
    required Track track,
    required this.path,
  }) : super() {
    album = track.album;
    artists = track.artists;
    availableMarkets = track.availableMarkets;
    discNumber = track.discNumber;
    durationMs = track.durationMs;
    explicit = track.explicit;
    externalIds = track.externalIds;
    externalUrls = track.externalUrls;
    href = track.href;
    id = track.id;
    isPlayable = track.isPlayable;
    linkedFrom = track.linkedFrom;
    name = track.name;
    popularity = track.popularity;
    previewUrl = track.previewUrl;
    trackNumber = track.trackNumber;
    type = track.type;
    uri = track.uri;
  }

  factory LocalTrack.fromJson(Map<String, dynamic> json) {
    return LocalTrack.fromTrack(
      track: Track.fromJson(json),
      path: json['path'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "album": album?.toJson(),
      "artists": artists?.map((artist) => artist.toJson()).toList(),
      "availableMarkets": availableMarkets?.map((m) => m.name),
      "discNumber": discNumber,
      "duration": duration.toString(),
      "durationMs": durationMs,
      "explicit": explicit,
      "href": href,
      "id": id,
      "isPlayable": isPlayable,
      "name": name,
      "popularity": popularity,
      "previewUrl": previewUrl,
      "trackNumber": trackNumber,
      "type": type,
      "uri": uri,
      'path': path,
    };
  }
}
