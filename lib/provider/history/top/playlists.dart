import 'package:collection/collection.dart';
import 'package:drift/drift.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/models/database/database.dart';
import 'package:spotube/provider/database/database.dart';
import 'package:spotube/provider/history/top.dart';
import 'package:spotube/provider/spotify/spotify.dart';

typedef PlaybackHistoryPlaylist = ({int count, PlaylistSimple playlist});

class HistoryTopPlaylistsState extends PaginatedState<PlaybackHistoryPlaylist> {
  HistoryTopPlaylistsState({
    required super.items,
    required super.offset,
    required super.limit,
    required super.hasMore,
  });

  @override
  HistoryTopPlaylistsState copyWith({
    List<PlaybackHistoryPlaylist>? items,
    int? offset,
    int? limit,
    bool? hasMore,
  }) {
    return HistoryTopPlaylistsState(
      items: items ?? this.items,
      offset: offset ?? this.offset,
      limit: limit ?? this.limit,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

class HistoryTopPlaylistsNotifier extends FamilyPaginatedAsyncNotifier<
    PlaybackHistoryPlaylist, HistoryTopPlaylistsState, HistoryDuration> {
  HistoryTopPlaylistsNotifier() : super();

  SimpleSelectStatement<$HistoryTableTable, HistoryTableData>
      createPlaylistsQuery() {
    final database = ref.read(databaseProvider);

    return database.select(database.historyTable)
      ..where(
        (tbl) =>
            tbl.type.equalsValue(HistoryEntryType.playlist) &
            tbl.createdAt.isBiggerOrEqualValue(
              DateTime.now().subtract(arg.duration),
            ),
      );
  }

  @override
  fetch(arg, offset, limit) async {
    final playlistsQuery = createPlaylistsQuery()..limit(limit, offset: offset);

    final items = getPlaylistsWithCount(await playlistsQuery.get());

    return (
      items: items,
      hasMore: items.length == limit,
      nextOffset: offset + limit,
    );
  }

  @override
  build(arg) async {
    final (items: playlists, :hasMore, :nextOffset) = await fetch(arg, 0, 20);

    final subscription = createPlaylistsQuery().watch().listen((event) {
      if (state.asData == null) return;
      state = AsyncData(state.asData!.value.copyWith(
        items: getPlaylistsWithCount(event),
        hasMore: false,
      ));
    });

    ref.onDispose(() {
      subscription.cancel();
    });

    return HistoryTopPlaylistsState(
      items: playlists,
      offset: nextOffset,
      limit: 20,
      hasMore: hasMore,
    );
  }

  List<PlaybackHistoryPlaylist> getPlaylistsWithCount(
    List<HistoryTableData> playlists,
  ) {
    return groupBy(playlists, (playlist) => playlist.playlist!.id!)
        .entries
        .map((entry) {
          return (
            count: entry.value.length,
            playlist: entry.value.first.playlist!,
          );
        })
        .sorted((a, b) => b.count.compareTo(a.count))
        .toList();
  }
}

final historyTopPlaylistsProvider = AsyncNotifierProviderFamily<
    HistoryTopPlaylistsNotifier, HistoryTopPlaylistsState, HistoryDuration>(
  () => HistoryTopPlaylistsNotifier(),
);
