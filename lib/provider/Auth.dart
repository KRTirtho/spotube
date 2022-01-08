import 'package:flutter/cupertino.dart';

class Auth with ChangeNotifier {
  String? _clientId;
  String? _clientSecret;
  String? _accessToken;
  String? _refreshToken;
  DateTime? _expiration;

  bool _isLoggedIn = false;

  String? get clientId => _clientId;
  String? get clientSecret => _clientSecret;
  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;
  DateTime? get expiration => _expiration;
  bool get isLoggedIn => _isLoggedIn;

  void setAuthState({
    bool? isLoggedIn,
    bool safe = true,
    String? clientId,
    String? clientSecret,
    String? refreshToken,
    String? accessToken,
    DateTime? expiration,
  }) {
    if (safe) {
      if (clientId != null) _clientId = clientId;
      if (clientSecret != null) _clientSecret = clientSecret;
      if (isLoggedIn != null) _isLoggedIn = isLoggedIn;
      if (refreshToken != null) _refreshToken = refreshToken;
      if (accessToken != null) _accessToken = accessToken;
      if (expiration != null) _expiration = expiration;
    } else {
      _clientId = clientId;
      _clientSecret = clientSecret;
      _accessToken = accessToken;
      _refreshToken = refreshToken;
      _expiration = expiration;
    }
    notifyListeners();
  }

  logout() {
    _clientId = null;
    _clientSecret = null;
    _accessToken = null;
    _refreshToken = null;
    _expiration = null;
    _isLoggedIn = false;
    notifyListeners();
  }
}
