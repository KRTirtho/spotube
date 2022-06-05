import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:spotube/components/Settings/ColorSchemePickerDialog.dart';
import 'package:spotube/helpers/get-random-element.dart';
import 'package:spotube/helpers/search-youtube.dart';
import 'package:spotube/models/SpotubeTrack.dart';
import 'package:spotube/models/generated_secrets.dart';
import 'package:spotube/utils/PersistedChangeNotifier.dart';
import 'package:collection/collection.dart';

class UserPreferences extends PersistedChangeNotifier {
  ThemeMode themeMode;
  String ytSearchFormat;
  String recommendationMarket;
  bool saveTrackLyrics;
  String geniusAccessToken;
  HotKey? nextTrackHotKey;
  HotKey? prevTrackHotKey;
  HotKey? playPauseHotKey;
  bool checkUpdate;
  SpotubeTrackMatchAlgorithm trackMatchAlgorithm;
  AudioQuality audioQuality;

  MaterialColor accentColorScheme;
  MaterialColor backgroundColorScheme;
  UserPreferences({
    required this.geniusAccessToken,
    required this.recommendationMarket,
    required this.themeMode,
    required this.ytSearchFormat,
    this.saveTrackLyrics = false,
    this.accentColorScheme = Colors.green,
    this.backgroundColorScheme = Colors.grey,
    this.nextTrackHotKey,
    this.prevTrackHotKey,
    this.playPauseHotKey,
    this.checkUpdate = true,
    this.trackMatchAlgorithm = SpotubeTrackMatchAlgorithm.authenticPopular,
    this.audioQuality = AudioQuality.high,
  }) : super();

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

  void setNextTrackHotKey(HotKey? value) {
    nextTrackHotKey = value;
    notifyListeners();
    updatePersistence();
  }

  void setPrevTrackHotKey(HotKey? value) {
    prevTrackHotKey = value;
    notifyListeners();
    updatePersistence();
  }

  void setPlayPauseHotKey(HotKey? value) {
    playPauseHotKey = value;
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

  @override
  FutureOr<void> loadFromLocal(Map<String, dynamic> map) {
    saveTrackLyrics = map["saveTrackLyrics"] ?? false;
    recommendationMarket = map["recommendationMarket"] ?? recommendationMarket;
    checkUpdate = map["checkUpdate"] ?? checkUpdate;
    geniusAccessToken =
        map["geniusAccessToken"] ?? getRandomElement(lyricsSecrets);
    nextTrackHotKey = map["nextTrackHotKey"] != null
        ? HotKey.fromJson(jsonDecode(map["nextTrackHotKey"]))
        : null;
    prevTrackHotKey = map["prevTrackHotKey"] != null
        ? HotKey.fromJson(jsonDecode(map["prevTrackHotKey"]))
        : null;
    playPauseHotKey = map["playPauseHotKey"] != null
        ? HotKey.fromJson(jsonDecode(map["playPauseHotKey"]))
        : null;
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
  }

  @override
  FutureOr<Map<String, dynamic>> toMap() {
    return {
      "saveTrackLyrics": saveTrackLyrics,
      "recommendationMarket": recommendationMarket,
      "geniusAccessToken": geniusAccessToken,
      "nextTrackHotKey": nextTrackHotKey != null
          ? jsonEncode(nextTrackHotKey?.toJson())
          : null,
      "prevTrackHotKey": prevTrackHotKey != null
          ? jsonEncode(prevTrackHotKey?.toJson())
          : null,
      "playPauseHotKey": playPauseHotKey != null
          ? jsonEncode(playPauseHotKey?.toJson())
          : null,
      "ytSearchFormat": ytSearchFormat,
      "themeMode": themeMode.index,
      "backgroundColorScheme": backgroundColorScheme.value,
      "accentColorScheme": accentColorScheme.value,
      "checkUpdate": checkUpdate,
      "trackMatchAlgorithm": trackMatchAlgorithm.index,
      "audioQuality": audioQuality.index,
    };
  }
}

final userPreferencesProvider = ChangeNotifierProvider(
  (_) => UserPreferences(
    geniusAccessToken: "",
    recommendationMarket: 'US',
    themeMode: ThemeMode.system,
    ytSearchFormat: "\$MAIN_ARTIST - \$TITLE \$FEATURED_ARTISTS",
  ),
);
