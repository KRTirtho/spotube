import 'package:spotify/spotify.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class SpotubeTrack extends Track {
  Video ytTrack;
  String ytUri;

  SpotubeTrack.fromTrack({
    required Track track,
    required this.ytTrack,
    required this.ytUri,
  }) {
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
}
