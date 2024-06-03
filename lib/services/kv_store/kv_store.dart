import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotube/services/wm_tools/wm_tools.dart';

abstract class KVStoreService {
  static SharedPreferences? _sharedPreferences;
  static SharedPreferences get sharedPreferences => _sharedPreferences!;

  static Future<void> initialize() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  static bool get doneGettingStarted =>
      sharedPreferences.getBool('doneGettingStarted') ?? false;
  static Future<void> setDoneGettingStarted(bool value) async =>
      await sharedPreferences.setBool('doneGettingStarted', value);

  static bool get askedForBatteryOptimization =>
      sharedPreferences.getBool('askedForBatteryOptimization') ?? false;
  static Future<void> setAskedForBatteryOptimization(bool value) async =>
      await sharedPreferences.setBool('askedForBatteryOptimization', value);

  static List<String> get recentSearches =>
      sharedPreferences.getStringList('recentSearches') ?? [];

  static Future<void> setRecentSearches(List<String> value) async =>
      await sharedPreferences.setStringList('recentSearches', value);

  static WindowSize? get windowSize {
    final raw = sharedPreferences.getString('windowSize');

    if (raw == null) {
      return null;
    }
    return WindowSize.fromJson(jsonDecode(raw));
  }

  static Future<void> setWindowSize(WindowSize value) async =>
      await sharedPreferences.setString(
        'windowSize',
        jsonEncode(
          value.toJson(),
        ),
      );
}
