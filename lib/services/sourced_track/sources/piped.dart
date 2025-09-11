import 'package:collection/collection.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:piped_client/piped_client.dart';
import 'package:spotube/models/database/database.dart';
import 'package:spotube/models/playback/track_sources.dart';
import 'package:spotube/provider/database/database.dart';
import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';

import 'package:spotube/services/sourced_track/enums.dart';
import 'package:spotube/services/sourced_track/exceptions.dart';
import 'package:spotube/services/sourced_track/models/video_info.dart';
import 'package:spotube/services/sourced_track/sourced_track.dart';
import 'package:spotube/services/sourced_track/sources/youtube.dart';
import 'package:spotube/utils/service_utils.dart';

final pipedProvider = Provider<PipedClient>(
  (ref) {
    final instance =
        ref.watch(userPreferencesProvider.select((s) => s.pipedInstance));
    return PipedClient(instance: instance);
  },
);

class PipedSourcedTrack extends SourcedTrack {
  PipedSourcedTrack({
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
    final preferences = ref.read(userPreferencesProvider);
    final pipedClient = ref.read(pipedProvider);

    if (cachedSource == null) {
      final siblings = await fetchSiblings(ref: ref, query: query);
      if (siblings.isEmpty) {
        throw TrackNotFoundError(query);
      }

      await database.into(database.sourceMatchTable).insert(
            SourceMatchTableCompanion.insert(
              trackId: query.id,
              sourceId: siblings.first.info.id,
              sourceType: Value(
                preferences.searchMode == SearchMode.youtube
                    ? SourceType.youtube
                    : SourceType.youtubeMusic,
              ),
            ),
          );

      return PipedSourcedTrack(
        ref: ref,
        siblings: siblings.map((s) => s.info).skip(1).toList(),
        source: audioSource,
        info: siblings.first.info,
        query: query,
        sources: siblings.first.source!,
      );
    } else {
      final manifest = await pipedClient.streams(cachedSource.sourceId);

      return PipedSourcedTrack(
        ref: ref,
        siblings: [],
        sources: toSources(manifest),
        info: TrackSourceInfo(
          id: manifest.id,
          artists: manifest.uploader,
          pageUrl: "https://www.youtube.com/watch?v=${manifest.id}",
          thumbnail: manifest.thumbnailUrl,
          title: manifest.title,
          durationMs: manifest.duration.inMilliseconds,
        ),
        query: query,
        source: audioSource,
      );
    }
  }

  static List<TrackSource> toSources(PipedStreamResponse manifest) {
    return manifest.audioStreams.map((audio) {
      return TrackSource(
        url: audio.url.toString(),
        quality: switch (audio.quality) {
          "high" => SourceQualities.high,
          "medium" => SourceQualities.medium,
          _ => SourceQualities.low,
        },
        codec: audio.format == PipedAudioStreamFormat.m4a
            ? SourceCodecs.m4a
            : SourceCodecs.weba,
        bitrate: audio.bitrate.toString(),
      );
    }).toList();
  }

  static Future<SiblingType> toSiblingType(
    int index,
    YoutubeVideoInfo item,
    PipedClient pipedClient,
  ) async {
    List<TrackSource>? sources;
    if (index == 0) {
      final manifest = await pipedClient.streams(item.id);
      sources = toSources(manifest);
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
      source: sources,
    );

    return sibling;
  }

  static Future<List<SiblingType>> fetchSiblings({
    required TrackSourceQuery query,
    required Ref ref,
  }) async {
    final pipedClient = ref.read(pipedProvider);
    final preference = ref.read(userPreferencesProvider);

    final searchQuery = SourcedTrack.getSearchTerm(query);

    final PipedSearchResult(items: searchResults) = await pipedClient.search(
      searchQuery,
      preference.searchMode == SearchMode.youtube
          ? PipedFilter.videos
          : PipedFilter.musicSongs,
    );

    // when falling back to piped API make sure to use the YouTube mode
    final isYouTubeMusic = preference.audioSource != AudioSource.piped
        ? false
        : preference.searchMode == SearchMode.youtubeMusic;

    if (isYouTubeMusic) {
      final artists = query.artists;

      return await Future.wait(
        searchResults
            .map(
              (result) => YoutubeVideoInfo.fromSearchItemStream(
                result as PipedSearchItemStream,
                preference.searchMode,
              ),
            )
            .sorted((a, b) => b.views.compareTo(a.views))
            .where(
              (item) => artists.any(
                (artist) =>
                    artist.toLowerCase() == item.channelName.toLowerCase(),
              ),
            )
            .mapIndexed((i, r) => toSiblingType(i, r, pipedClient)),
      );
    }

    if (ServiceUtils.onlyContainsEnglish(searchQuery)) {
      return await Future.wait(
        searchResults
            .whereType<PipedSearchItemStream>()
            .map(
              (result) => YoutubeVideoInfo.fromSearchItemStream(
                result,
                preference.searchMode,
              ),
            )
            .mapIndexed((i, r) => toSiblingType(i, r, pipedClient)),
      );
    }

    final rankedSiblings = YoutubeSourcedTrack.rankResults(
      searchResults
          .map(
            (result) => YoutubeVideoInfo.fromSearchItemStream(
              result as PipedSearchItemStream,
              preference.searchMode,
            ),
          )
          .toList(),
      query,
    );

    return await Future.wait(
      rankedSiblings.mapIndexed((i, r) => toSiblingType(i, r, pipedClient)),
    );
  }

  @override
  Future<SourcedTrack> copyWithSibling() async {
    if (siblings.isNotEmpty) {
      return this;
    }
    final fetchedSiblings = await fetchSiblings(ref: ref, query: query);

    return PipedSourcedTrack(
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

    final pipedClient = ref.read(pipedProvider);

    final manifest = await pipedClient.streams(newSourceInfo.id);

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

    return PipedSourcedTrack(
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
    final manifest = await ref.read(pipedProvider).streams(info.id);
    return PipedSourcedTrack(
      ref: ref,
      siblings: siblings,
      info: info,
      source: source,
      query: query,
      sources: toSources(manifest),
    );
  }
}
