import 'dart:io';

import 'package:http/http.dart';
import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/models/database/database.dart';
import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';

import 'package:spotube/services/sourced_track/enums.dart';
import 'package:spotube/services/sourced_track/exceptions.dart';
import 'package:spotube/services/sourced_track/models/source_info.dart';
import 'package:spotube/services/sourced_track/models/source_map.dart';
import 'package:spotube/services/sourced_track/sources/invidious.dart';
import 'package:spotube/services/sourced_track/sources/jiosaavn.dart';
import 'package:spotube/services/sourced_track/sources/piped.dart';
import 'package:spotube/services/sourced_track/sources/youtube.dart';
import 'package:spotube/utils/service_utils.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

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
          track: track,
        ),
      AudioSource.piped => PipedSourcedTrack(
          ref: ref,
          source: source,
          siblings: siblings,
          sourceInfo: sourceInfo,
          track: track,
        ),
      AudioSource.jiosaavn => JioSaavnSourcedTrack(
          ref: ref,
          source: source,
          siblings: siblings,
          sourceInfo: sourceInfo,
          track: track,
        ),
      AudioSource.invidious => InvidiousSourcedTrack(
          ref: ref,
          source: source,
          siblings: siblings,
          sourceInfo: sourceInfo,
          track: track,
        ),
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

  static fetchFromTrackAltSource({
    required Track track,
    required Ref ref,
  }) async {
    final preferences = ref.read(userPreferencesProvider);
    try {
      return switch (preferences.audioSource) {
        AudioSource.piped ||
        AudioSource.invidious ||
        AudioSource.jiosaavn =>
          await YoutubeSourcedTrack.fetchFromTrack(track: track, ref: ref),
        AudioSource.youtube =>
          await JioSaavnSourcedTrack.fetchFromTrack(track: track, ref: ref),
      };
    } on TrackNotFoundError catch (_) {
      return switch (preferences.audioSource) {
        AudioSource.piped ||
        AudioSource.youtube ||
        AudioSource.invidious =>
          await JioSaavnSourcedTrack.fetchFromTrack(
            track: track,
            ref: ref,
            weakMatch: true,
          ),
        AudioSource.jiosaavn =>
          await YoutubeSourcedTrack.fetchFromTrack(track: track, ref: ref),
      };
    } on HttpClientClosedException catch (_) {
      return await PipedSourcedTrack.fetchFromTrack(track: track, ref: ref);
    } on VideoUnplayableException catch (_) {
      return await InvidiousSourcedTrack.fetchFromTrack(track: track, ref: ref);
    } catch (e) {
      if (e is DioException || e is ClientException || e is SocketException) {
        return await JioSaavnSourcedTrack.fetchFromTrack(
          track: track,
          ref: ref,
          weakMatch: preferences.audioSource == AudioSource.jiosaavn,
        );
      }
      rethrow;
    }
  }

  static Future<SourcedTrack> fetchFromTrack({
    required Track track,
    required Ref ref,
  }) async {
    final preferences = ref.read(userPreferencesProvider);
    try {
      return switch (preferences.audioSource) {
        AudioSource.piped =>
          await PipedSourcedTrack.fetchFromTrack(track: track, ref: ref),
        AudioSource.youtube =>
          await YoutubeSourcedTrack.fetchFromTrack(track: track, ref: ref),
        AudioSource.jiosaavn =>
          await JioSaavnSourcedTrack.fetchFromTrack(track: track, ref: ref),
        AudioSource.invidious =>
          await InvidiousSourcedTrack.fetchFromTrack(track: track, ref: ref),
      };
    } on TrackNotFoundError catch (_) {
      return switch (preferences.audioSource) {
        AudioSource.piped ||
        AudioSource.youtube ||
        AudioSource.invidious =>
          await JioSaavnSourcedTrack.fetchFromTrack(
            track: track,
            ref: ref,
            weakMatch: true,
          ),
        AudioSource.jiosaavn =>
          await YoutubeSourcedTrack.fetchFromTrack(track: track, ref: ref),
      };
    } on HttpClientClosedException catch (_) {
      return await PipedSourcedTrack.fetchFromTrack(track: track, ref: ref);
    } on VideoUnplayableException catch (_) {
      return await PipedSourcedTrack.fetchFromTrack(track: track, ref: ref);
    } catch (e) {
      if (e is DioException || e is ClientException || e is SocketException) {
        return switch (preferences.audioSource) {
          AudioSource.piped ||
          AudioSource.invidious =>
            await YoutubeSourcedTrack.fetchFromTrack(
              track: track,
              ref: ref,
            ),
          _ => await JioSaavnSourcedTrack.fetchFromTrack(
              track: track,
              ref: ref,
              weakMatch: preferences.audioSource == AudioSource.jiosaavn,
            )
        };
      }
      rethrow;
    }
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
      AudioSource.jiosaavn =>
        JioSaavnSourcedTrack.fetchSiblings(track: track, ref: ref),
      AudioSource.invidious =>
        InvidiousSourcedTrack.fetchSiblings(track: track, ref: ref),
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
        ? SourceCodecs.m4a
        : preferences.streamMusicCodec;

    return getUrlOfCodec(codec);
  }

  String getUrlOfCodec(SourceCodecs codec) {
    final preferences = ref.read(userPreferencesProvider);

    return source[codec]?[preferences.audioQuality] ??
        // this will ensure playback doesn't break
        source[codec == SourceCodecs.m4a ? SourceCodecs.weba : SourceCodecs.m4a]
            [preferences.audioQuality];
  }

  SourceCodecs get codec {
    final preferences = ref.read(userPreferencesProvider);

    return preferences.audioSource == AudioSource.jiosaavn
        ? SourceCodecs.m4a
        : preferences.streamMusicCodec;
  }
}
