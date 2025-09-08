import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:spotube/models/database/database.dart';
import 'package:spotube/provider/database/database.dart';

class RecentlyPlayedItemNotifier extends AsyncNotifier<List<HistoryTableData>> {
  @override
  build() async {
    final database = ref.watch(databaseProvider);

    final query = database.customSelect(
      """
      WITH RankedHistory AS (
        SELECT *, ROW_NUMBER() OVER (PARTITION BY item_id ORDER BY created_at DESC) AS rn
        FROM history_table
        WHERE type in ('playlist', 'album')
      )
      SELECT *
      FROM RankedHistory
      WHERE rn = 1
      ORDER BY created_at DESC
      LIMIT 10
      """,
      readsFrom: {database.historyTable},
    ).map((rows) async {
      return await rows.map((row) {
        final type = row.read<String>('type');
        return HistoryTableData(
          id: row.read<int>('id'),
          itemId: row.read<String>('item_id'),
          type: HistoryEntryType.values.firstWhere((e) => e.name == type),
          createdAt: row.read<DateTime>('created_at'),
          data: jsonDecode(row.read<String>('data')) as Map<String, dynamic>,
        );
      });
    });

    final subscription = query.watch().listen((event) async {
      state = AsyncData(await Future.wait(event));
    });

    ref.onDispose(() => subscription.cancel());

    final items = await Future.wait(await query.get());

    return items;
  }
}

final recentlyPlayedItems =
    AsyncNotifierProvider<RecentlyPlayedItemNotifier, List<HistoryTableData>>(
  () => RecentlyPlayedItemNotifier(),
);
