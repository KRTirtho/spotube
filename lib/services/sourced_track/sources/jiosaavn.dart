import 'package:collection/collection.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/models/database/database.dart';
import 'package:spotube/provider/database/database.dart';
import 'package:spotube/services/sourced_track/enums.dart';
import 'package:spotube/services/sourced_track/exceptions.dart';
import 'package:spotube/services/sourced_track/models/source_info.dart';
import 'package:spotube/services/sourced_track/models/source_map.dart';
import 'package:spotube/services/sourced_track/sourced_track.dart';
import 'package:jiosaavn/jiosaavn.dart';
import 'package:spotube/extensions/string.dart';

final jiosaavnClient = JioSaavnClient();

class JioSaavnSourceInfo extends SourceInfo {
  JioSaavnSourceInfo({
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

class JioSaavnSourcedTrack extends SourcedTrack {
  JioSaavnSourcedTrack({
    required super.ref,
    required super.source,
    required super.siblings,
    required super.sourceInfo,
    required super.track,
  });

  static Future<SourcedTrack> fetchFromTrack({
    required Track track,
    required Ref ref,
    bool weakMatch = false,
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

    if (cachedSource == null ||
        cachedSource.sourceType != SourceType.jiosaavn) {
      final siblings =
          await fetchSiblings(ref: ref, track: track, weakMatch: weakMatch);

      if (siblings.isEmpty) {
        throw TrackNotFoundError(track);
      }

      await database.into(database.sourceMatchTable).insert(
            SourceMatchTableCompanion.insert(
              trackId: track.id!,
              sourceId: siblings.first.info.id,
              sourceType: const Value(SourceType.jiosaavn),
            ),
          );

      return JioSaavnSourcedTrack(
        ref: ref,
        siblings: siblings.map((s) => s.info).skip(1).toList(),
        source: siblings.first.source!,
        sourceInfo: siblings.first.info,
        track: track,
      );
    }

    final [item] =
        await jiosaavnClient.songs.detailsById([cachedSource.sourceId]);

    final (:info, :source) = toSiblingType(item);

    return JioSaavnSourcedTrack(
      ref: ref,
      siblings: [],
      source: source!,
      sourceInfo: info,
      track: track,
    );
  }

  static SiblingType toSiblingType(SongResponse result) {
    final SiblingType sibling = (
      info: JioSaavnSourceInfo(
        artist: [
          result.primaryArtists,
          if (result.featuredArtists.isNotEmpty) ", ",
          result.featuredArtists
        ].join("").unescapeHtml(),
        artistUrl:
            "https://www.jiosaavn.com/artist/${result.primaryArtistsId.split(",").firstOrNull ?? ""}",
        duration: Duration(seconds: int.parse(result.duration)),
        id: result.id,
        pageUrl: result.url,
        thumbnail: result.image?.last.link ?? "",
        title: result.name!.unescapeHtml(),
        album: result.album.name,
      ),
      source: SourceMap(
        m4a: SourceQualityMap(
          high: result.downloadUrl!
              .firstWhere((element) => element.quality == "320kbps")
              .link,
          medium: result.downloadUrl!
              .firstWhere((element) => element.quality == "160kbps")
              .link,
          low: result.downloadUrl!
              .firstWhere((element) => element.quality == "96kbps")
              .link,
        ),
      ),
    );

    return sibling;
  }

  static Future<List<SiblingType>> fetchSiblings({
    required Track track,
    required Ref ref,
    bool weakMatch = false,
  }) async {
    final query = SourcedTrack.getSearchTerm(track);

    final SongSearchResponse(:results) =
        await jiosaavnClient.search.songs(query, limit: 20);

    final trackArtistNames = track.artists?.map((ar) => ar.name).toList();

    final matchedResults = results
        .where(
          (s) {
            s.name?.unescapeHtml().contains(track.name!) ?? false;

            final sameName = s.name?.unescapeHtml() == track.name;
            final artistNames = [
              s.primaryArtists,
              if (s.featuredArtists.isNotEmpty) ", ",
              s.featuredArtists
            ].join("").unescapeHtml();
            final sameArtists = artistNames.split(", ").any(
                  (artist) =>
                      trackArtistNames?.any((ar) => artist == ar) ?? false,
                );
            if (weakMatch) {
              final containsName =
                  s.name?.unescapeHtml().contains(track.name!) ?? false;
              final containsPrimaryArtist = s.primaryArtists
                  .unescapeHtml()
                  .contains(trackArtistNames?.first ?? "");

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
    final fetchedSiblings = await fetchSiblings(ref: ref, track: this);

    return JioSaavnSourcedTrack(
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
  Future<JioSaavnSourcedTrack?> swapWithSibling(SourceInfo sibling) async {
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

    final [item] = await jiosaavnClient.songs.detailsById([newSourceInfo.id]);

    final (:info, :source) = toSiblingType(item);

    final database = ref.read(databaseProvider);
    await database.into(database.sourceMatchTable).insert(
          SourceMatchTableCompanion.insert(
            trackId: id!,
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
      source: source!,
      sourceInfo: info,
      track: this,
    );
  }
}
