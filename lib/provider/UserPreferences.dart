import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotube/helpers/get-random-element.dart';
import 'package:spotube/models/LocalStorageKeys.dart';
import 'package:spotube/models/Logger.dart';
import 'package:spotube/models/generated_secrets.dart';

class UserPreferences extends ChangeNotifier {
  String recommendationMarket;
  String geniusAccessToken;
  HotKey? nextTrackHotKey;
  HotKey? prevTrackHotKey;
  HotKey? playPauseHotKey;
  UserPreferences({
    required this.geniusAccessToken,
    required this.recommendationMarket,
    this.nextTrackHotKey,
    this.prevTrackHotKey,
    this.playPauseHotKey,
  }) {
    onInit();
  }

  final logger = getLogger(UserPreferences);

  Future<HotKey?> _getHotKeyFromLocalStorage(
      SharedPreferences preferences, String key) async {
    String? str = preferences.getString(key);
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
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      String? accessToken =
          localStorage.getString(LocalStorageKeys.geniusAccessToken);

      recommendationMarket =
          localStorage.getString(LocalStorageKeys.recommendationMarket) ?? 'US';
      geniusAccessToken = accessToken != null && accessToken.isNotEmpty
          ? accessToken
          : getRandomElement(lyricsSecrets);

      nextTrackHotKey ??= (await _getHotKeyFromLocalStorage(
            localStorage,
            LocalStorageKeys.nextTrackHotKey,
          )) ??
          HotKey(
            KeyCode.slash,
            modifiers: [KeyModifier.control, KeyModifier.alt],
          );

      prevTrackHotKey ??= (await _getHotKeyFromLocalStorage(
            localStorage,
            LocalStorageKeys.prevTrackHotKey,
          )) ??
          HotKey(
            KeyCode.comma,
            modifiers: [KeyModifier.control, KeyModifier.alt],
          );

      playPauseHotKey ??= (await _getHotKeyFromLocalStorage(
            localStorage,
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

  void setRecommendationMarket(String country) {
    recommendationMarket = country;
    SharedPreferences.getInstance().then((value) {
      value.setString(LocalStorageKeys.recommendationMarket, country);
      notifyListeners();
    });
  }

  void setGeniusAccessToken(String token) {
    geniusAccessToken = token;
    notifyListeners();
  }

  void setNextTrackHotKey(HotKey? value) {
    nextTrackHotKey = value;
    SharedPreferences.getInstance().then((preferences) {
      preferences.setString(
        LocalStorageKeys.nextTrackHotKey,
        jsonEncode(value?.toJson() ?? {}),
      );
    });
    notifyListeners();
  }

  void setPrevTrackHotKey(HotKey? value) {
    prevTrackHotKey = value;
    SharedPreferences.getInstance().then((preferences) {
      preferences.setString(
        LocalStorageKeys.prevTrackHotKey,
        jsonEncode(value?.toJson() ?? {}),
      );
    });
    notifyListeners();
  }

  void setPlayPauseHotKey(HotKey? value) {
    playPauseHotKey = value;
    SharedPreferences.getInstance().then((preferences) {
      preferences.setString(
        LocalStorageKeys.playPauseHotKey,
        jsonEncode(value?.toJson() ?? {}),
      );
    });
    notifyListeners();
  }
}

final userPreferencesProvider = ChangeNotifierProvider(
  (_) => UserPreferences(geniusAccessToken: "", recommendationMarket: 'US'),
);
