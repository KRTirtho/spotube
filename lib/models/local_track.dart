import 'package:spotify/spotify.dart';

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

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'path': path,
    };
  }
}
