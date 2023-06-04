import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:spotube/components/settings/color_scheme_picker_dialog.dart';
import 'package:spotube/provider/palette_provider.dart';
import 'package:spotube/provider/proxy_playlist/proxy_playlist_provider.dart';

import 'package:spotube/utils/persisted_change_notifier.dart';
import 'package:spotube/utils/platform.dart';
import 'package:path/path.dart' as path;

enum LayoutMode {
  compact,
  extended,
  adaptive,
}

enum AudioQuality {
  high,
  low,
}

enum CloseBehavior {
  minimizeToTray,
  close,
}

class UserPreferences extends PersistedChangeNotifier {
  ThemeMode themeMode;
  String recommendationMarket;
  bool saveTrackLyrics;
  bool checkUpdate;
  AudioQuality audioQuality;

  SpotubeColor accentColorScheme;
  bool albumColorSync;

  String downloadLocation;

  LayoutMode layoutMode;

  bool predownload;

  CloseBehavior closeBehavior;

  bool showSystemTrayIcon;

  Locale locale;

  String pipedInstance;

  final Ref ref;

  UserPreferences(
    this.ref, {
    required this.recommendationMarket,
    required this.themeMode,
    required this.layoutMode,
    required this.predownload,
    required this.accentColorScheme,
    this.albumColorSync = true,
    this.saveTrackLyrics = false,
    this.checkUpdate = true,
    this.audioQuality = AudioQuality.high,
    this.downloadLocation = "",
    this.closeBehavior = CloseBehavior.minimizeToTray,
    this.showSystemTrayIcon = true,
    this.locale = const Locale("system", "system"),
    this.pipedInstance = "https://pipedapi.kavin.rocks",
  }) : super() {
    if (downloadLocation.isEmpty) {
      _getDefaultDownloadDirectory().then(
        (value) {
          downloadLocation = value;
        },
      );
    }
  }

  void setPredownload(bool value) {
    predownload = value;
    notifyListeners();
    updatePersistence();
  }

  void setThemeMode(ThemeMode mode) {
    themeMode = mode;
    notifyListeners();
    updatePersistence();
  }

  void setSaveTrackLyrics(bool shouldSave) {
    saveTrackLyrics = shouldSave;
    notifyListeners();
    updatePersistence();
  }

  void setRecommendationMarket(String country) {
    recommendationMarket = country;
    notifyListeners();
    updatePersistence();
  }

  void setAccentColorScheme(SpotubeColor color) {
    accentColorScheme = color;
    notifyListeners();
    updatePersistence();
  }

  void setAlbumColorSync(bool sync) {
    albumColorSync = sync;
    if (!sync) {
      ref.read(paletteProvider.notifier).state = null;
    } else {
      ref.read(ProxyPlaylistNotifier.notifier).updatePalette();
    }
    notifyListeners();
    updatePersistence();
  }

  void setCheckUpdate(bool check) {
    checkUpdate = check;
    notifyListeners();
    updatePersistence();
  }

  void setAudioQuality(AudioQuality quality) {
    audioQuality = quality;
    notifyListeners();
    updatePersistence();
  }

  void setDownloadLocation(String downloadDir) {
    if (downloadDir.isEmpty) return;
    downloadLocation = downloadDir;
    notifyListeners();
    updatePersistence();
  }

  void setLayoutMode(LayoutMode mode) {
    layoutMode = mode;
    notifyListeners();
    updatePersistence();
  }

  void setCloseBehavior(CloseBehavior behavior) {
    closeBehavior = behavior;
    notifyListeners();
    updatePersistence();
  }

  void setShowSystemTrayIcon(bool show) {
    showSystemTrayIcon = show;
    notifyListeners();
    updatePersistence();
  }

  void setLocale(Locale locale) {
    this.locale = locale;
    notifyListeners();
    updatePersistence();
  }

  void setPipedInstance(String instance) {
    pipedInstance = instance;
    notifyListeners();
    updatePersistence();
  }

  Future<String> _getDefaultDownloadDirectory() async {
    if (kIsAndroid) return "/storage/emulated/0/Download/Spotube";

    if (kIsMacOS) {
      return path.join((await getLibraryDirectory()).path, "Caches");
    }

    return getDownloadsDirectory().then((dir) {
      return path.join(dir!.path, "Spotube");
    });
  }

  @override
  FutureOr<void> loadFromLocal(Map<String, dynamic> map) async {
    saveTrackLyrics = map["saveTrackLyrics"] ?? false;
    recommendationMarket = map["recommendationMarket"] ?? recommendationMarket;
    checkUpdate = map["checkUpdate"] ?? checkUpdate;

    themeMode = ThemeMode.values[map["themeMode"] ?? 0];
    accentColorScheme = map["accentColorScheme"] != null
        ? SpotubeColor.fromString(map["accentColorScheme"])
        : accentColorScheme;
    albumColorSync = map["albumColorSync"] ?? albumColorSync;
    audioQuality = map["audioQuality"] != null
        ? AudioQuality.values[map["audioQuality"]]
        : audioQuality;
    downloadLocation =
        map["downloadLocation"] ?? await _getDefaultDownloadDirectory();

    layoutMode = LayoutMode.values.firstWhere(
      (mode) => mode.name == map["layoutMode"],
      orElse: () => kIsDesktop ? LayoutMode.extended : LayoutMode.compact,
    );

    predownload = map["predownload"] ?? predownload;

    closeBehavior = map["closeBehavior"] != null
        ? CloseBehavior.values[map["closeBehavior"]]
        : closeBehavior;

    showSystemTrayIcon = map["showSystemTrayIcon"] ?? showSystemTrayIcon;

    final localeMap = map["locale"] != null ? jsonDecode(map["locale"]) : null;
    locale =
        localeMap != null ? Locale(localeMap?["lc"], localeMap?["cc"]) : locale;

    pipedInstance = map["pipedInstance"] ?? pipedInstance;
  }

  @override
  FutureOr<Map<String, dynamic>> toMap() {
    return {
      "saveTrackLyrics": saveTrackLyrics,
      "recommendationMarket": recommendationMarket,
      "themeMode": themeMode.index,
      "accentColorScheme": accentColorScheme.toString(),
      "albumColorSync": albumColorSync,
      "checkUpdate": checkUpdate,
      "audioQuality": audioQuality.index,
      "downloadLocation": downloadLocation,
      "layoutMode": layoutMode.name,
      "predownload": predownload,
      "closeBehavior": closeBehavior.index,
      "showSystemTrayIcon": showSystemTrayIcon,
      "locale":
          jsonEncode({"lc": locale.languageCode, "cc": locale.countryCode}),
      "pipedInstance": pipedInstance,
    };
  }
}

final userPreferencesProvider = ChangeNotifierProvider(
  (ref) => UserPreferences(
    ref,
    accentColorScheme: SpotubeColor(Colors.blue.value, name: "Blue"),
    recommendationMarket: 'US',
    themeMode: ThemeMode.system,
    layoutMode: kIsMobile ? LayoutMode.compact : LayoutMode.adaptive,
    predownload: false,
  ),
);
