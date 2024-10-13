import 'package:collection/collection.dart';
import 'package:drift/drift.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/models/database/database.dart';
import 'package:spotube/provider/database/database.dart';

class RecentlyPlayedItemNotifier extends AsyncNotifier<List<HistoryTableData>> {
  @override
  build() async {
    final database = ref.watch(databaseProvider);

    final uniqueItemIds = await (database.selectOnly(
      database.historyTable,
      distinct: true,
    )
          ..addColumns([database.historyTable.itemId, database.historyTable.id])
          ..where(
            database.historyTable.type.isInValues([
              HistoryEntryType.playlist,
              HistoryEntryType.album,
            ]),
          )
          ..limit(10)
          ..orderBy([
            OrderingTerm(
              expression: database.historyTable.createdAt,
              mode: OrderingMode.desc,
            ),
          ]))
        .map(
          (row) => row.read(database.historyTable.id),
        )
        .get()
        .then((value) => value.whereNotNull().toList());

    final query = database.select(database.historyTable)
      ..where(
        (tbl) => tbl.id.isIn(uniqueItemIds),
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

    final items = await query.get();

    return items;
  }
}

final recentlyPlayedItems =
    AsyncNotifierProvider<RecentlyPlayedItemNotifier, List<HistoryTableData>>(
  () => RecentlyPlayedItemNotifier(),
);
