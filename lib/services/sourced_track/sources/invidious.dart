import 'package:collection/collection.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotube/models/database/database.dart';
import 'package:spotube/models/playback/track_sources.dart';
import 'package:spotube/provider/database/database.dart';
import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';
import 'package:spotube/services/sourced_track/enums.dart';
import 'package:spotube/services/sourced_track/exceptions.dart';
import 'package:spotube/services/sourced_track/models/video_info.dart';
import 'package:spotube/services/sourced_track/sourced_track.dart';
import 'package:invidious/invidious.dart';
import 'package:spotube/services/sourced_track/sources/youtube.dart';
import 'package:spotube/utils/service_utils.dart';

final invidiousProvider = Provider<InvidiousClient>(
  (ref) {
    final invidiousInstance = ref.watch(
      userPreferencesProvider.select((s) => s.invidiousInstance),
    );
    return InvidiousClient(server: invidiousInstance);
  },
);

class InvidiousSourcedTrack extends SourcedTrack {
  InvidiousSourcedTrack({
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
    final audioSource = ref.read(userPreferencesProvider).audioSource;
    final database = ref.read(databaseProvider);
    final cachedSource = await (database.select(database.sourceMatchTable)
          ..where((s) => s.trackId.equals(query.id))
          ..limit(1)
          ..orderBy([
            (s) =>
                OrderingTerm(expression: s.createdAt, mode: OrderingMode.desc),
          ]))
        .getSingleOrNull();
    final invidiousClient = ref.read(invidiousProvider);

    if (cachedSource == null) {
      final siblings = await fetchSiblings(ref: ref, query: query);
      if (siblings.isEmpty) {
        throw TrackNotFoundError(query);
      }

      await database.into(database.sourceMatchTable).insert(
            SourceMatchTableCompanion.insert(
              trackId: query.id,
              sourceId: siblings.first.info.id,
              sourceType: const Value(SourceType.youtube),
            ),
          );

      return InvidiousSourcedTrack(
        ref: ref,
        siblings: siblings.map((s) => s.info).skip(1).toList(),
        sources: siblings.first.source as List<TrackSource>,
        info: siblings.first.info,
        query: query,
        source: audioSource,
      );
    } else {
      final manifest =
          await invidiousClient.videos.get(cachedSource.sourceId, local: true);

      return InvidiousSourcedTrack(
        ref: ref,
        siblings: [],
        sources: toSources(manifest),
        info: TrackSourceInfo(
          id: manifest.videoId,
          artists: manifest.author,
          pageUrl: "https://www.youtube.com/watch?v=${manifest.videoId}",
          thumbnail: manifest.videoThumbnails.first.url,
          title: manifest.title,
          durationMs: Duration(seconds: manifest.lengthSeconds).inMilliseconds,
        ),
        query: query,
        source: audioSource,
      );
    }
  }

  static List<TrackSource> toSources(InvidiousVideoResponse manifest) {
    return manifest.adaptiveFormats.map((stream) {
      return TrackSource(
        url: stream.url.toString(),
        quality: switch (stream.qualityLabel) {
          "high" => SourceQualities.high,
          "medium" => SourceQualities.medium,
          _ => SourceQualities.low,
        },
        codec: stream.type.contains("audio/webm")
            ? SourceCodecs.weba
            : SourceCodecs.m4a,
        bitrate: stream.bitrate,
      );
    }).toList();
  }

  static Future<SiblingType> toSiblingType(
    int index,
    YoutubeVideoInfo item,
    InvidiousClient invidiousClient,
  ) async {
    List<TrackSource>? sourceMap;
    if (index == 0) {
      final manifest = await invidiousClient.videos.get(item.id, local: true);
      sourceMap = toSources(manifest);
    }

    final SiblingType sibling = (
      info: TrackSourceInfo(
        id: item.id,
        artists: item.channelName,
        pageUrl: "https://www.youtube.com/watch?v=${item.id}",
        thumbnail: item.thumbnailUrl,
        title: item.title,
        durationMs: item.duration.inMilliseconds,
      ),
      source: sourceMap,
    );

    return sibling;
  }

  static Future<List<SiblingType>> fetchSiblings({
    required TrackSourceQuery query,
    required Ref ref,
  }) async {
    final invidiousClient = ref.read(invidiousProvider);
    final preference = ref.read(userPreferencesProvider);

    final searchQuery = SourcedTrack.getSearchTerm(query);

    final searchResults = await invidiousClient.search.list(
      searchQuery,
      type: InvidiousSearchType.video,
    );

    if (ServiceUtils.onlyContainsEnglish(searchQuery)) {
      return await Future.wait(
        searchResults
            .whereType<InvidiousSearchResponseVideo>()
            .map(
              (result) => YoutubeVideoInfo.fromSearchResponse(
                result,
                preference.searchMode,
              ),
            )
            .mapIndexed((i, r) => toSiblingType(i, r, invidiousClient)),
      );
    }

    final rankedSiblings = YoutubeSourcedTrack.rankResults(
      searchResults
          .whereType<InvidiousSearchResponseVideo>()
          .map(
            (result) => YoutubeVideoInfo.fromSearchResponse(
              result,
              preference.searchMode,
            ),
          )
          .toList(),
      query,
    );

    return await Future.wait(
      rankedSiblings.mapIndexed((i, r) => toSiblingType(i, r, invidiousClient)),
    );
  }

  @override
  Future<SourcedTrack> copyWithSibling() async {
    if (siblings.isNotEmpty) {
      return this;
    }
    final fetchedSiblings = await fetchSiblings(ref: ref, query: query);

    return InvidiousSourcedTrack(
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
  Future<SourcedTrack?> swapWithSibling(TrackSourceInfo sibling) async {
    if (sibling.id == info.id) {
      return null;
    }

    // a sibling source that was fetched from the search results
    final isStepSibling = siblings.none((s) => s.id == sibling.id);

    final newSourceInfo = isStepSibling
        ? sibling
        : siblings.firstWhere((s) => s.id == sibling.id);
    final newSiblings = siblings.where((s) => s.id != sibling.id).toList()
      ..insert(0, info);

    final pipedClient = ref.read(invidiousProvider);

    final manifest =
        await pipedClient.videos.get(newSourceInfo.id, local: true);

    final database = ref.read(databaseProvider);
    await database.into(database.sourceMatchTable).insert(
          SourceMatchTableCompanion.insert(
            trackId: query.id,
            sourceId: newSourceInfo.id,
            sourceType: const Value(SourceType.youtube),
            // Because we're sorting by createdAt in the query
            // we have to update it to indicate priority
            createdAt: Value(DateTime.now()),
          ),
          mode: InsertMode.replace,
        );

    return InvidiousSourcedTrack(
      ref: ref,
      siblings: newSiblings,
      sources: toSources(manifest),
      info: newSourceInfo,
      query: query,
      source: source,
    );
  }

  @override
  Future<SourcedTrack> refreshStream() async {
    final manifest =
        await ref.read(invidiousProvider).videos.get(info.id, local: true);

    return InvidiousSourcedTrack(
      ref: ref,
      siblings: siblings,
      sources: toSources(manifest),
      info: info,
      query: query,
      source: source,
    );
  }
}
