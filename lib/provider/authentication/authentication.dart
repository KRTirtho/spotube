import 'dart:async';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:desktop_webview_window/desktop_webview_window.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:drift/drift.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart'
    hide X509Certificate;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/collections/routes.dart';
import 'package:spotube/components/dialogs/prompt_dialog.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/models/database/database.dart';
import 'package:spotube/provider/database/database.dart';
import 'package:spotube/utils/platform.dart';

extension ExpirationAuthenticationTableData on AuthenticationTableData {
  bool get isExpired => DateTime.now().isAfter(expiration);

  String? getCookie(String key) => cookie.value
      .split("; ")
      .firstWhereOrNull((c) => c.trim().startsWith("$key="))
      ?.trim()
      .split("=")
      .last
      .replaceAll(";", "");
}

class AuthenticationNotifier extends AsyncNotifier<AuthenticationTableData?> {
  static final Dio dio = () {
    final dio = Dio();

    (dio.httpClientAdapter as IOHttpClientAdapter)
        .createHttpClient = () => HttpClient()
      ..badCertificateCallback = (X509Certificate cert, String host, int port) {
        return host.endsWith("spotify.com") && port == 443;
      };

    return dio;
  }();

  @override
  build() async {
    final database = ref.watch(databaseProvider);

    final data = await (database.select(database.authenticationTable)
          ..where((s) => s.id.equals(0)))
        .getSingleOrNull();

    Timer? refreshTimer;

    ref.listenSelf((prevData, newData) async {
      if (newData.asData?.value == null) return;

      if (newData.asData!.value!.isExpired) {
        await refreshCredentials();
      }

      // set the refresh timer
      refreshTimer?.cancel();
      refreshTimer = Timer(
        newData.asData!.value!.expiration.difference(DateTime.now()),
        () => refreshCredentials(),
      );
    });

    final subscription =
        database.select(database.authenticationTable).watch().listen(
      (event) {
        state = AsyncData(event.isEmpty ? null : event.first);
      },
    );

    ref.onDispose(() {
      subscription.cancel();
      refreshTimer?.cancel();
    });

    return data;
  }

  Future<void> refreshCredentials() async {
    final database = ref.read(databaseProvider);
    final refreshedCredentials =
        await credentialsFromCookie(state.asData!.value!.cookie.value);

    await database
        .update(database.authenticationTable)
        .replace(refreshedCredentials);
  }

  Future<void> login(String cookie) async {
    final database = ref.read(databaseProvider);
    final refreshedCredentials = await credentialsFromCookie(cookie);

    await database
        .into(database.authenticationTable)
        .insert(refreshedCredentials, mode: InsertMode.replace);
  }

  Future<AuthenticationTableCompanion> credentialsFromCookie(
    String cookie,
  ) async {
    try {
      final spDc = cookie
          .split("; ")
          .firstWhereOrNull((c) => c.trim().startsWith("sp_dc="))
          ?.trim();
      final res = await dio.getUri(
        Uri.parse(
          "https://open.spotify.com/get_access_token?reason=transport&productType=web_player",
        ),
        options: Options(
          headers: {
            "Cookie": spDc ?? "",
            "User-Agent":
                "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36"
          },
          validateStatus: (status) => true,
        ),
      );
      final body = res.data;

      if ((res.statusCode ?? 500) >= 400) {
        throw Exception(
          "Failed to get access token: ${body['error'] ?? res.statusMessage}",
        );
      }

      return AuthenticationTableCompanion.insert(
        id: const Value(0),
        cookie: DecryptedText("${res.headers["set-cookie"]?.join(";")}; $spDc"),
        accessToken: DecryptedText(body['accessToken']),
        expiration: DateTime.fromMillisecondsSinceEpoch(
          body['accessTokenExpirationTimestampMs'],
        ),
      );
    } catch (e) {
      if (rootNavigatorKey.currentContext != null) {
        showPromptDialog(
          context: rootNavigatorKey.currentContext!,
          title: rootNavigatorKey.currentContext!.l10n
              .error("Authentication Failure"),
          message: e.toString(),
          cancelText: null,
        );
      }
      rethrow;
    }
  }

  Future<void> logout() async {
    state = const AsyncData(null);
    final database = ref.read(databaseProvider);
    await (database.delete(database.authenticationTable)
          ..where((s) => s.id.equals(0)))
        .go();
    if (kIsMobile) {
      WebStorageManager.instance().deleteAllData();
      CookieManager.instance().deleteAllCookies();
    }
    if (kIsDesktop) {
      await WebviewWindow.clearAll();
    }
  }
}

final authenticationProvider =
    AsyncNotifierProvider<AuthenticationNotifier, AuthenticationTableData?>(
  () => AuthenticationNotifier(),
);
