import 'package:collection/collection.dart';
import 'package:drift/drift.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/models/database/database.dart';
import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/provider/database/database.dart';
import 'package:spotube/provider/history/top.dart';
import 'package:spotube/provider/metadata_plugin/artist/artist.dart';
import 'package:spotube/provider/metadata_plugin/utils/family_paginated.dart';

typedef PlaybackHistoryTrack = ({int count, SpotubeTrackObject track});
typedef PlaybackHistoryArtist = ({int count, SpotubeSimpleArtistObject artist});

class HistoryTopTracksNotifier extends FamilyPaginatedAsyncNotifier<
    PlaybackHistoryTrack, HistoryDuration> {
  HistoryTopTracksNotifier() : super();

  SimpleSelectStatement<$HistoryTableTable, HistoryTableData>
      createTracksQuery() {
    final database = ref.read(databaseProvider);

    return database.select(database.historyTable)
      ..where(
        (tbl) =>
            tbl.type.equalsValue(HistoryEntryType.track) &
            tbl.createdAt.isBiggerOrEqualValue(switch (arg) {
              HistoryDuration.allTime => DateTime(1970),
              // from start of the week
              HistoryDuration.days7 => DateTime.now()
                  .subtract(Duration(days: DateTime.now().weekday - 1)),
              // from start of the month
              HistoryDuration.days30 =>
                DateTime.now().subtract(Duration(days: DateTime.now().day - 1)),
              // from start of the 6th month
              HistoryDuration.months6 => DateTime.now()
                  .subtract(Duration(days: DateTime.now().day - 1))
                  .subtract(const Duration(days: 30 * 6)),
              // from start of the year
              HistoryDuration.year => DateTime.now()
                  .subtract(Duration(days: DateTime.now().day - 1))
                  .subtract(const Duration(days: 30 * 12)),
              HistoryDuration.years2 => DateTime.now()
                  .subtract(Duration(days: DateTime.now().day - 1))
                  .subtract(const Duration(days: 30 * 12 * 2)),
            }),
      );
  }

  Future<void> fixImageNotLoadingForArtistIssue(
    List<HistoryTableData> entries,
  ) async {
    final nonImageArtistTracks =
        entries.where((e) => e.track!.artists.any((a) => a.images == null));

    if (nonImageArtistTracks.isEmpty) return;

    final artistIds = nonImageArtistTracks
        .map((e) => e.track!.artists.map((a) => a.id))
        .expand((e) => e)
        .toSet()
        .toList();

    if (artistIds.isEmpty) return;

    final artists = await Future.wait([
      for (final id in artistIds)
        ref.read(metadataPluginArtistProvider(id).future),
    ]);

    final imagedArtistTracks = nonImageArtistTracks.map((e) {
      var track = e.track!;
      final includedArtists = track.artists
          .map((a) {
            final fullArtist =
                artists.firstWhereOrNull((artist) => artist.id == a.id);

            return fullArtist != null
                ? a.copyWith(images: fullArtist.images)
                : a;
          })
          .nonNulls
          .toList();

      track = track.copyWith(artists: includedArtists);

      return e.copyWith(data: track.toJson());
    });

    assert(
      imagedArtistTracks
          .every((e) => e.track!.artists.every((a) => a.images != null)),
      'Tracks artists should have images',
    );

    final database = ref.read(databaseProvider);
    await database.batch((batch) {
      batch.insertAllOnConflictUpdate(
        database.historyTable,
        imagedArtistTracks,
      );
    });
  }

  @override
  fetch(offset, limit) async {
    final tracksQuery = createTracksQuery()..limit(limit, offset: offset);

    final entries = await tracksQuery.get();

    final items = getTracksWithCount(entries);

    return SpotubePaginationResponseObject<PlaybackHistoryTrack>(
      items: items,
      nextOffset: offset + limit,
      total: items.length,
      limit: limit,
      hasMore: items.length == limit,
    );
  }

  @override
  build(arg) async {
    final subscription = createTracksQuery().watch().listen((event) {
      if (state.asData == null) return;
      state = AsyncData(state.asData!.value.copyWith(
        items: getTracksWithCount(event),
        hasMore: false,
      ));
    });

    ref.onDispose(() {
      subscription.cancel();
    });

    return await fetch(0, 20);
  }

  List<PlaybackHistoryArtist> get artists {
    return getArtistsWithCount(
      state.asData?.value.items.expand((e) => e.track.artists) ?? [],
    );
  }

  List<PlaybackHistoryArtist> getArtistsWithCount(
    Iterable<SpotubeSimpleArtistObject> artists,
  ) {
    return groupBy(artists, (artist) => artist.id)
        .entries
        .map((entry) {
          return (
            count: entry.value.length,

            /// Previously, due to a bug, artist images were not being saved.
            /// Now it's fixed, but we need to handle the case where images are null.
            /// So we take the first artist with images if available, otherwise the first one.
            artist: entry.value.firstWhereOrNull((a) => a.images != null) ??
                entry.value.first,
          );
        })
        .sorted((a, b) => b.count.compareTo(a.count))
        .toList();
  }

  List<PlaybackHistoryTrack> getTracksWithCount(List<HistoryTableData> tracks) {
    fixImageNotLoadingForArtistIssue(tracks);

    return groupBy(
      tracks,
      (track) => track.track!.id,
    )
        .entries
        .map((entry) {
          return (
            count: entry.value.length,

            /// Previously, due to a bug, artist images were not being saved.
            /// Now it's fixed, but we need to handle the case where images are null.
            /// So we take the first artist with images if available, otherwise the first one.
            track: entry.value
                    .firstWhereOrNull(
                        (t) => t.track!.artists.every((a) => a.images != null))
                    ?.track! ??
                entry.value.first.track!,
          );
        })
        .sorted((a, b) => b.count.compareTo(a.count))
        .toList();
  }
}

final historyTopTracksProvider = AsyncNotifierProviderFamily<
    HistoryTopTracksNotifier,
    SpotubePaginationResponseObject<PlaybackHistoryTrack>,
    HistoryDuration>(
  () => HistoryTopTracksNotifier(),
);
