import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:spotube/provider/authentication_provider.dart';
import 'package:spotube/utils/platform.dart';

const _userAgent =
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/105.0.0.0 Safari/537.36";

class WebViewLogin extends HookConsumerWidget {
  const WebViewLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final mounted = useIsMounted();
    final authenticationNotifier =
        ref.watch(AuthenticationNotifier.provider.notifier);

    if (kIsDesktop) {
      return const Scaffold(
        body: Center(
          child: Text('This feature is not available on desktop'),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: InAppWebView(
          initialOptions: InAppWebViewGroupOptions(
            crossPlatform: InAppWebViewOptions(
              userAgent: _userAgent,
            ),
          ),
          initialUrlRequest: URLRequest(
            url: Uri.parse("https://accounts.spotify.com/"),
          ),
          androidOnPermissionRequest: (controller, origin, resources) async {
            return PermissionRequestResponse(
              resources: resources,
              action: PermissionRequestResponseAction.GRANT,
            );
          },
          onLoadStop: (controller, action) async {
            if (action == null) return;
            String url = action.toString();
            if (url.endsWith("/")) {
              url = url.substring(0, url.length - 1);
            }

            final exp = RegExp(r"https:\/\/accounts.spotify.com\/.+\/status");

            if (exp.hasMatch(url)) {
              final cookies =
                  await CookieManager.instance().getCookies(url: action);
              final spDcCookie = cookies.firstWhereOrNull((element) => element.name == "sp_dc");

              if (spDcCookie != null) {
                final cookieHeader = "sp_dc=${spDcCookie.value}";

                authenticationNotifier.setCredentials(
                  await AuthenticationCredentials.fromCookie(cookieHeader),
                );
                if (mounted()) {
                  // ignore: use_build_context_synchronously
                  GoRouter.of(context).pushReplacementNamed("/");
                }
              }
            }
          },
        ),
      ),
    );
  }
}