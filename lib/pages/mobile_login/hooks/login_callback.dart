import 'dart:io';

import 'package:desktop_webview_window/desktop_webview_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:spotube/pages/mobile_login/mobile_login.dart';
import 'package:spotube/pages/mobile_login/no_webview_runtime_dialog.dart';
import 'package:spotube/provider/authentication/authentication.dart';
import 'package:spotube/utils/platform.dart';

Future<void> Function() useLoginCallback(WidgetRef ref) {
  final context = useContext();
  final theme = Theme.of(context);
  final authNotifier = ref.read(authenticationProvider.notifier);

  return useCallback(() async {
    if (kIsMobile || kIsMacOS) {
      context.pushNamed(WebViewLogin.name);
      return;
    }

    try {
      final exp = RegExp(r"https:\/\/accounts.spotify.com\/.+\/status");
      final applicationSupportDir = await getApplicationSupportDirectory();
      final userDataFolder = Directory(
          join(applicationSupportDir.path, "webview_window_Webview2"));

      if (!await userDataFolder.exists()) {
        await userDataFolder.create();
      }

      final webview = await WebviewWindow.create(
        configuration: CreateConfiguration(
          title: "Spotify Login",
          titleBarTopPadding: kIsMacOS ? 20 : 0,
          windowHeight: 720,
          windowWidth: 1280,
          userDataFolderWindows: userDataFolder.path,
        ),
      );
      webview
        ..setBrightness(theme.colorScheme.brightness)
        ..launch("https://accounts.spotify.com/")
        ..setOnUrlRequestCallback((url) {
          if (exp.hasMatch(url)) {
            webview.getAllCookies().then((cookies) async {
              final cookieHeader =
                  "sp_dc=${cookies.firstWhere((element) => element.name.contains("sp_dc")).value.replaceAll("\u0000", "")}";

              await authNotifier.login(cookieHeader);

              webview.close();
              if (context.mounted) {
                context.go("/");
              }
            });
          }

          return true;
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
  }, [authNotifier, theme, context.go, context.pushNamed]);
}
