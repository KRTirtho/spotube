import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotube/models/database/database.dart';
import 'package:spotube/models/playback/track_sources.dart';
import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';

import 'package:spotube/services/sourced_track/enums.dart';
import 'package:spotube/services/sourced_track/sources/invidious.dart';
import 'package:spotube/services/sourced_track/sources/jiosaavn.dart';
import 'package:spotube/services/sourced_track/sources/piped.dart';
import 'package:spotube/services/sourced_track/sources/youtube.dart';
import 'package:spotube/utils/service_utils.dart';

abstract class SourcedTrack extends BasicSourcedTrack {
  final Ref ref;

  SourcedTrack({
    required this.ref,
    required super.info,
    required super.query,
    required super.source,
    required super.siblings,
    required super.sources,
  });

  static SourcedTrack fromJson(
    Map<String, dynamic> json, {
    required Ref ref,
  }) {
    final preferences = ref.read(userPreferencesProvider);

    final info = TrackSourceInfo.fromJson(json["info"]);
    final query = TrackSourceQuery.fromJson(json["query"]);
    final source = AudioSource.values.firstWhereOrNull(
          (source) => source.name == json["source"],
        ) ??
        preferences.audioSource;
    final siblings = (json["siblings"] as List)
        .map((s) => TrackSourceInfo.fromJson(s))
        .toList();
    final sources =
        (json["sources"] as List).map((s) => TrackSource.fromJson(s)).toList();

    return switch (preferences.audioSource) {
      AudioSource.youtube => YoutubeSourcedTrack(
          ref: ref,
          source: source,
          siblings: siblings,
          info: info,
          query: query,
          sources: sources,
        ),
      AudioSource.piped => PipedSourcedTrack(
          ref: ref,
          source: source,
          siblings: siblings,
          info: info,
          query: query,
          sources: sources,
        ),
      AudioSource.jiosaavn => JioSaavnSourcedTrack(
          ref: ref,
          source: source,
          siblings: siblings,
          info: info,
          query: query,
          sources: sources,
        ),
      AudioSource.invidious => InvidiousSourcedTrack(
          ref: ref,
          source: source,
          siblings: siblings,
          info: info,
          query: query,
          sources: sources,
        ),
    };
  }

  static String getSearchTerm(TrackSourceQuery track) {
    final title = ServiceUtils.getTitle(
      track.title,
      artists: track.artists,
      onlyCleanArtist: true,
    ).trim();

    return "$title - ${track.artists.join(", ")}";
  }

  static Future<SourcedTrack> fetchFromQuery({
    required TrackSourceQuery query,
    required Ref ref,
  }) async {
    final preferences = ref.read(userPreferencesProvider);
    try {
      return switch (preferences.audioSource) {
        AudioSource.youtube =>
          await YoutubeSourcedTrack.fetchFromTrack(query: query, ref: ref),
        AudioSource.piped =>
          await PipedSourcedTrack.fetchFromTrack(query: query, ref: ref),
        AudioSource.invidious =>
          await InvidiousSourcedTrack.fetchFromTrack(query: query, ref: ref),
        AudioSource.jiosaavn =>
          await JioSaavnSourcedTrack.fetchFromTrack(query: query, ref: ref),
      };
    } catch (e) {
      if (preferences.audioSource == AudioSource.youtube) {
        rethrow;
      }

      return await YoutubeSourcedTrack.fetchFromTrack(query: query, ref: ref);
    }
  }

  static Future<List<SiblingType>> fetchSiblings({
    required TrackSourceQuery query,
    required Ref ref,
  }) {
    final preferences = ref.read(userPreferencesProvider);

    return switch (preferences.audioSource) {
      AudioSource.piped =>
        PipedSourcedTrack.fetchSiblings(query: query, ref: ref),
      AudioSource.youtube =>
        YoutubeSourcedTrack.fetchSiblings(query: query, ref: ref),
      AudioSource.jiosaavn =>
        JioSaavnSourcedTrack.fetchSiblings(query: query, ref: ref),
      AudioSource.invidious =>
        InvidiousSourcedTrack.fetchSiblings(query: query, ref: ref),
    };
  }

  Future<SourcedTrack> copyWithSibling();

  Future<SourcedTrack?> swapWithSibling(TrackSourceInfo sibling);

  Future<SourcedTrack?> swapWithSiblingOfIndex(int index) {
    return swapWithSibling(siblings[index]);
  }

  Future<SourcedTrack> refreshStream();
  String get url {
    final preferences = ref.read(userPreferencesProvider);

    final codec = preferences.audioSource == AudioSource.jiosaavn
        ? SourceCodecs.m4a
        : preferences.streamMusicCodec;

    return getUrlOfCodec(codec);
  }

  String getUrlOfCodec(SourceCodecs codec) {
    final preferences = ref.read(userPreferencesProvider);

    return sources
            .firstWhereOrNull(
              (source) =>
                  source.codec == codec &&
                  source.quality == preferences.audioQuality,
            )
            ?.url ??
        // fallback to the first available source of the same codec
        sources.firstWhereOrNull((source) => source.codec == codec)?.url ??
        // fallback to the first available source of any codec
        sources
            .firstWhereOrNull(
                (source) => source.quality == preferences.audioQuality)
            ?.url ??
        // fallback to the first available source
        sources.first.url;
  }

  SourceCodecs get codec {
    final preferences = ref.read(userPreferencesProvider);

    return preferences.audioSource == AudioSource.jiosaavn
        ? SourceCodecs.m4a
        : preferences.streamMusicCodec;
  }

  TrackSource get activeTrackSource {
    final audioQuality = ref.read(userPreferencesProvider).audioQuality;
    return sources.firstWhereOrNull(
          (source) => source.codec == codec && source.quality == audioQuality,
        ) ??
        sources.first;
  }
}
