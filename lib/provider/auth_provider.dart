import 'dart:async';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotube/utils/persisted_change_notifier.dart';
import 'package:spotube/utils/platform.dart';
import 'package:spotube/utils/service_utils.dart';

class Auth extends PersistedChangeNotifier {
  String? _accessToken;
  DateTime? _expiration;
  String? _authCookie;

  Timer? _refresher;

  Auth() : super() {
    _refresher = _createRefresher();
  }

  String? get accessToken => _accessToken;
  DateTime? get expiration => _expiration;
  String? get authCookie => _authCookie;

  bool get isAnonymous => accessToken == null && authCookie == null;

  bool get isLoggedIn => !isAnonymous && _expiration != null;
  bool get isExpired =>
      _expiration != null && _expiration!.isBefore(DateTime.now());

  Duration get expiresIn =>
      _expiration?.difference(DateTime.now()) ?? Duration.zero;

  Future<void> refresh() async {
    final data = await ServiceUtils.getAccessToken(authCookie!);
    _accessToken = data.accessToken;
    _expiration = data.expiration;
    _restartRefresher();
    notifyListeners();
  }

  Timer? _createRefresher() {
    if (expiration == null || authCookie == null) {
      return null;
    }
    if (isExpired) {
      refresh();
    }
    _refresher?.cancel();
    return Timer(expiresIn - const Duration(minutes: 5), refresh);
  }

  void _restartRefresher() {
    _refresher = _createRefresher();
  }

  void setAuthState({
    bool safe = true,
    String? accessToken,
    DateTime? expiration,
    String? authCookie,
  }) {
    if (safe) {
      if (accessToken != null) _accessToken = accessToken;
      if (expiration != null) {
        _expiration = expiration;
        _restartRefresher();
      }
      if (authCookie != null) _authCookie = authCookie;
    } else {
      _accessToken = accessToken;
      _expiration = expiration;
      _authCookie = authCookie;

      _restartRefresher();
    }
    notifyListeners();
    updatePersistence();
  }

  void logout() {
    _accessToken = null;
    _expiration = null;
    _authCookie = null;
    _refresher?.cancel();
    _refresher = null;
    if (kIsMobile) {
      WebStorageManager.instance().android.deleteAllData();
      CookieManager.instance().deleteAllCookies();
    }
    notifyListeners();
    updatePersistence(clearNullEntries: true);
  }

  @override
  String toString() {
    return "Auth(accessToken: $accessToken, expiration:  $expiration, isLoggedIn: $isLoggedIn, isAnonymous: $isAnonymous, authCookie: $authCookie)";
  }

  @override
  FutureOr<void> loadFromLocal(Map<String, dynamic> map) async {
    _accessToken = map["accessToken"];
    _expiration = map["expiration"] != null
        ? DateTime.tryParse(map["expiration"])
        : _expiration;
    _authCookie = map["authCookie"];
    if (isExpired) {
      final data = await ServiceUtils.getAccessToken(authCookie!);
      _accessToken = data.accessToken;
      _expiration = data.expiration;
    }
    _restartRefresher();
  }

  @override
  FutureOr<Map<String, dynamic>> toMap() {
    return {
      "accessToken": _accessToken,
      "expiration": _expiration.toString(),
      "authCookie": _authCookie,
    };
  }
}

final authProvider = ChangeNotifierProvider<Auth>((ref) => Auth());
