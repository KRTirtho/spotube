import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotube/utils/PersistedChangeNotifier.dart';

class Auth extends PersistedChangeNotifier {
  String? _clientId;
  String? _clientSecret;
  String? _accessToken;
  String? _refreshToken;
  DateTime? _expiration;

  Auth() : super();

  String? get clientId => _clientId;
  String? get clientSecret => _clientSecret;
  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;
  DateTime? get expiration => _expiration;

  bool get isAnonymous =>
      _clientId == null &&
      _clientSecret == null &&
      accessToken == null &&
      refreshToken == null;

  bool get isLoggedIn => !isAnonymous && _expiration != null;

  void setAuthState({
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
    updatePersistence();
  }

  void logout() {
    _clientId = null;
    _clientSecret = null;
    _accessToken = null;
    _refreshToken = null;
    _expiration = null;
    notifyListeners();
    updatePersistence(clearNullEntries: true);
  }

  @override
  String toString() {
    return "Auth(clientId: $clientId, clientSecret: $clientSecret, accessToken: $accessToken, refreshToken: $refreshToken, expiration:  $expiration, isLoggedIn: $isLoggedIn)";
  }

  @override
  FutureOr<void> loadFromLocal(Map<String, dynamic> map) {
    _clientId = map["clientId"];
    _clientSecret = map["clientSecret"];
    _accessToken = map["accessToken"];
    _refreshToken = map["refreshToken"];
    _expiration = DateTime.tryParse(map["expiration"]);
  }

  @override
  FutureOr<Map<String, dynamic>> toMap() {
    return {
      "clientId": _clientId,
      "clientSecret": _clientSecret,
      "accessToken": _accessToken,
      "refreshToken": _refreshToken,
      "expiration": _expiration.toString(),
    };
  }
}

final authProvider = ChangeNotifierProvider<Auth>((ref) => Auth());
