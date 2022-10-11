import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/provider/Auth.dart';
import 'package:spotube/utils/platform.dart';
import 'package:spotube/utils/service_utils.dart';

class WebViewLogin extends HookConsumerWidget {
  const WebViewLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final mounted = useIsMounted();
    final auth = ref.watch(authProvider);

    if (kIsDesktop) {
      const Scaffold(
        body: Center(
          child: Text('This feature is not available on desktop'),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: InAppWebView(
          initialUrlRequest: URLRequest(
            url: Uri.parse("https://accounts.spotify.com/"),
          ),
          androidOnPermissionRequest: (controller, origin, resources) async {
            return PermissionRequestResponse(
                resources: resources,
                action: PermissionRequestResponseAction.GRANT);
          },
          onLoadStop: (controller, action) async {
            if (action == null) return;
            String url = action.toString();
            if (url.endsWith("/")) {
              url = url.substring(0, url.length - 1);
            }

            final exp = RegExp(r"https:\/\/accounts.spotify.com\/\w+\/status");

            if (exp.hasMatch(url)) {
              final cookies =
                  await CookieManager.instance().getCookies(url: action);
              final cookieHeader =
                  cookies.fold<String>("", (previousValue, element) {
                if (element.name == "sp_dc" || element.name == "sp_key") {
                  return "$previousValue; ${element.name}=${element.value}";
                }
                return previousValue;
              });

              final body = await ServiceUtils.getAccessToken(cookieHeader);
              auth.setAuthState(
                accessToken: body.accessToken,
                authCookie: cookieHeader,
                expiration: body.expiration,
              );
              if (mounted()) {
                // ignore: use_build_context_synchronously
                ServiceUtils.navigate(context, "/");
              }
            }
          },
        ),
      ),
    );
  }
}
