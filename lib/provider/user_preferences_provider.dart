import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:spotube/components/settings/color_scheme_picker_dialog.dart';
import 'package:spotube/models/spotube_track.dart';
import 'package:spotube/models/generated_secrets.dart';
import 'package:spotube/utils/persisted_change_notifier.dart';
import 'package:collection/collection.dart';
import 'package:spotube/utils/platform.dart';
import 'package:spotube/utils/primitive_utils.dart';
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

class UserPreferences extends PersistedChangeNotifier {
  ThemeMode themeMode;
  String ytSearchFormat;
  String recommendationMarket;
  bool saveTrackLyrics;
  String geniusAccessToken;
  bool checkUpdate;
  SpotubeTrackMatchAlgorithm trackMatchAlgorithm;
  AudioQuality audioQuality;

  MaterialColor accentColorScheme;
  MaterialColor backgroundColorScheme;
  bool skipSponsorSegments;

  String downloadLocation;

  LayoutMode layoutMode;
  bool rotatingAlbumArt;

  bool androidBytesPlay;

  UserPreferences({
    required this.geniusAccessToken,
    required this.recommendationMarket,
    required this.themeMode,
    required this.ytSearchFormat,
    required this.layoutMode,
    this.androidBytesPlay = true,
    this.saveTrackLyrics = false,
    this.accentColorScheme = Colors.green,
    this.backgroundColorScheme = Colors.grey,
    this.checkUpdate = true,
    this.trackMatchAlgorithm = SpotubeTrackMatchAlgorithm.youtube,
    this.audioQuality = AudioQuality.high,
    this.skipSponsorSegments = true,
    this.downloadLocation = "",
    this.rotatingAlbumArt = true,
  }) : super() {
    if (downloadLocation.isEmpty) {
      _getDefaultDownloadDirectory().then(
        (value) {
          downloadLocation = value;
        },
      );
    }
  }

  void setAndroidBytesPlay(bool value) {
    androidBytesPlay = value;
    notifyListeners();
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

  void setGeniusAccessToken(String token) {
    geniusAccessToken = token;
    notifyListeners();
    updatePersistence();
  }

  void setYtSearchFormat(String format) {
    ytSearchFormat = format;
    notifyListeners();
    updatePersistence();
  }

  void setAccentColorScheme(MaterialColor color) {
    accentColorScheme = color;
    notifyListeners();
    updatePersistence();
  }

  void setBackgroundColorScheme(MaterialColor color) {
    backgroundColorScheme = color;
    notifyListeners();
    updatePersistence();
  }

  void setCheckUpdate(bool check) {
    checkUpdate = check;
    notifyListeners();
    updatePersistence();
  }

  void setTrackMatchAlgorithm(SpotubeTrackMatchAlgorithm algorithm) {
    trackMatchAlgorithm = algorithm;
    notifyListeners();
    updatePersistence();
  }

  void setAudioQuality(AudioQuality quality) {
    audioQuality = quality;
    notifyListeners();
    updatePersistence();
  }

  void setSkipSponsorSegments(bool should) {
    skipSponsorSegments = should;
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

  void setRotatingAlbumArt(bool should) {
    rotatingAlbumArt = should;
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
    geniusAccessToken = map["geniusAccessToken"] ??
        PrimitiveUtils.getRandomElement(lyricsSecrets);

    ytSearchFormat = map["ytSearchFormat"] ?? ytSearchFormat;
    themeMode = ThemeMode.values[map["themeMode"] ?? 0];
    backgroundColorScheme = colorsMap.values
            .firstWhereOrNull((e) => e.value == map["backgroundColorScheme"]) ??
        backgroundColorScheme;
    accentColorScheme = colorsMap.values
            .firstWhereOrNull((e) => e.value == map["accentColorScheme"]) ??
        accentColorScheme;
    trackMatchAlgorithm = map["trackMatchAlgorithm"] != null
        ? SpotubeTrackMatchAlgorithm.values[map["trackMatchAlgorithm"]]
        : trackMatchAlgorithm;
    audioQuality = map["audioQuality"] != null
        ? AudioQuality.values[map["audioQuality"]]
        : audioQuality;
    skipSponsorSegments = map["skipSponsorSegments"] ?? skipSponsorSegments;
    downloadLocation =
        map["downloadLocation"] ?? await _getDefaultDownloadDirectory();

    layoutMode = LayoutMode.values.firstWhere(
      (mode) => mode.name == map["layoutMode"],
      orElse: () => kIsDesktop ? LayoutMode.extended : LayoutMode.compact,
    );
    rotatingAlbumArt = map["rotatingAlbumArt"] ?? rotatingAlbumArt;
    androidBytesPlay = map["androidBytesPlay"] ?? androidBytesPlay;
  }

  @override
  FutureOr<Map<String, dynamic>> toMap() {
    return {
      "saveTrackLyrics": saveTrackLyrics,
      "recommendationMarket": recommendationMarket,
      "geniusAccessToken": geniusAccessToken,
      "ytSearchFormat": ytSearchFormat,
      "themeMode": themeMode.index,
      "backgroundColorScheme": backgroundColorScheme.value,
      "accentColorScheme": accentColorScheme.value,
      "checkUpdate": checkUpdate,
      "trackMatchAlgorithm": trackMatchAlgorithm.index,
      "audioQuality": audioQuality.index,
      "skipSponsorSegments": skipSponsorSegments,
      "downloadLocation": downloadLocation,
      "layoutMode": layoutMode.name,
      "rotatingAlbumArt": rotatingAlbumArt,
      "androidBytesPlay": androidBytesPlay,
    };
  }
}

final userPreferencesProvider = ChangeNotifierProvider(
  (_) => UserPreferences(
    geniusAccessToken: "",
    recommendationMarket: 'US',
    themeMode: ThemeMode.system,
    ytSearchFormat: "\$MAIN_ARTIST - \$TITLE \$FEATURED_ARTISTS",
    layoutMode: kIsMobile ? LayoutMode.compact : LayoutMode.adaptive,
  ),
);
