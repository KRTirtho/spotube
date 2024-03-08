import 'package:shared_preferences/shared_preferences.dart';

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
}
