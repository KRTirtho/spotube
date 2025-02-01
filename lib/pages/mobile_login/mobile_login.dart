import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/collections/routes.gr.dart';
import 'package:spotube/components/button/back_button.dart';
import 'package:spotube/components/titlebar/titlebar.dart';

import 'package:spotube/provider/authentication/authentication.dart';
import 'package:spotube/utils/platform.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class WebViewLoginPage extends HookConsumerWidget {
  static const name = "login";
  const WebViewLoginPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final authenticationNotifier = ref.watch(authenticationProvider.notifier);

    if (kIsDesktop) {
      const Scaffold(
        child: Center(
          child: Text('This feature is not available on desktop'),
        ),
      );
    }

    return SafeArea(
      bottom: false,
      child: Scaffold(
        headers: const [
          TitleBar(
            leading: [BackButton(color: Colors.white)],
            backgroundColor: Colors.transparent,
          ),
        ],
        floatingHeader: true,
        child: InAppWebView(
          initialSettings: InAppWebViewSettings(
            userAgent:
                "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/105.0.0.0 safari/537.36",
          ),
          initialUrlRequest: URLRequest(
            url: WebUri("https://accounts.spotify.com/"),
          ),
          onPermissionRequest: (controller, permissionRequest) async {
            return PermissionResponse(
              resources: permissionRequest.resources,
              action: PermissionResponseAction.GRANT,
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
              final cookieHeader =
                  "sp_dc=${cookies.firstWhere((element) => element.name == "sp_dc").value}";

              await authenticationNotifier.login(cookieHeader);
              if (context.mounted) {
                // ignore: use_build_context_synchronously
                context.navigateTo(const HomeRoute());
              }
            }
          },
        ),
      ),
    );
  }
}
