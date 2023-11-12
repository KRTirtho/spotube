import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/provider/user_preferences_provider.dart';
import 'package:spotube/services/sourced_track/enums.dart';
import 'package:spotube/services/sourced_track/models/source_info.dart';
import 'package:spotube/services/sourced_track/models/source_map.dart';
import 'package:spotube/services/sourced_track/sources/piped.dart';
import 'package:spotube/services/sourced_track/sources/youtube.dart';
import 'package:spotube/utils/service_utils.dart';

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

  static SourcedTrack fromJson(
    Map<String, dynamic> json, {
    required Ref ref,
  }) {
    final preferences = ref.read(userPreferencesProvider);

    final sourceInfo = SourceInfo.fromJson(json);
    final source = SourceMap.fromJson(json);
    final track = Track.fromJson(json);
    final siblings = (json["siblings"] as List)
        .map((sibling) => SourceInfo.fromJson(sibling))
        .toList()
        .cast<SourceInfo>();

    return switch (preferences.audioSource) {
      AudioSource.youtube => YoutubeSourcedTrack(
          ref: ref,
          source: source,
          siblings: siblings,
          sourceInfo: sourceInfo,
          track: track),
      AudioSource.piped => PipedSourcedTrack(
          ref: ref,
          source: source,
          siblings: siblings,
          sourceInfo: sourceInfo,
          track: track),
      AudioSource.jiosaavn => throw UnimplementedError(),
    };
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
    final preferences = ref.read(userPreferencesProvider);

    return switch (preferences.audioSource) {
      AudioSource.piped =>
        PipedSourcedTrack.fetchFromTrack(track: track, ref: ref),
      AudioSource.youtube =>
        YoutubeSourcedTrack.fetchFromTrack(track: track, ref: ref),
      AudioSource.jiosaavn => throw UnimplementedError(),
    };
  }

  static Future<List<SiblingType>> fetchSiblings({
    required Track track,
    required Ref ref,
  }) {
    final preferences = ref.read(userPreferencesProvider);

    return switch (preferences.audioSource) {
      AudioSource.piped =>
        PipedSourcedTrack.fetchSiblings(track: track, ref: ref),
      AudioSource.youtube =>
        YoutubeSourcedTrack.fetchSiblings(track: track, ref: ref),
      AudioSource.jiosaavn => throw UnimplementedError(),
    };
  }

  Future<SourcedTrack> copyWithSibling();

  Future<SourcedTrack?> swapWithSibling(SourceInfo sibling);

  Future<SourcedTrack?> swapWithSiblingOfIndex(int index) {
    return swapWithSibling(siblings[index]);
  }

  String get url {
    final preferences = ref.read(userPreferencesProvider);

    final codec = preferences.audioSource == AudioSource.jiosaavn
        ? SourceCodecs.mp4
        : switch (preferences.streamMusicCodec) {
            MusicCodec.m4a => SourceCodecs.m4a,
            MusicCodec.weba => SourceCodecs.weba,
          };

    return source[codec]![preferences.audioQuality]!;
  }

  String getUrlOfCodec(MusicCodec codec) {
    final preferences = ref.read(userPreferencesProvider);

    return source[codec == MusicCodec.m4a
        ? SourceCodecs.m4a
        : SourceCodecs.weba]![preferences.audioQuality]!;
  }

  MusicCodec get codec {
    final preferences = ref.read(userPreferencesProvider);

    return preferences.audioSource == AudioSource.jiosaavn
        ? MusicCodec.m4a
        : preferences.streamMusicCodec;
  }
}
