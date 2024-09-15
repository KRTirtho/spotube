import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:drift/drift.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/provider/database/database.dart';
import 'package:spotube/provider/history/top.dart';
import 'package:spotube/provider/spotify/spotify.dart';

typedef PlaybackHistoryAlbum = ({int count, AlbumSimple album});

class HistoryTopAlbumsState extends PaginatedState<PlaybackHistoryAlbum> {
  HistoryTopAlbumsState({
    required super.items,
    required super.offset,
    required super.limit,
    required super.hasMore,
  });

  @override
  HistoryTopAlbumsState copyWith({
    List<PlaybackHistoryAlbum>? items,
    int? offset,
    int? limit,
    bool? hasMore,
  }) {
    return HistoryTopAlbumsState(
      items: items ?? this.items,
      offset: offset ?? this.offset,
      limit: limit ?? this.limit,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

class HistoryTopAlbumsNotifier extends FamilyPaginatedAsyncNotifier<
    PlaybackHistoryAlbum, HistoryTopAlbumsState, HistoryDuration> {
  HistoryTopAlbumsNotifier() : super();

  Selectable<AlbumSimple> createAlbumsQuery({int? limit, int? offset}) {
    final database = ref.read(databaseProvider);

    final duration = switch (arg) {
      HistoryDuration.allTime => '0',
      HistoryDuration.days7 => "strftime('%s', 'now', 'weekday 0', '-7 days')",
      HistoryDuration.days30 => "strftime('%s', 'now', 'start of month')",
      HistoryDuration.months6 =>
        "strftime('%s', date('now', '-5 months', 'start of month'))",
      HistoryDuration.year => "strftime('%s', date('now', 'start of year'))",
      HistoryDuration.years2 =>
        "strftime('%s', date('now', '-1 years', 'start of year'))",
    };

    return database.customSelect(
      """
        SELECT 
            history_table.created_at,
      """
      r"""
            json_extract(history_table.data, '$.album') as data,
            json_extract(history_table.data, '$.album.id') as item_id,
            'album' as type
        """
      """
        FROM history_table 
        WHERE type = 'track' AND
              created_at >= $duration
        UNION ALL
        SELECT
            history_table.created_at,
            history_table.data,
            history_table.item_id,
            history_table.type
        FROM history_table
        WHERE type = 'album' AND
              created_at >= $duration
        ORDER BY created_at desc
        ${limit != null && offset != null ? 'LIMIT $limit OFFSET $offset' : ''}
      """,
      readsFrom: {database.historyTable},
    ).map((row) {
      final data = row.read<String>('data');
      final album = AlbumSimple.fromJson(jsonDecode(data));
      return album;
    });
  }

  @override
  fetch(arg, offset, limit) async {
    final albumsQuery = createAlbumsQuery(limit: limit, offset: offset);

    final items = getAlbumsWithCount(await albumsQuery.get());

    return (
      items: items,
      hasMore: items.length == limit,
      nextOffset: offset + limit,
    );
  }

  @override
  build(arg) async {
    final (items: albums, :hasMore, :nextOffset) = await fetch(arg, 0, 20);

    final subscription = createAlbumsQuery().watch().listen((event) {
      if (state.asData == null) return;
      state = AsyncData(state.asData!.value.copyWith(
        items: getAlbumsWithCount(event),
        hasMore: false,
      ));
    });

    ref.onDispose(() {
      subscription.cancel();
    });

    return HistoryTopAlbumsState(
      items: albums,
      offset: nextOffset,
      limit: 20,
      hasMore: hasMore,
    );
  }

  List<PlaybackHistoryAlbum> getAlbumsWithCount(
    List<AlbumSimple> albumsWithTrackAlbums,
  ) {
    return groupBy(albumsWithTrackAlbums, (album) => album.id!)
        .entries
        .map((entry) {
          return (count: entry.value.length, album: entry.value.first);
        })
        .sorted((a, b) => b.count.compareTo(a.count))
        .toList();
  }
}

final historyTopAlbumsProvider = AsyncNotifierProviderFamily<
    HistoryTopAlbumsNotifier, HistoryTopAlbumsState, HistoryDuration>(
  () => HistoryTopAlbumsNotifier(),
);
