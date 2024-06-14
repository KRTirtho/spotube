library database;

import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/services/sourced_track/enums.dart';
import 'package:flutter/material.dart' hide Table;
import 'package:spotube/modules/settings/color_scheme_picker_dialog.dart';
import 'package:drift/native.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

part 'database.g.dart';

part 'tables/preferences.dart';
part 'tables/source_match.dart';
part 'tables/skip_segment.dart';

part 'typeconverters/color.dart';
part 'typeconverters/locale.dart';
part 'typeconverters/string_list.dart';

@DriftDatabase(tables: [PreferencesTable, SourceMatchTable, SkipSegmentTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(join(dbFolder.path, 'db.sqlite'));

    // Also work around limitations on old Android versions
    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }

    // Make sqlite3 pick a more suitable location for temporary files - the
    // one from the system may be inaccessible due to sandboxing.
    final cacheBase = (await getTemporaryDirectory()).path;
    // We can't access /tmp on Android, which sqlite3 would try by default.
    // Explicitly tell it about the correct temporary directory.
    sqlite3.tempDirectory = cacheBase;

    return NativeDatabase.createInBackground(file);
  });
}
