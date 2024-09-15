import 'package:collection/collection.dart';
import 'package:drift/drift.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/models/database/database.dart';
import 'package:spotube/provider/database/database.dart';
import 'package:spotube/provider/history/top.dart';
import 'package:spotube/provider/spotify/spotify.dart';

typedef PlaybackHistoryTrack = ({int count, Track track});
typedef PlaybackHistoryArtist = ({int count, Artist artist});

class HistoryTopTracksState extends PaginatedState<PlaybackHistoryTrack> {
  HistoryTopTracksState({
    required super.items,
    required super.offset,
    required super.limit,
    required super.hasMore,
  });

  List<PlaybackHistoryArtist> get artists {
    return getArtistsWithCount(
      items.expand((e) => e.track.artists ?? <Artist>[]),
    );
  }

  List<PlaybackHistoryArtist> getArtistsWithCount(Iterable<Artist> artists) {
    return groupBy(artists, (artist) => artist.id!)
        .entries
        .map((entry) {
          return (count: entry.value.length, artist: entry.value.first);
        })
        .sorted((a, b) => b.count.compareTo(a.count))
        .toList();
  }

  @override
  HistoryTopTracksState copyWith({
    List<PlaybackHistoryTrack>? items,
    int? offset,
    int? limit,
    bool? hasMore,
  }) {
    return HistoryTopTracksState(
      items: items ?? this.items,
      offset: offset ?? this.offset,
      limit: limit ?? this.limit,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

class HistoryTopTracksNotifier extends FamilyPaginatedAsyncNotifier<
    PlaybackHistoryTrack, HistoryTopTracksState, HistoryDuration> {
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

  @override
  fetch(arg, offset, limit) async {
    final tracksQuery = createTracksQuery()..limit(limit, offset: offset);

    final items = getTracksWithCount(await tracksQuery.get());

    return (
      items: items,
      hasMore: items.length == limit,
      nextOffset: offset + limit,
    );
  }

  @override
  build(arg) async {
    final (items: tracks, :hasMore, :nextOffset) = await fetch(arg, 0, 20);

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

    return HistoryTopTracksState(
      items: tracks,
      offset: nextOffset,
      limit: 20,
      hasMore: hasMore,
    );
  }

  List<PlaybackHistoryTrack> getTracksWithCount(List<HistoryTableData> tracks) {
    return groupBy(
      tracks,
      (track) => track.track!.id!,
    )
        .entries
        .map((entry) {
          return (count: entry.value.length, track: entry.value.first.track!);
        })
        .sorted((a, b) => b.count.compareTo(a.count))
        .toList();
  }
}

final historyTopTracksProvider = AsyncNotifierProviderFamily<
    HistoryTopTracksNotifier, HistoryTopTracksState, HistoryDuration>(
  () => HistoryTopTracksNotifier(),
);
