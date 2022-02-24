import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotube/models/LocalStorageKeys.dart';

class UserPreferences extends ChangeNotifier {
  String? geniusAccessToken;
  HotKey? nextTrackHotKey;
  HotKey? prevTrackHotKey;
  HotKey? playPauseHotKey;
  UserPreferences({
    this.nextTrackHotKey,
    this.prevTrackHotKey,
    this.playPauseHotKey,
    this.geniusAccessToken,
  }) {
    onInit();
  }

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
  }

  onInit() async {
    try {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      String? accessToken =
          localStorage.getString(LocalStorageKeys.geniusAccessToken);

      geniusAccessToken ??= accessToken;

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
      print("[UserPreferences.onInit]: $e");
      print(stack);
    }
  }

  setGeniusAccessToken(String? token) {
    geniusAccessToken = token;
    notifyListeners();
  }

  setNextTrackHotKey(HotKey? value) {
    nextTrackHotKey = value;
    SharedPreferences.getInstance().then((preferences) {
      preferences.setString(
        LocalStorageKeys.nextTrackHotKey,
        jsonEncode(value?.toJson() ?? {}),
      );
    });
    notifyListeners();
  }

  setPrevTrackHotKey(HotKey? value) {
    prevTrackHotKey = value;
    SharedPreferences.getInstance().then((preferences) {
      preferences.setString(
        LocalStorageKeys.prevTrackHotKey,
        jsonEncode(value?.toJson() ?? {}),
      );
    });
    notifyListeners();
  }

  setPlayPauseHotKey(HotKey? value) {
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

var userPreferencesProvider = ChangeNotifierProvider((_) => UserPreferences());
