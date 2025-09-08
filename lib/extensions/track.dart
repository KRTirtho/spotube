import 'dart:io';
import 'dart:typed_data';

import 'package:metadata_god/metadata_god.dart';
import 'package:path/path.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/provider/spotify/spotify.dart';
import 'package:spotube/services/audio_player/audio_player.dart';
import 'package:spotube/services/logger/logger.dart';

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

  Metadata toMetadata({
    required int fileLength,
    Uint8List? imageBytes,
  }) {
    return Metadata(
      title: name,
      artist: artists?.map((a) => a.name).join(", "),
      album: album?.name,
      albumArtist: artists?.map((a) => a.name).join(", "),
      year: album?.releaseDate != null
          ? int.tryParse(album!.releaseDate!.split("-").first) ?? 1969
          : 1969,
      trackNumber: trackNumber,
      discNumber: discNumber,
      durationMs: durationMs?.toDouble() ?? 0.0,
      fileSize: BigInt.from(fileLength),
      trackTotal: album?.tracks?.length ?? 0,
      picture: imageBytes != null
          ? Picture(
              data: imageBytes,
              // Spotify images are always JPEGs
              mimeType: 'image/jpeg',
            )
          : null,
    );
  }
}

extension IterableTrackSimpleExtensions on Iterable<TrackSimple> {
  Future<List<Track>> asTracks(AlbumSimple album, ref) async {
    try {
      final spotify = ref.read(spotifyProvider);
      final tracks = await spotify.invoke(
        (api) => api.tracks.list(map((trackSimple) => trackSimple.id!).toList()));
      return tracks.toList();
    } catch (e, stack) {
      // Ignore errors and create the track locally
      AppLogger.reportError(e, stack);

      List<Track> tracks = [];
      for (final trackSimple in this) {
        Track track = Track();
        track.album = album;
        track.name = trackSimple.name;
        track.artists = trackSimple.artists;
        track.availableMarkets = trackSimple.availableMarkets;
        track.discNumber = trackSimple.discNumber;
        track.durationMs = trackSimple.durationMs;
        track.explicit = trackSimple.explicit;
        track.externalUrls = trackSimple.externalUrls;
        track.href = trackSimple.href;
        track.id = trackSimple.id;
        track.isPlayable = trackSimple.isPlayable;
        track.linkedFrom = trackSimple.linkedFrom;
        track.previewUrl = trackSimple.previewUrl;
        track.trackNumber = trackSimple.trackNumber;
        track.type = trackSimple.type;
        track.uri = trackSimple.uri;
        tracks.add(track);
      }
      return tracks;
    }
  }
}

extension TracksToMediaExtension on Iterable<Track> {
  List<SpotubeMedia> asMediaList() {
    return map((track) => SpotubeMedia(track)).toList();
  }
}
