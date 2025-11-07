import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotube/models/database/database.dart';
import 'package:spotube/models/playback/track_sources.dart';
import 'package:spotube/provider/database/database.dart';
import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';
import 'package:spotube/services/logger/logger.dart';
import 'package:spotube/services/sourced_track/enums.dart';
import 'package:spotube/services/sourced_track/exceptions.dart';
import 'package:spotube/services/sourced_track/sourced_track.dart';
import 'package:dab_music_api/dab_music_api.dart';

final dabMusicApiClient = DabMusicApiClient(
  Dio(),
  baseUrl: "https://dab.yeet.su/api",
);

/// Only Music source that can't support database caching due to having no endpoint.
/// But ISRC search is 100% reliable so caching is actually not necessary.
class DABMusicSourcedTrack extends SourcedTrack {
  DABMusicSourcedTrack({
    required super.ref,
    required super.source,
    required super.siblings,
    required super.info,
    required super.query,
    required super.sources,
  });

  static Future<SourcedTrack> fetchFromTrack({
    required TrackSourceQuery query,
    required Ref ref,
  }) async {
    try {
      final database = ref.read(databaseProvider);
      final cachedSource = await (database.select(database.sourceMatchTable)
            ..where((s) => s.trackId.equals(query.id))
            ..limit(1)
            ..orderBy([
              (s) => OrderingTerm(
                    expression: s.createdAt,
                    mode: OrderingMode.desc,
                  ),
            ]))
          .get()
          .then((s) => s.firstOrNull);

      if (cachedSource != null &&
          cachedSource.sourceType == SourceType.dabMusic) {
        final json = jsonDecode(cachedSource.sourceId);
        final info = TrackSourceInfo.fromJson(json["info"]);
        final source = (json["sources"] as List?)
            ?.map((s) => TrackSource.fromJson(s))
            .toList();

        final [updatedSource] = await fetchSources(
          info.id,
          ref.read(userPreferencesProvider).audioQuality,
          const AudioQuality(
            isHiRes: true,
            maximumBitDepth: 16,
            maximumSamplingRate: 44.1,
          ),
        );

        return DABMusicSourcedTrack(
          ref: ref,
          source: AudioSource.dabMusic,
          siblings: [],
          info: info,
          query: query,
          sources: [
            source!.first.copyWith(url: updatedSource.url),
          ],
        );
      }

      final siblings = await fetchSiblings(ref: ref, query: query);

      if (siblings.isEmpty) {
        throw TrackNotFoundError(query);
      }

      await database.into(database.sourceMatchTable).insert(
            SourceMatchTableCompanion.insert(
              trackId: query.id,
              sourceId: jsonEncode({
                "info": siblings.first.info.toJson(),
                "sources": (siblings.first.source ?? [])
                    .map((s) => s.toJson())
                    .toList(),
              }),
              sourceType: const Value(SourceType.dabMusic),
            ),
          );

      return DABMusicSourcedTrack(
        ref: ref,
        siblings: siblings.map((s) => s.info).skip(1).toList(),
        sources: siblings.first.source!,
        info: siblings.first.info,
        query: query,
        source: AudioSource.dabMusic,
      );
    } catch (e, stackTrace) {
      AppLogger.reportError(e, stackTrace);
      rethrow;
    }
  }

  static Future<List<TrackSource>> fetchSources(
    String id,
    SourceQualities quality,
    AudioQuality trackMaximumQuality,
  ) async {
    try {
      final isUncompressed = quality == SourceQualities.uncompressed;
      final streamResponse = await dabMusicApiClient.music.getStream(
        trackId: id,
        quality: isUncompressed ? "27" : "5",
      );
      if (streamResponse.url == null) {
        throw Exception("No stream URL found for track ID: $id");
      }

      // kbps = (bitDepth * sampleRate * channels) / 1000
      final uncompressedBitrate = !isUncompressed
          ? 0
          : ((trackMaximumQuality.maximumBitDepth ?? 0) *
                  ((trackMaximumQuality.maximumSamplingRate ?? 0) * 1000) *
                  2) /
              1000;
      return [
        TrackSource(
          url: streamResponse.url!,
          quality: isUncompressed
              ? SourceQualities.uncompressed
              : SourceQualities.high,
          bitrate:
              isUncompressed ? "${uncompressedBitrate.floor()}kbps" : "320kbps",
          codec: isUncompressed ? SourceCodecs.flac : SourceCodecs.mp3,
          qualityLabel: isUncompressed
              ? "${trackMaximumQuality.maximumBitDepth}bit • ${trackMaximumQuality.maximumSamplingRate}kHz • FLAC • Stereo"
              : "MP3 • 320kbps • mp3 • Stereo",
        ),
      ];
    } catch (e, stackTrace) {
      AppLogger.reportError(e, stackTrace);
      rethrow;
    }
  }

  static Future<SiblingType> toSiblingType(
    Ref ref,
    int index,
    Track result,
  ) async {
    try {
      List<TrackSource>? source;
      if (index == 0) {
        source = await fetchSources(
          result.id.toString(),
          ref.read(userPreferencesProvider).audioQuality,
          result.audioQuality!,
        );
      }

      final SiblingType sibling = (
        info: TrackSourceInfo(
          artists: result.artist!,
          durationMs: Duration(seconds: result.duration!).inMilliseconds,
          id: result.id.toString(),
          pageUrl: "https://dab.yeet.su/music/${result.id}",
          thumbnail: result.albumCover!,
          title: result.title!,
        ),
        source: source,
      );

      return sibling;
    } catch (e, stackTrace) {
      AppLogger.reportError(e, stackTrace);
      rethrow;
    }
  }

  static Future<List<SiblingType>> fetchSiblings({
    required TrackSourceQuery query,
    required Ref ref,
  }) async {
    try {
      List<Track> results = [];

      if (query.isrc.isNotEmpty) {
        final res =
            await dabMusicApiClient.music.getSearch(q: query.isrc, limit: 1);
        results = res.tracks ?? <Track>[];
      }

      if (results.isEmpty) {
        final res = await dabMusicApiClient.music.getSearch(
          q: SourcedTrack.getSearchTerm(query),
          limit: 5,
        );
        results = res.tracks ?? <Track>[];
      }

      if (results.isEmpty) {
        return [];
      }

      final matchedResults =
          results.mapIndexed((index, d) => toSiblingType(ref, index, d));

      return Future.wait(matchedResults);
    } catch (e, stackTrace) {
      AppLogger.reportError(e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<DABMusicSourcedTrack> copyWithSibling() async {
    if (siblings.isNotEmpty) {
      return this;
    }
    final fetchedSiblings = await fetchSiblings(ref: ref, query: query);

    return DABMusicSourcedTrack(
      ref: ref,
      siblings: fetchedSiblings
          .where((s) => s.info.id != info.id)
          .map((s) => s.info)
          .toList(),
      source: source,
      info: info,
      query: query,
      sources: sources,
    );
  }

  @override
  Future<DABMusicSourcedTrack?> swapWithSibling(TrackSourceInfo sibling) async {
    if (sibling.id == this.info.id) {
      return null;
    }

    // a sibling source that was fetched from the search results
    final isStepSibling = siblings.none((s) => s.id == sibling.id);

    final newSourceInfo = isStepSibling
        ? sibling
        : siblings.firstWhere((s) => s.id == sibling.id);
    final newSiblings = siblings.where((s) => s.id != sibling.id).toList()
      ..insert(0, this.info);

    final source = await fetchSources(
      sibling.id,
      ref.read(userPreferencesProvider).audioQuality,
      const AudioQuality(
        isHiRes: true,
        maximumBitDepth: 16,
        maximumSamplingRate: 44.1,
      ),
    );

    final database = ref.read(databaseProvider);

    await database.into(database.sourceMatchTable).insert(
          SourceMatchTableCompanion.insert(
            trackId: query.id,
            sourceId: jsonEncode({
              "info": newSourceInfo.toJson(),
              "sources": source.map((s) => s.toJson()).toList(),
            }),
            sourceType: const Value(SourceType.dabMusic),
            // Because we're sorting by createdAt in the query
            // we have to update it to indicate priority
            createdAt: Value(DateTime.now()),
          ),
          mode: InsertMode.replace,
        );

    return DABMusicSourcedTrack(
      ref: ref,
      siblings: newSiblings,
      sources: source,
      info: newSourceInfo,
      query: query,
      source: AudioSource.dabMusic,
    );
  }

  @override
  Future<SourcedTrack> refreshStream() async {
    // There's no need to refresh the stream for DABMusicSourcedTrack
    return this;
  }
}
