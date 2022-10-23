// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:flutter/widgets.dart' hide Image;
import 'package:metadata_god/metadata_god.dart' hide Image;
import 'package:path/path.dart';
import 'package:spotube/components/Shared/AnchorButton.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/models/SpotubeTrack.dart';
import 'package:spotube/utils/primitive_utils.dart';
import 'package:spotube/utils/service_utils.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

enum ImagePlaceholder {
  albumArt,
  artist,
  collection,
  online,
}

abstract class TypeConversionUtils {
  static String image_X_UrlString(
    List<Image>? images, {
    int index = 1,
    required ImagePlaceholder placeholder,
  }) {
    final String placeholderUrl = {
      ImagePlaceholder.albumArt: "assets/album-placeholder.png",
      ImagePlaceholder.artist: "assets/user-placeholder.png",
      ImagePlaceholder.collection: "assets/placeholder.png",
      ImagePlaceholder.online:
          "https://avatars.dicebear.com/api/bottts/${PrimitiveUtils.uuid.v4()}.png",
    }[placeholder]!;

    return images != null && images.isNotEmpty
        ? images[index > images.length - 1 ? images.length - 1 : index].url!
        : placeholderUrl;
  }

  static String artists_X_String<T extends ArtistSimple>(List<T> artists) {
    return artists.map((e) => e.name?.replaceAll(",", " ")).join(", ");
  }

  static Widget artists_X_ClickableArtists(
    List<ArtistSimple> artists, {
    WrapCrossAlignment crossAxisAlignment = WrapCrossAlignment.center,
    WrapAlignment mainAxisAlignment = WrapAlignment.center,
    TextStyle textStyle = const TextStyle(),
    void Function(String route)? onRouteChange,
  }) {
    return Wrap(
      crossAxisAlignment: crossAxisAlignment,
      alignment: mainAxisAlignment,
      children: artists
          .asMap()
          .entries
          .map(
            (artist) => Builder(builder: (context) {
              return AnchorButton(
                (artist.key != artists.length - 1)
                    ? "${artist.value.name}, "
                    : artist.value.name!,
                onTap: () {
                  if (onRouteChange != null) {
                    onRouteChange("/artist/${artist.value.id}");
                  } else {
                    ServiceUtils.navigate(
                      context,
                      "/artist/${artist.value.id}",
                    );
                  }
                },
                overflow: TextOverflow.ellipsis,
                style: textStyle,
              );
            }),
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

  static SpotubeTrack localTrack_X_Track(
    File file, {
    Metadata? metadata,
    String? art,
  }) {
    final track = SpotubeTrack(
      Video(
        VideoId("dQw4w9WgXcQ"),
        basenameWithoutExtension(file.path),
        metadata?.artist ?? "",
        ChannelId(
          "https://www.youtube.com/channel/UCuAXFkgsw1L7xaCfnd5JJOw",
        ),
        DateTime.now(),
        "",
        DateTime.now(),
        "",
        Duration(milliseconds: metadata?.durationMs?.toInt() ?? 0),
        ThumbnailSet(metadata?.title ?? ""),
        [],
        const Engagement(0, 0, 0),
        false,
      ),
      file.path,
      [],
    );
    track.album = Album()
      ..name = metadata?.album ?? "Spotube"
      ..images = [if (art != null) Image()..url = art]
      ..genres = [if (metadata?.genre != null) metadata!.genre!]
      ..artists = [
        Artist()
          ..name = metadata?.albumArtist ?? "Spotube"
          ..id = metadata?.albumArtist ?? "Spotube"
          ..type = "artist",
      ]
      ..id = metadata?.album
      ..releaseDate = metadata?.year?.toString();
    track.artists = [
      Artist()
        ..name = metadata?.artist ?? "Spotube"
        ..id = metadata?.artist ?? "Spotube"
    ];

    track.id = metadata?.title ?? basenameWithoutExtension(file.path);
    track.name = metadata?.title ?? basenameWithoutExtension(file.path);
    track.type = "track";
    track.uri = file.path;
    track.durationMs = metadata?.durationMs?.toInt();

    return track;
  }
}
