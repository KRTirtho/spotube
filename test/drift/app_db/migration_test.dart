// ignore_for_file: unused_local_variable, unused_import
import 'package:drift/drift.dart';
import 'package:drift_dev/api/migrations.dart';
import 'package:spotube/models/database/database.dart';
import 'package:test/test.dart';
import 'generated/schema.dart';

import 'generated/schema_v1.dart' as v1;
import 'generated/schema_v2.dart' as v2;

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late SchemaVerifier verifier;

  setUpAll(() {
    verifier = SchemaVerifier(GeneratedHelper());
  });

  group('simple database migrations', () {
    // These simple tests verify all possible schema updates with a simple (no
    // data) migration. This is a quick way to ensure that written database
    // migrations properly alter the schema.
    final versions = GeneratedHelper.versions;
    for (final (i, fromVersion) in versions.indexed) {
      group('from $fromVersion', () {
        for (final toVersion in versions.skip(i + 1)) {
          test('to $toVersion', () async {
            final schema = await verifier.schemaAt(fromVersion);
            final db = Database(schema.newConnection());
            await verifier.migrateAndValidate(db, toVersion);
            await db.close();
          });
        }
      });
    }
  });

  // Simple tests ensure the schema is transformed correctly, but some
  // migrations benefit from a test verifying that data is transformed correctly
  // too. This is particularly true for migrations that change existing columns
  // (e.g. altering their type or constraints). Migrations that only add tables
  // or columns typically don't need these advanced tests.
  // TODO: Check whether you have migrations that could benefit from these tests
  // and adapt this example to your database if necessary:
  test("migration from v1 to v2 does not corrupt data", () async {
    // Add data to insert into the old database, and the expected rows after the
    // migration.
    final oldAuthenticationTableData = <v1.AuthenticationTableData>[];
    final expectedNewAuthenticationTableData = <v2.AuthenticationTableData>[];

    final oldBlacklistTableData = <v1.BlacklistTableData>[];
    final expectedNewBlacklistTableData = <v2.BlacklistTableData>[];

    final oldPreferencesTableData = <v1.PreferencesTableData>[];
    final expectedNewPreferencesTableData = <v2.PreferencesTableData>[];

    final oldScrobblerTableData = <v1.ScrobblerTableData>[];
    final expectedNewScrobblerTableData = <v2.ScrobblerTableData>[];

    final oldSkipSegmentTableData = <v1.SkipSegmentTableData>[];
    final expectedNewSkipSegmentTableData = <v2.SkipSegmentTableData>[];

    final oldSourceMatchTableData = <v1.SourceMatchTableData>[];
    final expectedNewSourceMatchTableData = <v2.SourceMatchTableData>[];

    final oldAudioPlayerStateTableData = <v1.AudioPlayerStateTableData>[];
    final expectedNewAudioPlayerStateTableData =
        <v2.AudioPlayerStateTableData>[];

    final oldPlaylistTableData = <v1.PlaylistTableData>[];
    final expectedNewPlaylistTableData = <v2.PlaylistTableData>[];

    final oldPlaylistMediaTableData = <v1.PlaylistMediaTableData>[];
    final expectedNewPlaylistMediaTableData = <v2.PlaylistMediaTableData>[];

    final oldHistoryTableData = <v1.HistoryTableData>[];
    final expectedNewHistoryTableData = <v2.HistoryTableData>[];

    final oldLyricsTableData = <v1.LyricsTableData>[];
    final expectedNewLyricsTableData = <v2.LyricsTableData>[];

    await verifier.testWithDataIntegrity(
      oldVersion: 1,
      newVersion: 2,
      createOld: v1.DatabaseAtV1.new,
      createNew: v2.DatabaseAtV2.new,
      openTestedDatabase: (x) => AppDatabase(),
      createItems: (batch, oldDb) {
        batch.insertAll(oldDb.authenticationTable, oldAuthenticationTableData);
        batch.insertAll(oldDb.blacklistTable, oldBlacklistTableData);
        batch.insertAll(oldDb.preferencesTable, oldPreferencesTableData);
        batch.insertAll(oldDb.scrobblerTable, oldScrobblerTableData);
        batch.insertAll(oldDb.skipSegmentTable, oldSkipSegmentTableData);
        batch.insertAll(oldDb.sourceMatchTable, oldSourceMatchTableData);
        batch.insertAll(
            oldDb.audioPlayerStateTable, oldAudioPlayerStateTableData);
        batch.insertAll(oldDb.playlistTable, oldPlaylistTableData);
        batch.insertAll(oldDb.playlistMediaTable, oldPlaylistMediaTableData);
        batch.insertAll(oldDb.historyTable, oldHistoryTableData);
        batch.insertAll(oldDb.lyricsTable, oldLyricsTableData);
      },
      validateItems: (newDb) async {
        expect(expectedNewAuthenticationTableData,
            await newDb.select(newDb.authenticationTable).get());
        expect(expectedNewBlacklistTableData,
            await newDb.select(newDb.blacklistTable).get());
        expect(expectedNewPreferencesTableData,
            await newDb.select(newDb.preferencesTable).get());
        expect(expectedNewScrobblerTableData,
            await newDb.select(newDb.scrobblerTable).get());
        expect(expectedNewSkipSegmentTableData,
            await newDb.select(newDb.skipSegmentTable).get());
        expect(expectedNewSourceMatchTableData,
            await newDb.select(newDb.sourceMatchTable).get());
        expect(expectedNewAudioPlayerStateTableData,
            await newDb.select(newDb.audioPlayerStateTable).get());
        expect(expectedNewPlaylistTableData,
            await newDb.select(newDb.playlistTable).get());
        expect(expectedNewPlaylistMediaTableData,
            await newDb.select(newDb.playlistMediaTable).get());
        expect(expectedNewHistoryTableData,
            await newDb.select(newDb.historyTable).get());
        expect(expectedNewLyricsTableData,
            await newDb.select(newDb.lyricsTable).get());
      },
    );
  });
}
