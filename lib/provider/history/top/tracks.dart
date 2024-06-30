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
            tbl.createdAt.isBiggerOrEqualValue(
              DateTime.now().subtract(arg.duration),
            ),
      );
  }

  @override
  fetch(arg, offset, limit) async {
    final tracksQuery = createTracksQuery()..limit(limit, offset: offset);

    return getTracksWithCount(await tracksQuery.get());
  }

  @override
  build(arg) async {
    final tracks = await fetch(arg, 0, 20);

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
      offset: tracks.length,
      limit: 20,
      hasMore: true,
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
