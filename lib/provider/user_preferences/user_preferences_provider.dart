import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/models/database/database.dart';
import 'package:spotube/modules/settings/color_scheme_picker_dialog.dart';
import 'package:spotube/provider/audio_player/audio_player_streams.dart';
import 'package:spotube/provider/database/database.dart';
import 'package:spotube/provider/palette_provider.dart';
import 'package:spotube/services/audio_player/audio_player.dart';
import 'package:spotube/services/logger/logger.dart';
import 'package:spotube/services/sourced_track/enums.dart';
import 'package:spotube/utils/platform.dart';
import 'package:window_manager/window_manager.dart';

typedef UserPreferences = PreferencesTableData;

class UserPreferencesNotifier extends Notifier<PreferencesTableData> {
  @override
  build() {
    final db = ref.watch(databaseProvider);

    (db.select(db.preferencesTable)..where((tbl) => tbl.id.equals(0)))
        .getSingleOrNull()
        .then((result) async {
      if (result == null) {
        await db.into(db.preferencesTable).insert(
              PreferencesTableCompanion.insert(
                id: const Value(0),
                downloadLocation: Value(await _getDefaultDownloadDirectory()),
              ),
            );
      }

      state = await (db.select(db.preferencesTable)
            ..where((tbl) => tbl.id.equals(0)))
          .getSingle();

      final subscription = (db.select(db.preferencesTable)
            ..where((tbl) => tbl.id.equals(0)))
          .watchSingle()
          .listen((event) async {
        try {
          state = event;

          if (kIsDesktop) {
            await windowManager.setTitleBarStyle(
              state.systemTitleBar
                  ? TitleBarStyle.normal
                  : TitleBarStyle.hidden,
            );
          }

          await audioPlayer.setAudioNormalization(state.normalizeAudio);
        } catch (e, stack) {
          AppLogger.reportError(e, stack);
        }
      });

      ref.onDispose(() {
        subscription.cancel();
      });
    });

    return PreferencesTable.defaults();
  }

  Future<String> _getDefaultDownloadDirectory() async {
    if (kIsAndroid) return "/storage/emulated/0/Download/Spotube";

    if (kIsMacOS) {
      return join((await getLibraryDirectory()).path, "Caches");
    }

    return getDownloadsDirectory().then((dir) {
      return join(dir!.path, "Spotube");
    });
  }

  Future<void> setData(PreferencesTableCompanion data) async {
    final db = ref.read(databaseProvider);

    final query = db.update(db.preferencesTable)..where((t) => t.id.equals(0));

    await query.write(data);
  }

  Future<void> reset() async {
    final db = ref.read(databaseProvider);

    final query = db.update(db.preferencesTable)..where((t) => t.id.equals(0));

    await query.replace(PreferencesTableCompanion.insert());
  }

  void setStreamMusicCodec(SourceCodecs codec) {
    setData(PreferencesTableCompanion(streamMusicCodec: Value(codec)));
  }

  void setDownloadMusicCodec(SourceCodecs codec) {
    setData(PreferencesTableCompanion(downloadMusicCodec: Value(codec)));
  }

  void setThemeMode(ThemeMode mode) {
    setData(PreferencesTableCompanion(themeMode: Value(mode)));
  }

  void setRecommendationMarket(Market country) {
    setData(PreferencesTableCompanion(market: Value(country)));
  }

  void setAccentColorScheme(SpotubeColor color) {
    setData(PreferencesTableCompanion(accentColorScheme: Value(color)));
  }

  void setAlbumColorSync(bool sync) {
    setData(PreferencesTableCompanion(albumColorSync: Value(sync)));

    if (!sync) {
      ref.read(paletteProvider.notifier).state = null;
    } else {
      ref.read(audioPlayerStreamListenersProvider).updatePalette();
    }
  }

  void setCheckUpdate(bool check) {
    setData(PreferencesTableCompanion(checkUpdate: Value(check)));
  }

  void setAudioQuality(SourceQualities quality) {
    setData(PreferencesTableCompanion(audioQuality: Value(quality)));
  }

  void setDownloadLocation(String downloadDir) {
    if (downloadDir.isEmpty) return;
    setData(PreferencesTableCompanion(downloadLocation: Value(downloadDir)));
  }

  void setLocalLibraryLocation(List<String> localLibraryDirs) {
    //if (localLibraryDir.isEmpty) return;
    setData(
      PreferencesTableCompanion(
        localLibraryLocation: Value(localLibraryDirs),
      ),
    );
  }

  void setLayoutMode(LayoutMode mode) {
    setData(PreferencesTableCompanion(layoutMode: Value(mode)));
  }

  void setCloseBehavior(CloseBehavior behavior) {
    setData(PreferencesTableCompanion(closeBehavior: Value(behavior)));
  }

  void setShowSystemTrayIcon(bool show) {
    setData(PreferencesTableCompanion(showSystemTrayIcon: Value(show)));
  }

  void setLocale(Locale locale) {
    setData(PreferencesTableCompanion(locale: Value(locale)));
  }

  void setPipedInstance(String instance) {
    setData(PreferencesTableCompanion(pipedInstance: Value(instance)));
  }

  void setSearchMode(SearchMode mode) {
    setData(PreferencesTableCompanion(searchMode: Value(mode)));
  }

  void setSkipNonMusic(bool skip) {
    setData(PreferencesTableCompanion(skipNonMusic: Value(skip)));
  }

  void setAudioSource(AudioSource type) {
    setData(PreferencesTableCompanion(audioSource: Value(type)));
  }

  void setSystemTitleBar(bool isSystemTitleBar) {
    setData(
      PreferencesTableCompanion(
        systemTitleBar: Value(isSystemTitleBar),
      ),
    );
  }

  void setDiscordPresence(bool discordPresence) {
    setData(PreferencesTableCompanion(discordPresence: Value(discordPresence)));
  }

  void setAmoledDarkTheme(bool isAmoled) {
    setData(PreferencesTableCompanion(amoledDarkTheme: Value(isAmoled)));
  }

  void setNormalizeAudio(bool normalize) {
    setData(PreferencesTableCompanion(normalizeAudio: Value(normalize)));
    audioPlayer.setAudioNormalization(normalize);
  }

  void setEndlessPlayback(bool endless) {
    setData(PreferencesTableCompanion(endlessPlayback: Value(endless)));
  }

  void setEnableConnect(bool enable) {
    setData(PreferencesTableCompanion(enableConnect: Value(enable)));
  }
}

final userPreferencesProvider =
    NotifierProvider<UserPreferencesNotifier, PreferencesTableData>(
  () => UserPreferencesNotifier(),
);
