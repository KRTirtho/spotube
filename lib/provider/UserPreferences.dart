import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotube/components/Settings/ColorSchemePickerDialog.dart';
import 'package:spotube/models/SpotubeTrack.dart';
import 'package:spotube/models/generated_secrets.dart';
import 'package:spotube/provider/Playback.dart';
import 'package:spotube/utils/PersistedChangeNotifier.dart';
import 'package:collection/collection.dart';
import 'package:spotube/utils/primitive_utils.dart';

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
  UserPreferences({
    required this.geniusAccessToken,
    required this.recommendationMarket,
    required this.themeMode,
    required this.ytSearchFormat,
    this.saveTrackLyrics = false,
    this.accentColorScheme = Colors.green,
    this.backgroundColorScheme = Colors.grey,
    this.checkUpdate = true,
    this.trackMatchAlgorithm = SpotubeTrackMatchAlgorithm.authenticPopular,
    this.audioQuality = AudioQuality.high,
    this.skipSponsorSegments = true,
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

  @override
  FutureOr<void> loadFromLocal(Map<String, dynamic> map) {
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
