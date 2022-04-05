import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotube/helpers/get-random-element.dart';
import 'package:spotube/models/LocalStorageKeys.dart';
import 'package:spotube/models/Logger.dart';
import 'package:spotube/models/generated_secrets.dart';

class UserPreferences extends ChangeNotifier {
  ThemeMode themeMode;
  String recommendationMarket;
  bool saveTrackLyrics;
  String geniusAccessToken;
  SharedPreferences? localStorage;
  HotKey? nextTrackHotKey;
  HotKey? prevTrackHotKey;
  HotKey? playPauseHotKey;
  UserPreferences({
    required this.geniusAccessToken,
    required this.recommendationMarket,
    required this.themeMode,
    this.saveTrackLyrics = false,
    this.nextTrackHotKey,
    this.prevTrackHotKey,
    this.playPauseHotKey,
  }) {
    onInit();
  }

  final logger = getLogger(UserPreferences);

  Future<HotKey?> _getHotKeyFromLocalStorage(String key) async {
    String? str = localStorage?.getString(key);
    if (str != null) {
      Map<String, dynamic> json = await jsonDecode(str);
      if (json.isEmpty) {
        return null;
      }
      return HotKey.fromJson(json);
    }
    return null;
  }

  Future<void> onInit() async {
    try {
      localStorage = await SharedPreferences.getInstance();
      String? accessToken =
          localStorage?.getString(LocalStorageKeys.geniusAccessToken);

      saveTrackLyrics =
          localStorage?.getBool(LocalStorageKeys.saveTrackLyrics) ?? false;

      final themeModeRaw = localStorage?.getString(LocalStorageKeys.themeMode);
      switch (themeModeRaw) {
        case "light":
          themeMode = ThemeMode.light;
          break;
        case "dark":
          themeMode = ThemeMode.dark;
          break;
        default:
          themeMode = ThemeMode.system;
      }

      recommendationMarket =
          localStorage?.getString(LocalStorageKeys.recommendationMarket) ??
              'US';
      geniusAccessToken = accessToken != null && accessToken.isNotEmpty
          ? accessToken
          : getRandomElement(lyricsSecrets);

      nextTrackHotKey ??= (await _getHotKeyFromLocalStorage(
            LocalStorageKeys.nextTrackHotKey,
          )) ??
          HotKey(
            KeyCode.slash,
            modifiers: [KeyModifier.control, KeyModifier.alt],
          );

      prevTrackHotKey ??= (await _getHotKeyFromLocalStorage(
            LocalStorageKeys.prevTrackHotKey,
          )) ??
          HotKey(
            KeyCode.comma,
            modifiers: [KeyModifier.control, KeyModifier.alt],
          );

      playPauseHotKey ??= (await _getHotKeyFromLocalStorage(
            LocalStorageKeys.playPauseHotKey,
          )) ??
          HotKey(
            KeyCode.period,
            modifiers: [KeyModifier.control, KeyModifier.alt],
          );
      notifyListeners();
    } catch (e, stack) {
      logger.e("onInit", e, stack);
    }
  }

  void setThemeMode(ThemeMode mode) {
    themeMode = mode;
    localStorage?.setString(LocalStorageKeys.themeMode, mode.name);
    notifyListeners();
  }

  void setSaveTrackLyrics(bool shouldSave) {
    saveTrackLyrics = shouldSave;
    localStorage?.setBool(LocalStorageKeys.saveTrackLyrics, shouldSave);
    notifyListeners();
  }

  void setRecommendationMarket(String country) {
    recommendationMarket = country;
    localStorage?.setString(LocalStorageKeys.recommendationMarket, country);
  }

  void setGeniusAccessToken(String token) {
    geniusAccessToken = token;
    notifyListeners();
  }

  void setNextTrackHotKey(HotKey? value) {
    nextTrackHotKey = value;
    localStorage?.setString(
      LocalStorageKeys.nextTrackHotKey,
      jsonEncode(value?.toJson() ?? {}),
    );
    notifyListeners();
  }

  void setPrevTrackHotKey(HotKey? value) {
    prevTrackHotKey = value;
    localStorage?.setString(
      LocalStorageKeys.prevTrackHotKey,
      jsonEncode(value?.toJson() ?? {}),
    );
    notifyListeners();
  }

  void setPlayPauseHotKey(HotKey? value) {
    playPauseHotKey = value;
    localStorage?.setString(
      LocalStorageKeys.playPauseHotKey,
      jsonEncode(value?.toJson() ?? {}),
    );
    notifyListeners();
  }
}

final userPreferencesProvider = ChangeNotifierProvider(
  (_) => UserPreferences(
    geniusAccessToken: "",
    recommendationMarket: 'US',
    themeMode: ThemeMode.system,
  ),
);
