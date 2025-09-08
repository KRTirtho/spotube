import 'package:collection/collection.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotube/models/database/database.dart';
import 'package:spotube/models/playback/track_sources.dart';
import 'package:spotube/provider/database/database.dart';
import 'package:spotube/services/sourced_track/enums.dart';
import 'package:spotube/services/sourced_track/exceptions.dart';
import 'package:spotube/services/sourced_track/sourced_track.dart';
import 'package:jiosaavn/jiosaavn.dart';
import 'package:spotube/extensions/string.dart';

final jiosaavnClient = JioSaavnClient();

class JioSaavnSourcedTrack extends SourcedTrack {
  JioSaavnSourcedTrack({
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
    bool weakMatch = false,
  }) async {
    final database = ref.read(databaseProvider);
    final cachedSource = await (database.select(database.sourceMatchTable)
          ..where((s) => s.trackId.equals(query.id))
          ..limit(1)
          ..orderBy([
            (s) =>
                OrderingTerm(expression: s.createdAt, mode: OrderingMode.desc),
          ]))
        .getSingleOrNull();

    if (cachedSource == null ||
        cachedSource.sourceType != SourceType.jiosaavn) {
      final siblings =
          await fetchSiblings(ref: ref, query: query, weakMatch: weakMatch);

      if (siblings.isEmpty) {
        throw TrackNotFoundError(query);
      }

      await database.into(database.sourceMatchTable).insert(
            SourceMatchTableCompanion.insert(
              trackId: query.id,
              sourceId: siblings.first.info.id,
              sourceType: const Value(SourceType.jiosaavn),
            ),
          );

      return JioSaavnSourcedTrack(
        ref: ref,
        siblings: siblings.map((s) => s.info).skip(1).toList(),
        sources: siblings.first.source!,
        info: siblings.first.info,
        query: query,
        source: AudioSource.jiosaavn,
      );
    }

    final [item] =
        await jiosaavnClient.songs.detailsById([cachedSource.sourceId]);

    final (:info, :source) = toSiblingType(item);

    return JioSaavnSourcedTrack(
      ref: ref,
      siblings: [],
      sources: source!,
      query: query,
      info: info,
      source: AudioSource.jiosaavn,
    );
  }

  static SiblingType toSiblingType(SongResponse result) {
    final SiblingType sibling = (
      info: TrackSourceInfo(
        artists: [
          result.primaryArtists,
          if (result.featuredArtists.isNotEmpty) ", ",
          result.featuredArtists
        ].join("").unescapeHtml(),
        durationMs:
            Duration(seconds: int.parse(result.duration)).inMilliseconds,
        id: result.id,
        pageUrl: result.url,
        thumbnail: result.image?.last.link ?? "",
        title: result.name!.unescapeHtml(),
      ),
      source: result.downloadUrl!.map((link) {
        return TrackSource(
          url: link.link,
          quality: link.quality == "320kbps"
              ? SourceQualities.high
              : link.quality == "160kbps"
                  ? SourceQualities.medium
                  : SourceQualities.low,
          codec: SourceCodecs.m4a,
          bitrate: link.quality,
        );
      }).toList()
    );

    return sibling;
  }

  static Future<List<SiblingType>> fetchSiblings({
    required TrackSourceQuery query,
    required Ref ref,
    bool weakMatch = false,
  }) async {
    final searchQuery = SourcedTrack.getSearchTerm(query);

    final SongSearchResponse(:results) =
        await jiosaavnClient.search.songs(searchQuery, limit: 20);

    final trackArtistNames = query.artists;

    final matchedResults = results
        .where(
          (s) {
            s.name?.unescapeHtml().contains(query.title) ?? false;

            final sameName = s.name?.unescapeHtml() == query.title;
            final artistNames = [
              s.primaryArtists,
              if (s.featuredArtists.isNotEmpty) ", ",
              s.featuredArtists
            ].join("").unescapeHtml();
            final sameArtists = artistNames.split(", ").any(
                  (artist) => trackArtistNames.any((ar) => artist == ar),
                );
            if (weakMatch) {
              final containsName =
                  s.name?.unescapeHtml().contains(query.title) ?? false;
              final containsPrimaryArtist = s.primaryArtists
                  .unescapeHtml()
                  .contains(trackArtistNames.first);

              return containsName && containsPrimaryArtist;
            }

            return sameName && sameArtists;
          },
        )
        .map(toSiblingType)
        .toList();

    if (weakMatch && matchedResults.isEmpty) {
      return results.map(toSiblingType).toList();
    }

    return matchedResults;
  }

  @override
  Future<JioSaavnSourcedTrack> copyWithSibling() async {
    if (siblings.isNotEmpty) {
      return this;
    }
    final fetchedSiblings = await fetchSiblings(ref: ref, query: query);

    return JioSaavnSourcedTrack(
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
  Future<JioSaavnSourcedTrack?> swapWithSibling(TrackSourceInfo sibling) async {
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

    final [item] = await jiosaavnClient.songs.detailsById([newSourceInfo.id]);

    final (:info, :source) = toSiblingType(item);

    final database = ref.read(databaseProvider);
    await database.into(database.sourceMatchTable).insert(
          SourceMatchTableCompanion.insert(
            trackId: query.id,
            sourceId: info.id,
            sourceType: const Value(SourceType.jiosaavn),
            // Because we're sorting by createdAt in the query
            // we have to update it to indicate priority
            createdAt: Value(DateTime.now()),
          ),
          mode: InsertMode.replace,
        );

    return JioSaavnSourcedTrack(
      ref: ref,
      siblings: newSiblings,
      sources: source!,
      info: newSourceInfo,
      query: query,
      source: AudioSource.jiosaavn,
    );
  }

  @override
  Future<SourcedTrack> refreshStream() async {
    // There's no need to refresh the stream for JioSaavnSourcedTrack
    return this;
  }
}
