// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:flutter/widgets.dart' hide Image;
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:spotube/components/Shared/LinkText.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/utils/primitive_utils.dart';

abstract class TypeConversionUtils {
  static String image_X_UrlString(List<Image>? images, {int index = 0}) {
    return images != null && images.isNotEmpty
        ? images[0].url!
        : "https://avatars.dicebear.com/api/bottts/${PrimitiveUtils.uuid.v4()}.png";
  }

  static String artists_X_String<T extends ArtistSimple>(List<T> artists) {
    return artists.map((e) => e.name?.replaceAll(",", " ")).join(", ");
  }

  static Widget artists_X_ClickableArtists(
    List<ArtistSimple> artists, {
    WrapCrossAlignment crossAxisAlignment = WrapCrossAlignment.center,
    WrapAlignment mainAxisAlignment = WrapAlignment.center,
    TextStyle textStyle = const TextStyle(),
  }) {
    return Wrap(
      crossAxisAlignment: crossAxisAlignment,
      alignment: mainAxisAlignment,
      children: artists
          .asMap()
          .entries
          .map(
            (artist) => LinkText(
              (artist.key != artists.length - 1)
                  ? "${artist.value.name}, "
                  : artist.value.name!,
              "/artist/${artist.value.id}",
              overflow: TextOverflow.ellipsis,
              style: textStyle,
            ),
          )
          .toList(),
    );
  }

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

  static Track localTrack_X_Track(Metadata metadata, File file) {
    final track = Track();
    track.album = Album()
      ..name = metadata.albumName
      ..genres = [if (metadata.genre != null) metadata.genre!]
      ..artists = [
        Artist()
          ..name = metadata.albumArtistName
          ..id = metadata.albumArtistName
          ..type = "artist",
      ]
      ..id = "${metadata.albumName}${metadata.albumLength}";
    track.artists = metadata.trackArtistNames
        ?.map((name) => Artist()
          ..name = name
          ..id = name)
        .toList();

    track.discNumber = metadata.discNumber;
    track.durationMs = metadata.trackDuration;
    track.id = "${metadata.trackName}${metadata.trackDuration}";
    track.name = metadata.trackName;
    track.trackNumber = metadata.trackNumber;
    track.type = "track";
    track.uri = file.path;

    return track;
  }
}
