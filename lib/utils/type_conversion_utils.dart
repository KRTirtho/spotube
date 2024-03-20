// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:metadata_god/metadata_god.dart';
import 'package:path/path.dart';
import 'package:spotify/spotify.dart';

enum ImagePlaceholder {
  albumArt,
  artist,
  collection,
  online,
}

abstract class TypeConversionUtils {
  static Album simpleAlbum_X_Album(AlbumSimple albumSimple) {
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

  static Track simpleTrack_X_Track(TrackSimple trackSmp, AlbumSimple album) {
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

  static Track localTrack_X_Track(
    File file, {
    Metadata? metadata,
    String? art,
  }) {
    final track = Track();
    track.album = Album()
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
    track.artists = [
      Artist()
        ..name = metadata?.artist ?? "Unknown"
        ..id = metadata?.artist ?? "Unknown"
    ];

    track.id = metadata?.title ?? basenameWithoutExtension(file.path);
    track.name = metadata?.title ?? basenameWithoutExtension(file.path);
    track.type = "track";
    track.uri = file.path;
    track.durationMs = (metadata?.durationMs?.toInt() ?? 0);

    return track;
  }
}
