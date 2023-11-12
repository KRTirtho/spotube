import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/services/sourced_track/enums.dart';
import 'package:spotube/utils/service_utils.dart';

class SourceInfo {
  final String id;
  final String title;
  final String artist;
  final String? album;

  final String thumbnail;
  final String pageUrl;

  SourceInfo({
    required this.id,
    required this.title,
    required this.artist,
    required this.thumbnail,
    required this.pageUrl,
    this.album,
  });
}

abstract class SourcedTrack extends Track {
  final SourceMap source;
  final List<SourceInfo> siblings;
  final SourceInfo sourceInfo;
  final Ref ref;

  SourcedTrack({
    required this.ref,
    required this.source,
    required this.siblings,
    required this.sourceInfo,
    required Track track,
  }) {
    id = track.id;
    name = track.name;
    artists = track.artists;
    album = track.album;
    durationMs = track.durationMs;
    discNumber = track.discNumber;
    explicit = track.explicit;
    externalIds = track.externalIds;
    href = track.href;
    isPlayable = track.isPlayable;
    linkedFrom = track.linkedFrom;
    popularity = track.popularity;
    previewUrl = track.previewUrl;
    trackNumber = track.trackNumber;
    type = track.type;
    uri = track.uri;
  }

  static String getSearchTerm(Track track) {
    final artists = (track.artists ?? [])
        .map((ar) => ar.name)
        .toList()
        .whereNotNull()
        .toList();

    final title = ServiceUtils.getTitle(
      track.name!,
      artists: artists,
      onlyCleanArtist: true,
    ).trim();

    return "$title - ${artists.join(", ")}";
  }

  static Future<SourcedTrack> fetchFromTrack({
    required Track track,
    required Ref ref,
  }) {
    throw UnimplementedError();
  }

  static Future<List<SiblingType>> fetchSiblings({
    required Track track,
    required Ref ref,
  }) {
    throw UnimplementedError();
  }

  Future<SourcedTrack> copyWithSibling();

  Future<SourcedTrack> swapWithSibling(SourceInfo sibling);

  Future<SourcedTrack> swapWithSiblingOfIndex(int index) {
    return swapWithSibling(siblings[index]);
  }
}
