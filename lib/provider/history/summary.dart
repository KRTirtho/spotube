import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:drift/extensions/json1.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/models/database/database.dart';
import 'package:spotube/provider/database/database.dart';

class PlaybackHistorySummary {
  final Duration duration;
  final int tracks;
  final int artists;
  final double fees;
  final int albums;
  final int playlists;

  const PlaybackHistorySummary({
    required this.duration,
    required this.tracks,
    required this.artists,
    required this.fees,
    required this.albums,
    required this.playlists,
  });

  PlaybackHistorySummary copyWith({
    Duration? duration,
    int? tracks,
    int? artists,
    double? fees,
    int? albums,
    int? playlists,
  }) {
    return PlaybackHistorySummary(
      duration: duration ?? this.duration,
      tracks: tracks ?? this.tracks,
      artists: artists ?? this.artists,
      fees: fees ?? this.fees,
      albums: albums ?? this.albums,
      playlists: playlists ?? this.playlists,
    );
  }
}

class PlaybackHistorySummaryNotifier
    extends AsyncNotifier<PlaybackHistorySummary> {
  @override
  build() async {
    final database = ref.watch(databaseProvider);

    final uniqItemIdCountingCol =
        database.historyTable.itemId.count(distinct: true);
    final itemIdCountingCol = database.historyTable.itemId.count();
    final durationSumJsonColumn =
        database.historyTable.data.jsonExtract<int>(r"$.durationMs").sum();
    final artistCountingCol =
        database.historyTable.data.jsonExtract<String>(r"$.artists");

    final totalTracksListenedQuery = (database.selectOnly(database.historyTable)
          ..addColumns([uniqItemIdCountingCol])
          ..where(
              database.historyTable.type.equals(HistoryEntryType.track.name)))
        .map((row) => row.read(uniqItemIdCountingCol));

    final totalDurationListenedQuery = (database
            .selectOnly(database.historyTable)
          ..addColumns([durationSumJsonColumn])
          ..where(
              database.historyTable.type.equals(HistoryEntryType.track.name)))
        .map(
      (row) => Duration(milliseconds: row.read(durationSumJsonColumn) ?? 0),
    );

    final totalArtistsListenedQuery =
        (database.selectOnly(database.historyTable)
              ..addColumns([artistCountingCol])
              ..where(
                database.historyTable.type.equals(HistoryEntryType.track.name),
              ))
            .map(
      (row) {
        final data = jsonDecode(row.read(artistCountingCol)!) as List;
        return data.map((e) => e['id'] as String).cast<String>().toList();
      },
    );

    final totalAlbumsListenedQuery = (database.selectOnly(database.historyTable)
          ..addColumns([uniqItemIdCountingCol])
          ..where(
              database.historyTable.type.equals(HistoryEntryType.album.name)))
        .map((row) => row.read(uniqItemIdCountingCol));

    final totalPlaylistsListenedQuery =
        (database.selectOnly(database.historyTable)
              ..addColumns([uniqItemIdCountingCol])
              ..where(
                database.historyTable.type
                    .equals(HistoryEntryType.playlist.name),
              ))
            .map((row) => row.read(uniqItemIdCountingCol));

    final oldestDate = DateTime.now().copyWith(day: 1, hour: 0, minute: 0);
    final newestDate = DateTime.now().copyWith(day: 30, hour: 23, minute: 59);
    final totalTracksListenedThisMonthQuery =
        (database.selectOnly(database.historyTable)
              ..addColumns([itemIdCountingCol])
              ..where(
                database.historyTable.type.equals(
                      HistoryEntryType.track.name,
                    ) &
                    database.historyTable.createdAt
                        .isBetweenValues(oldestDate, newestDate),
              ))
            .map((row) => row.read(itemIdCountingCol));

    final subscriptions = <StreamSubscription>[
      totalTracksListenedQuery.watchSingle().listen((event) {
        if (event == null || state.asData == null) return;
        state = AsyncData(state.asData!.value.copyWith(
          tracks: event,
        ));
      }),
      totalDurationListenedQuery.watchSingle().listen((event) {
        if (state.asData == null) return;
        state = AsyncData(state.asData!.value.copyWith(
          duration: event,
        ));
      }),
      totalArtistsListenedQuery.watch().listen((event) {
        if (state.asData == null) return;
        state = AsyncData(state.asData!.value.copyWith(
          artists: event.expand((e) => e).toSet().length,
        ));
      }),
      totalAlbumsListenedQuery.watchSingle().listen((event) {
        if (event == null || state.asData == null) return;
        state = AsyncData(state.asData!.value.copyWith(
          albums: event,
        ));
      }),
      totalPlaylistsListenedQuery.watchSingle().listen((event) {
        if (event == null || state.asData == null) return;
        state = AsyncData(state.asData!.value.copyWith(
          playlists: event,
        ));
      }),
      totalTracksListenedThisMonthQuery.watchSingle().listen((event) {
        if (event == null || state.asData == null) return;
        state = AsyncData(state.asData!.value.copyWith(
          fees: event * 0.005,
        ));
      }),
    ];

    ref.onDispose(() {
      for (final subscription in subscriptions) {
        subscription.cancel();
      }
    });

    return database.transaction(() async {
      final totalTracksListened =
          await totalTracksListenedQuery.getSingle() ?? 0;

      final totalDurationListened =
          await totalDurationListenedQuery.getSingle();

      final totalArtistsListened = await totalArtistsListenedQuery
          .get()
          .then((value) => value.expand((e) => e).toSet().length);

      final totalAlbumsListened =
          await totalAlbumsListenedQuery.getSingle() ?? 0;

      final totalPlaylistsListened =
          await totalPlaylistsListenedQuery.getSingle() ?? 0;

      final totalTracksListenedThisMonth =
          await totalTracksListenedThisMonthQuery.getSingle() ?? 0;

      return PlaybackHistorySummary(
        duration: totalDurationListened,
        tracks: totalTracksListened,
        artists: totalArtistsListened,
        fees: totalTracksListenedThisMonth * 0.005,
        albums: totalAlbumsListened,
        playlists: totalPlaylistsListened,
      );
    });
  }
}

final playbackHistorySummaryProvider = AsyncNotifierProvider<
    PlaybackHistorySummaryNotifier, PlaybackHistorySummary>(
  () => PlaybackHistorySummaryNotifier(),
);
