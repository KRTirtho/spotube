import 'dart:convert';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:desktop_webview_window/desktop_webview_window.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_js/flutter_js.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' hide join;
import 'package:spotube/collections/routes.dart';
import 'package:spotube/collections/routes.gr.dart';
import 'package:spotube/pages/mobile_login/no_webview_runtime_dialog.dart';
import 'package:spotube/utils/platform.dart';

class WebviewInitialSettings {
  final String? userAgent;
  final bool? incognito;
  final bool? clearCache;
  final bool? clearSessionCache;

  WebviewInitialSettings({
    this.userAgent,
    this.incognito,
    this.clearCache,
    this.clearSessionCache,
  });

  factory WebviewInitialSettings.fromJson(Map<String, dynamic> json) {
    return WebviewInitialSettings(
      userAgent: json["userAgent"],
      incognito: json["incognito"],
      clearCache: json["clearCache"],
      clearSessionCache: json["clearSessionCache"],
    );
  }
}

class PluginWebViewApi {
  JavascriptRuntime runtime;

  PluginWebViewApi({
    required this.runtime,
  }) {
    runtime.onMessage("WebView.show", (args) {
      if (args[0] is! Map) {
        return;
      }
      showWebView(
        url: args[0]["url"] as String,
        initialSettings: WebviewInitialSettings.fromJson(
          args[0]["initialSettings"],
        ),
      );
    });
  }

  Future showWebView({
    required String url,
    WebviewInitialSettings? initialSettings,
  }) async {
    if (rootNavigatorKey.currentContext == null) {
      return;
    }
    final context = rootNavigatorKey.currentContext!;
    final theme = Theme.of(context);

    if (kIsMobile || kIsMacOS) {
      context.pushRoute(WebviewRoute(
        initialSettings: initialSettings,
        url: url,
        onLoadStop: (controller, uri) async {
          if (uri == null) return;
          final cookies = await CookieManager().getAllCookies();

          final jsonCookies = cookies.map((e) {
            return {
              "name": e.name,
              "value": e.value,
              "domain": e.domain,
              "path": e.path,
            };
          });

          runtime.onMessage("WebView.close", (args) {
            context.back();
          });

          runtime.evaluate(
            """
            eventEmitter.emit('WebView.onLoadFinish', {url: '${uri.toString()}', cookies: ${jsonEncode(jsonCookies)}});
            """,
          );
        },
      ));
      return;
    }

    try {
      final applicationSupportDir = await getApplicationSupportDirectory();
      final userDataFolder = Directory(
        join(applicationSupportDir.path, "webview_window_Webview2"),
      );

      if (!await userDataFolder.exists()) {
        await userDataFolder.create();
      }

      final webview = await WebviewWindow.create(
        configuration: CreateConfiguration(
          title: "Webview",
          titleBarTopPadding: kIsMacOS ? 20 : 0,
          windowHeight: 720,
          windowWidth: 1280,
          userDataFolderWindows: userDataFolder.path,
        ),
      );

      runtime.onMessage("WebView.close", (args) {
        webview.close();
      });

      webview
        ..setBrightness(theme.colorScheme.brightness)
        ..launch(url)
        ..setOnUrlRequestCallback((url) {
          () async {
            final cookies = await webview.getAllCookies();
            final jsonCookies = cookies.map((e) {
              return {
                "name": e.name,
                "value": e.value,
                "domain": e.domain,
                "path": e.path,
              };
            });

            runtime.evaluate(
              """
              eventEmitter.emit('WebView.onLoadFinish', {url: '$url', cookies: ${jsonEncode(jsonCookies)}});
              """,
            );
          }();
          return false;
        });
    } on PlatformException catch (_) {
      if (!await WebviewWindow.isWebviewAvailable()) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          showDialog(
            context: context,
            builder: (context) {
              return const NoWebviewRuntimeDialog();
            },
          );
        });
      }
    }
  }
}
