import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:spotube/models/database/database.dart'
    hide
        SourceType,
        AudioSource,
        CloseBehavior,
        MusicCodec,
        LayoutMode,
        SearchMode,
        BlacklistedType;
import 'package:spotube/models/database/database.dart' as db;
import 'package:spotube/services/kv_store/kv_store.dart';
import 'package:spotube/services/logger/logger.dart';
import 'package:spotube/utils/migrations/adapters.dart';
import 'package:spotube/utils/migrations/cache_box.dart';

late AppDatabase _database;

Future<String?> getHiveCacheDir() async =>
    kIsWeb ? null : (await getApplicationSupportDirectory()).path;

Future<void> migrateAuthenticationInfo() async {
  AppLogger.log.i("🔵 Migrating authentication info..");

  final box = PersistenceCacheBox<AuthenticationCredentials>(
    "authentication",
    encrypted: true,
    fromJson: (json) => AuthenticationCredentials.fromJson(json),
  );

  final credentials = await box.getData();

  if (credentials == null) return;

  await _database.into(_database.authenticationTable).insert(
        AuthenticationTableCompanion.insert(
          accessToken: DecryptedText(credentials.accessToken),
          cookie: DecryptedText(credentials.cookie),
          expiration: credentials.expiration,
          id: const Value(0),
        ),
        mode: InsertMode.insertOrReplace,
      );

  AppLogger.log.i("✅ Migrated authentication info");
}

Future<void> migratePreferences() async {
  AppLogger.log.i("🔵 Migrating preferences..");
  final box = PersistenceCacheBox<UserPreferences>(
    "preferences",
    fromJson: (json) => UserPreferences.fromJson(json),
  );

  final preferences = await box.getData();

  if (preferences == null) return;

  await _database.into(_database.preferencesTable).insert(
        PreferencesTableCompanion.insert(
          id: const Value(0),
          accentColorScheme: Value(preferences.accentColorScheme),
          albumColorSync: Value(preferences.albumColorSync),
          amoledDarkTheme: Value(preferences.amoledDarkTheme),
          audioQuality: Value(preferences.audioQuality),
          audioSource: Value(
            switch (preferences.audioSource) {
              AudioSource.youtube => db.AudioSource.youtube,
              AudioSource.piped => db.AudioSource.piped,
              AudioSource.jiosaavn => db.AudioSource.jiosaavn,
            },
          ),
          checkUpdate: Value(preferences.checkUpdate),
          closeBehavior: Value(
            switch (preferences.closeBehavior) {
              CloseBehavior.minimizeToTray => db.CloseBehavior.minimizeToTray,
              CloseBehavior.close => db.CloseBehavior.close,
            },
          ),
          discordPresence: Value(preferences.discordPresence),
          downloadLocation: Value(preferences.downloadLocation),
          downloadMusicCodec: Value(preferences.downloadMusicCodec),
          enableConnect: Value(preferences.enableConnect),
          endlessPlayback: Value(preferences.endlessPlayback),
          layoutMode: Value(
            switch (preferences.layoutMode) {
              LayoutMode.adaptive => db.LayoutMode.adaptive,
              LayoutMode.compact => db.LayoutMode.compact,
              LayoutMode.extended => db.LayoutMode.extended,
            },
          ),
          localLibraryLocation: Value(preferences.localLibraryLocation),
          locale: Value(preferences.locale),
          market: Value(preferences.recommendationMarket),
          normalizeAudio: Value(preferences.normalizeAudio),
          pipedInstance: Value(preferences.pipedInstance),
          searchMode: Value(
            switch (preferences.searchMode) {
              SearchMode.youtube => db.SearchMode.youtube,
              SearchMode.youtubeMusic => db.SearchMode.youtubeMusic,
            },
          ),
          showSystemTrayIcon: Value(preferences.showSystemTrayIcon),
          skipNonMusic: Value(preferences.skipNonMusic),
          streamMusicCodec: Value(preferences.streamMusicCodec),
          systemTitleBar: Value(preferences.systemTitleBar),
          themeMode: Value(preferences.themeMode),
        ),
        mode: InsertMode.replace,
      );

  AppLogger.log.i("✅ Migrated preferences");
}

Future<void> migrateSkipSegment() async {
  AppLogger.log.i("🔵 Migrating skip segments..");
  Hive.registerAdapter(SkipSegmentAdapter());

  final box = await Hive.openLazyBox(
    SkipSegment.boxName,
    path: await getHiveCacheDir(),
  );

  final skipSegments = await Future.wait(
    box.keys.map(
      (key) async => (
        id: key as String,
        data: await box.get(key),
      ),
    ),
  );

  await _database.batch((batch) {
    batch.insertAll(
      _database.skipSegmentTable,
      skipSegments
          .where((element) => element.data != null)
          .expand((element) => (element.data as List).map(
                (segment) => SkipSegmentTableCompanion.insert(
                  trackId: element.id,
                  start: segment["start"],
                  end: segment["end"],
                ),
              ))
          .toList(),
    );
  });

  AppLogger.log.i("✅ Migrated skip segments");
}

Future<void> migrateSourceMatches() async {
  AppLogger.log.i("🔵 Migrating source matches..");

  Hive.registerAdapter(SourceMatchAdapter());
  Hive.registerAdapter(SourceTypeAdapter());

  final box = await Hive.openBox<SourceMatch>(
    SourceMatch.boxName,
    path: await getHiveCacheDir(),
  );

  final sourceMatches =
      box.keys.map((key) => (data: box.get(key), trackId: key));

  await _database.batch((batch) {
    batch.insertAll(
      _database.sourceMatchTable,
      sourceMatches
          .where((element) => element.data != null)
          .map(
            (sourceMatch) => SourceMatchTableCompanion.insert(
              sourceId: sourceMatch.data!.sourceId,
              trackId: sourceMatch.trackId,
              sourceType: Value(
                switch (sourceMatch.data!.sourceType) {
                  SourceType.jiosaavn => db.SourceType.jiosaavn,
                  SourceType.youtube => db.SourceType.youtube,
                  SourceType.youtubeMusic => db.SourceType.youtubeMusic,
                },
              ),
            ),
          )
          .toList(),
    );
  });

  AppLogger.log.i("✅ Migrated source matches");
}

Future<void> migrateBlacklist() async {
  AppLogger.log.i("🔵 Migrating blacklist..");

  final box = PersistenceCacheBox<Set<BlacklistedElement>>(
    "blacklist",
    fromJson: (json) => (json["blacklist"] as List)
        .map((e) => BlacklistedElement.fromJson(e))
        .toSet(),
  );

  final data = await box.getData();

  if (data == null) return;

  await _database.batch((batch) {
    batch.insertAll(
      _database.blacklistTable,
      data.map(
        (element) => BlacklistTableCompanion.insert(
          name: element.name,
          elementId: element.id,
          elementType: switch (element.type) {
            BlacklistedType.artist => db.BlacklistedType.artist,
            BlacklistedType.track => db.BlacklistedType.track,
          },
        ),
      ),
    );
  });

  AppLogger.log.i("✅ Migrated blacklist");
}

Future<void> migrateLastFmCredentials() async {
  AppLogger.log.i("🔵 Migrating Last.fm credentials..");

  final box = PersistenceCacheBox<ScrobblerState>(
    "scrobbler",
    fromJson: (json) => ScrobblerState.fromJson(json),
    encrypted: true,
  );

  final data = await box.getData();

  if (data == null) return;

  await _database.into(_database.scrobblerTable).insert(
        ScrobblerTableCompanion.insert(
          id: const Value(0),
          passwordHash: DecryptedText(data.passwordHash),
          username: data.username,
        ),
        mode: InsertMode.replace,
      );

  AppLogger.log.i("✅ Migrated Last.fm credentials");
}

Future<void> migratePlaybackHistory() async {
  AppLogger.log.i("🔵 Migrating playback history..");

  final box = PersistenceCacheBox<PlaybackHistoryState>(
    "playback_history",
    fromJson: (json) => PlaybackHistoryState.fromJson(json),
  );

  final data = await box.getData();

  if (data == null) return;

  await _database.batch((batch) {
    batch.insertAll(
      _database.historyTable,
      data.items.map(
        (item) => switch (item) {
          PlaybackHistoryAlbum() => HistoryTableCompanion.insert(
              createdAt: Value(item.date),
              itemId: item.album.id!,
              data: item.album.toJson(),
              type: db.HistoryEntryType.album,
            ),
          PlaybackHistoryPlaylist() => HistoryTableCompanion.insert(
              createdAt: Value(item.date),
              itemId: item.playlist.id!,
              data: item.playlist.toJson(),
              type: db.HistoryEntryType.playlist,
            ),
          PlaybackHistoryTrack() => HistoryTableCompanion.insert(
              createdAt: Value(item.date),
              itemId: item.track.id!,
              data: item.track.toJson(),
              type: db.HistoryEntryType.track,
            ),
          _ => throw Exception("Unknown history item type"),
        },
      ),
    );
  });

  AppLogger.log.i("✅ Migrated playback history");
}

Future<void> migrateFromHiveToDrift(AppDatabase database) async {
  if (KVStoreService.hasMigratedToDrift) return;

  await PersistenceCacheBox.initializeBoxes(
    path: await getHiveCacheDir(),
  );

  _database = database;

  await migrateAuthenticationInfo();
  await migratePreferences();

  await migrateSkipSegment();
  await migrateSourceMatches();

  await migrateBlacklist();
  await migratePlaybackHistory();

  await migrateLastFmCredentials();

  await KVStoreService.setHasMigratedToDrift(true);

  AppLogger.log.i("🚀 Migrated all data to Drift");
}
