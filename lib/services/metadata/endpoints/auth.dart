import 'package:desktop_webview_window/desktop_webview_window.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hetu_script/hetu_script.dart';
import 'package:hetu_std/hetu_std.dart';
import 'package:spotube/utils/platform.dart';

class MetadataAuthEndpoint {
  final Hetu hetu;

  MetadataAuthEndpoint(this.hetu);

  Stream get authStateStream =>
      hetu.eval("metadataPlugin.auth.authStateStream");

  Future<void> authenticate() async {
    await hetu.eval("metadataPlugin.auth.authenticate()");
  }

  bool isAuthenticated() {
    return hetu.eval("metadataPlugin.auth.isAuthenticated()") as bool;
  }

  Future<void> logout() async {
    await hetu.eval("metadataPlugin.auth.logout()");
    if (kIsMobile) {
      WebStorageManager.instance().deleteAllData();
      CookieManager.instance().deleteAllCookies();
    }
    if (kIsDesktop) {
      await WebviewWindow.clearAll();
    }
  }
}
