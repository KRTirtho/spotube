import 'package:collection/collection.dart';
import 'package:drift/drift.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/models/database/database.dart';
import 'package:spotube/provider/database/database.dart';

class RecentlyPlayedItemNotifier extends AsyncNotifier<List<HistoryTableData>> {
  @override
  build() async {
    final database = ref.watch(databaseProvider);

    final uniqueItemIds =
        await (database.selectOnly(database.historyTable, distinct: true)
              ..addColumns([database.historyTable.itemId])
              ..where(
                database.historyTable.type.isIn([
                  HistoryEntryType.playlist.name,
                  HistoryEntryType.album.name,
                ]),
              )
              ..limit(10))
            .map((row) => row.read(database.historyTable.itemId))
            .get()
            .then((value) => value.whereNotNull().toList());

    final query = database.select(database.historyTable)
      ..where(
        (tbl) =>
            tbl.type.isIn([
              HistoryEntryType.playlist.name,
              HistoryEntryType.album.name,
            ]) &
            tbl.itemId.isIn(uniqueItemIds),
      )
      ..orderBy([
        (tbl) => OrderingTerm(
              expression: tbl.createdAt,
              mode: OrderingMode.desc,
            ),
      ]);

    final subscription = query.watch().listen((event) {
      state = AsyncData(event);
    });

    ref.onDispose(() => subscription.cancel());

    return await query.get();
  }
}

final recentlyPlayedItems =
    AsyncNotifierProvider<RecentlyPlayedItemNotifier, List<HistoryTableData>>(
  () => RecentlyPlayedItemNotifier(),
);
