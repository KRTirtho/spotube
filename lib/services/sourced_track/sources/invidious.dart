import 'package:collection/collection.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/models/database/database.dart';
import 'package:spotube/provider/database/database.dart';
import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';
import 'package:spotube/services/sourced_track/enums.dart';
import 'package:spotube/services/sourced_track/exceptions.dart';
import 'package:spotube/services/sourced_track/models/source_info.dart';
import 'package:spotube/services/sourced_track/models/source_map.dart';
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

class InvidiousSourceInfo extends SourceInfo {
  InvidiousSourceInfo({
    required super.id,
    required super.title,
    required super.artist,
    required super.thumbnail,
    required super.pageUrl,
    required super.duration,
    required super.artistUrl,
    required super.album,
  });
}

class InvidiousSourcedTrack extends SourcedTrack {
  InvidiousSourcedTrack({
    required super.ref,
    required super.source,
    required super.siblings,
    required super.sourceInfo,
    required super.track,
  });

  static Future<SourcedTrack> fetchFromTrack({
    required Track track,
    required Ref ref,
  }) async {
    final database = ref.read(databaseProvider);
    final cachedSource = await (database.select(database.sourceMatchTable)
          ..where((s) => s.trackId.equals(track.id!))
          ..limit(1)
          ..orderBy([
            (s) =>
                OrderingTerm(expression: s.createdAt, mode: OrderingMode.desc),
          ]))
        .getSingleOrNull();
    final invidiousClient = ref.read(invidiousProvider);

    if (cachedSource == null) {
      final siblings = await fetchSiblings(ref: ref, track: track);
      if (siblings.isEmpty) {
        throw TrackNotFoundError(track);
      }

      await database.into(database.sourceMatchTable).insert(
            SourceMatchTableCompanion.insert(
              trackId: track.id!,
              sourceId: siblings.first.info.id,
              sourceType: const Value(SourceType.youtube),
            ),
          );

      return InvidiousSourcedTrack(
        ref: ref,
        siblings: siblings.map((s) => s.info).skip(1).toList(),
        source: siblings.first.source as SourceMap,
        sourceInfo: siblings.first.info,
        track: track,
      );
    } else {
      final manifest =
          await invidiousClient.videos.get(cachedSource.sourceId, local: true);

      return InvidiousSourcedTrack(
        ref: ref,
        siblings: [],
        source: toSourceMap(manifest),
        sourceInfo: InvidiousSourceInfo(
          id: manifest.videoId,
          artist: manifest.author,
          artistUrl: manifest.authorUrl,
          pageUrl: "https://www.youtube.com/watch?v=${manifest.videoId}",
          thumbnail: manifest.videoThumbnails.first.url,
          title: manifest.title,
          duration: Duration(seconds: manifest.lengthSeconds),
          album: null,
        ),
        track: track,
      );
    }
  }

  static SourceMap toSourceMap(InvidiousVideoResponse manifest) {
    final m4a = manifest.adaptiveFormats
        .where((audio) => audio.type.contains("audio/mp4"))
        .sorted((a, b) => int.parse(a.bitrate).compareTo(int.parse(b.bitrate)));

    final weba = manifest.adaptiveFormats
        .where((audio) => audio.type.contains("audio/webm"))
        .sorted((a, b) => int.parse(a.bitrate).compareTo(int.parse(b.bitrate)));

    return SourceMap(
      m4a: SourceQualityMap(
        high: m4a.first.url.toString(),
        medium: (m4a.elementAtOrNull(m4a.length ~/ 2) ?? m4a[1]).url.toString(),
        low: m4a.last.url.toString(),
      ),
      weba: SourceQualityMap(
        high: weba.first.url.toString(),
        medium:
            (weba.elementAtOrNull(weba.length ~/ 2) ?? weba[1]).url.toString(),
        low: weba.last.url.toString(),
      ),
    );
  }

  static Future<SiblingType> toSiblingType(
    int index,
    YoutubeVideoInfo item,
    InvidiousClient invidiousClient,
  ) async {
    SourceMap? sourceMap;
    if (index == 0) {
      final manifest = await invidiousClient.videos.get(item.id, local: true);
      sourceMap = toSourceMap(manifest);
    }

    final SiblingType sibling = (
      info: InvidiousSourceInfo(
        id: item.id,
        artist: item.channelName,
        artistUrl: "https://www.youtube.com/${item.channelId}",
        pageUrl: "https://www.youtube.com/watch?v=${item.id}",
        thumbnail: item.thumbnailUrl,
        title: item.title,
        duration: item.duration,
        album: null,
      ),
      source: sourceMap,
    );

    return sibling;
  }

  static Future<List<SiblingType>> fetchSiblings({
    required Track track,
    required Ref ref,
  }) async {
    final invidiousClient = ref.read(invidiousProvider);
    final preference = ref.read(userPreferencesProvider);

    final query = SourcedTrack.getSearchTerm(track);

    final searchResults = await invidiousClient.search.list(
      query,
      type: InvidiousSearchType.video,
    );

    if (ServiceUtils.onlyContainsEnglish(query)) {
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
      track,
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
    final fetchedSiblings = await fetchSiblings(ref: ref, track: this);

    return InvidiousSourcedTrack(
      ref: ref,
      siblings: fetchedSiblings
          .where((s) => s.info.id != sourceInfo.id)
          .map((s) => s.info)
          .toList(),
      source: source,
      sourceInfo: sourceInfo,
      track: this,
    );
  }

  @override
  Future<SourcedTrack?> swapWithSibling(SourceInfo sibling) async {
    if (sibling.id == sourceInfo.id) {
      return null;
    }

    // a sibling source that was fetched from the search results
    final isStepSibling = siblings.none((s) => s.id == sibling.id);

    final newSourceInfo = isStepSibling
        ? sibling
        : siblings.firstWhere((s) => s.id == sibling.id);
    final newSiblings = siblings.where((s) => s.id != sibling.id).toList()
      ..insert(0, sourceInfo);

    final pipedClient = ref.read(invidiousProvider);

    final manifest =
        await pipedClient.videos.get(newSourceInfo.id, local: true);

    final database = ref.read(databaseProvider);
    await database.into(database.sourceMatchTable).insert(
          SourceMatchTableCompanion.insert(
            trackId: id!,
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
      source: toSourceMap(manifest),
      sourceInfo: newSourceInfo,
      track: this,
    );
  }
}
