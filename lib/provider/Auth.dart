import 'package:flutter/cupertino.dart';

class Auth with ChangeNotifier {
  String? _clientId;
  String? _clientSecret;
  bool _isLoggedIn = false;

  String? get cliendId => _clientId;
  String? get clientSecret => _clientSecret;
  bool get isLoggedIn => _isLoggedIn;

  void setAuthState({
    bool? isLoggedIn,
    bool safe = true,
    String? clientId,
    String? clientSecret,
    String? refresh_token,
    String? access_token,
  }) {
    if (safe) {
      if (clientId != null) _clientId = clientId;
      if (clientSecret != null) _clientSecret = clientSecret;
      if (isLoggedIn != null) _isLoggedIn = isLoggedIn;
    } else {
      _clientId = clientId;
      _clientSecret = clientSecret;
    }
    notifyListeners();
  }
}
