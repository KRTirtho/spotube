import 'dart:async';
import 'dart:convert';

import 'package:fl_query/fl_query.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart';
import 'package:spotube/collections/routes.dart';
import 'package:spotube/components/shared/dialogs/prompt_dialog.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/utils/persisted_state_notifier.dart';
import 'package:spotube/utils/platform.dart';

class AuthenticationCredentials {
  String cookie;
  String accessToken;
  DateTime expiration;

  bool get isExpired => DateTime.now().isAfter(expiration);

  AuthenticationCredentials({
    required this.cookie,
    required this.accessToken,
    required this.expiration,
  });

  static Future<AuthenticationCredentials> fromCookie(String cookie) async {
    try {
      final res = await get(
        Uri.parse(
          "https://open.spotify.com/get_access_token?reason=transport&productType=web_player",
        ),
        headers: {
          "Cookie": cookie,
          "User-Agent":
              "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/105.0.0.0 Safari/537.36"
        },
      );
      final body = jsonDecode(res.body);

      if (res.statusCode >= 400) {
        throw Exception(
          "Failed to get access token: ${body['error'] ?? res.reasonPhrase}",
        );
      }

      return AuthenticationCredentials(
        cookie: cookie,
        accessToken: body['accessToken'],
        expiration: DateTime.fromMillisecondsSinceEpoch(
          body['accessTokenExpirationTimestampMs'],
        ),
      );
    } catch (e) {
      if (rootNavigatorKey?.currentContext != null &&
          await QueryClient.connectivity.isConnected) {
        showPromptDialog(
          context: rootNavigatorKey!.currentContext!,
          title: rootNavigatorKey!.currentContext!.l10n
              .error("Authentication Failure"),
          message: e.toString(),
          cancelText: null,
        );
      }
      rethrow;
    }
  }

  factory AuthenticationCredentials.fromJson(Map<String, dynamic> json) {
    return AuthenticationCredentials(
      cookie: json['cookie'] as String,
      accessToken: json['accessToken'] as String,
      expiration: DateTime.parse(json['expiration'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cookie': cookie,
      'accessToken': accessToken,
      'expiration': expiration.toIso8601String(),
    };
  }

  AuthenticationCredentials copyWith({
    String? cookie,
    String? accessToken,
    DateTime? expiration,
  }) {
    return AuthenticationCredentials(
      cookie: cookie ?? this.cookie,
      accessToken: accessToken ?? this.accessToken,
      expiration: expiration ?? this.expiration,
    );
  }
}

class AuthenticationNotifier
    extends PersistedStateNotifier<AuthenticationCredentials?> {
  static final provider =
      StateNotifierProvider<AuthenticationNotifier, AuthenticationCredentials?>(
    (ref) => AuthenticationNotifier(),
  );

  bool get isLoggedIn => state != null;

  AuthenticationNotifier() : super(null, "authentication", encrypted: true);

  Timer? _refreshTimer;

  @override
  FutureOr<void> onInit() async {
    super.onInit();
    if (isLoggedIn && state!.isExpired) {
      await refreshCredentials();
    }

    addListener((state) {
      _refreshTimer?.cancel();
      if (isLoggedIn && !state!.isExpired) {
        _refreshTimer = Timer(
          state.expiration.difference(DateTime.now()),
          () => refreshCredentials(),
        );
      }
    });
  }

  void setCredentials(AuthenticationCredentials credentials) {
    state = credentials;
  }

  Future<void> logout() async {
    state = null;
    if (kIsMobile) {
      WebStorageManager.instance().android.deleteAllData();
      CookieManager.instance().deleteAllCookies();
    }
  }

  Future<void> refreshCredentials() async {
    if (!isLoggedIn) {
      return;
    }

    state = await AuthenticationCredentials.fromCookie(state!.cookie);
  }

  @override
  FutureOr<AuthenticationCredentials?> fromJson(Map<String, dynamic> json) {
    return AuthenticationCredentials.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    return state?.toJson() ?? {};
  }
}
