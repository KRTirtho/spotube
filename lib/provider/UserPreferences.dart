import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotube/models/LocalStorageKeys.dart';

class UserPreferences extends ChangeNotifier {
  String? _geniusAccessToken;
  UserPreferences({String? geniusAccessToken}) {
    if (geniusAccessToken == null) {
      SharedPreferences.getInstance().then((localStorage) {
        String? accessToken =
            localStorage.getString(LocalStorageKeys.geniusAccessToken);
        _geniusAccessToken ??= accessToken;
      });
    } else {
      _geniusAccessToken = geniusAccessToken;
    }
  }

  get geniusAccessToken => _geniusAccessToken;

  setGeniusAccessToken(String? token) {
    _geniusAccessToken = token;
    notifyListeners();
  }
}
