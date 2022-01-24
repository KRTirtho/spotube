import 'package:spotify/spotify.dart';

Track simpleTrackToTrack(TrackSimple trackSmp, Album album) {
  Track track = Track();
  track.name = trackSmp.name;
  track.album = album;
  track.artists = trackSmp.artists;
  track.availableMarkets = trackSmp.availableMarkets;
  track.discNumber = trackSmp.discNumber;
  track.durationMs = trackSmp.durationMs;
  track.explicit = trackSmp.explicit;
  track.externalUrls = trackSmp.externalUrls;
  track.href = trackSmp.href;
  track.id = trackSmp.id;
  track.isPlayable = trackSmp.isPlayable;
  track.linkedFrom = trackSmp.linkedFrom;
  track.name = trackSmp.name;
  track.previewUrl = trackSmp.previewUrl;
  track.trackNumber = trackSmp.trackNumber;
  track.type = trackSmp.type;
  track.uri = trackSmp.uri;
  return track;
}
