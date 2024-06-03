import 'dart:io';

import 'package:metadata_god/metadata_god.dart';
import 'package:path/path.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/services/audio_player/audio_player.dart';

extension TrackExtensions on Track {
  Track fromFile(
    File file, {
    Metadata? metadata,
    String? art,
  }) {
    album = Album()
      ..name = metadata?.album ?? "Unknown"
      ..images = [if (art != null) Image()..url = art]
      ..genres = [if (metadata?.genre != null) metadata!.genre!]
      ..artists = [
        Artist()
          ..name = metadata?.albumArtist ?? "Unknown"
          ..id = metadata?.albumArtist ?? "Unknown"
          ..type = "artist",
      ]
      ..id = metadata?.album
      ..releaseDate = metadata?.year?.toString();
    artists = [
      Artist()
        ..name = metadata?.artist ?? "Unknown"
        ..id = metadata?.artist ?? "Unknown"
    ];

    id = metadata?.title ?? basenameWithoutExtension(file.path);
    name = metadata?.title ?? basenameWithoutExtension(file.path);
    type = "track";
    uri = file.path;
    durationMs = (metadata?.durationMs?.toInt() ?? 0);

    return this;
  }
}

extension TrackSimpleExtensions on TrackSimple {
  Track asTrack(AlbumSimple album) {
    Track track = Track();
    track.name = name;
    track.album = album;
    track.artists = artists;
    track.availableMarkets = availableMarkets;
    track.discNumber = discNumber;
    track.durationMs = durationMs;
    track.explicit = explicit;
    track.externalUrls = externalUrls;
    track.href = href;
    track.id = id;
    track.isPlayable = isPlayable;
    track.linkedFrom = linkedFrom;
    track.name = name;
    track.previewUrl = previewUrl;
    track.trackNumber = trackNumber;
    track.type = type;
    track.uri = uri;
    return track;
  }
}

extension TracksToMediaExtension on Iterable<Track> {
  List<SpotubeMedia> asMediaList() {
    return map((track) => SpotubeMedia(track)).toList();
  }
}
