import 'package:spotify/spotify.dart';
import 'package:spotube/models/CurrentPlaylist.dart';
import 'package:spotube/extensions/yt-video-from-cache-track.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

enum SpotubeTrackMatchAlgorithm {
  // selects the first result returned from YouTube
  youtube,
  // selects the most popular one
  popular,
  // selects the most popular one from the author of the track
  authenticPopular,
}

class SpotubeTrack extends Track {
  Video ytTrack;
  String ytUri;

  SpotubeTrack(
    this.ytTrack,
    this.ytUri,
  ) : super();

  SpotubeTrack.fromTrack({
    required Track track,
    required this.ytTrack,
    required this.ytUri,
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

  static SpotubeTrack fromJson(Map<String, dynamic> map) {
    return SpotubeTrack.fromTrack(
      track: Track.fromJson(map),
      ytTrack: VideoToJson.fromJson(map["ytTrack"]),
      ytUri: map["ytUri"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "album": album?.toJson(),
      "artists": artists?.map((artist) => artist.toJson()).toList(),
      "availableMarkets": availableMarkets,
      "discNumber": discNumber,
      "duration": duration.toString(),
      "durationMs": durationMs,
      "explicit": explicit,
      // "externalIds": externalIds,
      // "externalUrls": externalUrls,
      "href": href,
      "id": id,
      "isPlayable": isPlayable,
      // "linkedFrom": linkedFrom,
      "name": name,
      "popularity": popularity,
      "previewUrl": previewUrl,
      "trackNumber": trackNumber,
      "type": type,
      "uri": uri,
      "ytTrack": ytTrack.toJson(),
      "ytUri": ytUri,
    };
  }
}
