library database;

import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:encrypt/encrypt.dart';
import 'package:media_kit/media_kit.dart' hide Track;
import 'package:shadcn_flutter/shadcn_flutter.dart' show ThemeMode, Colors;
import 'package:spotube/platform/spotify/spotify.dart';
import 'package:spotube/models/database/database.steps.dart';
import 'package:spotube/models/lyrics.dart';
import 'package:spotube/services/kv_store/encrypted_kv_store.dart';
import 'package:spotube/services/kv_store/kv_store.dart';
import 'package:spotube/services/sourced_track/enums.dart';
import 'package:flutter/widgets.dart' hide Table, Key, View;
import 'package:spotube/modules/settings/color_scheme_picker_dialog.dart';
import 'package:spotube/services/youtube_engine/newpipe_engine.dart';
import 'package:spotube/services/youtube_engine/youtube_explode_engine.dart';
import 'package:spotube/services/youtube_engine/yt_dlp_engine.dart';

// Conditional import para diferentes plataformas
import 'connection_native.dart'
    if (dart.library.html) 'connection_web.dart';

part 'database.g.dart';

part 'tables/authentication.dart';
part 'tables/blacklist.dart';
part 'tables/preferences.dart';
part 'tables/scrobbler.dart';
part 'tables/skip_segment.dart';
part 'tables/source_match.dart';
part 'tables/audio_player_state.dart';
part 'tables/history.dart';
part 'tables/lyrics.dart';

part 'typeconverters/color.dart';
part 'typeconverters/locale.dart';
part 'typeconverters/string_list.dart';
part 'typeconverters/encrypted_text.dart';
part 'typeconverters/map.dart';
part 'typeconverters/subtitle.dart';

@DriftDatabase(
  tables: [
    AuthenticationTable,
    BlacklistTable,
    PreferencesTable,
    ScrobblerTable,
    SkipSegmentTable,
    SourceMatchTable,
    AudioPlayerStateTable,
    PlaylistTable,
    PlaylistMediaTable,
    HistoryTable,
    LyricsTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onUpgrade: stepByStep(
        from1To2: (m, schema) async {
          // Add invidiousInstance column to preferences table
          await m.addColumn(
            schema.preferencesTable,
            schema.preferencesTable.invidiousInstance,
          );
        },
        from2To3: (m, schema) async {
          await m.addColumn(
            schema.preferencesTable,
            schema.preferencesTable.cacheMusic,
          );
        },
        from3To4: (m, schema) async {
          await m.addColumn(
            schema.preferencesTable,
            schema.preferencesTable.youtubeClientEngine,
          );
        },
        from4To5: (m, schema) async {
          final columnName = schema.preferencesTable.accentColorScheme
              .escapedNameFor(SqlDialect.sqlite);
          final columnNameOld =
              '"${schema.preferencesTable.accentColorScheme.name}_old"';
          final tableName = schema.preferencesTable.actualTableName;
          await customStatement(
            "ALTER TABLE $tableName "
            "RENAME COLUMN $columnName to $columnNameOld",
          );
          await customStatement(
            "ALTER TABLE $tableName "
            "ADD COLUMN $columnName TEXT NOT NULL DEFAULT 'Orange:0xFFf97315'",
          );
          await customStatement(
            "UPDATE $tableName "
            "SET $columnName = $columnNameOld",
          );
          await customStatement(
            "ALTER TABLE $tableName "
            "DROP COLUMN $columnNameOld",
          );
          await customStatement(
            "UPDATE $tableName "
            "SET $columnName = 'Orange:0xFFf97315' WHERE $columnName = 'Blue:0xFF2196F3'",
          );
        },
        from5To6: (m, schema) async {
          // Add new column to preferences table
          await m.addColumn(
            schema.preferencesTable,
            schema.preferencesTable.connectPort,
          );
        },
      ),
    );
  }
}

DatabaseConnection _openConnection() {
  return connect();
}
