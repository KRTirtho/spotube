import 'package:auto_route/auto_route.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:spotube/components/button/back_button.dart';
import 'package:spotube/components/titlebar/titlebar.dart';
import 'package:spotube/services/metadata/apis/webview.dart';

@RoutePage()
class WebviewPage extends StatelessWidget {
  final WebviewInitialSettings? initialSettings;
  final String? url;
  final void Function(InAppWebViewController controller, WebUri? url)?
      onLoadStop;

  const WebviewPage({
    super.key,
    this.initialSettings,
    this.url,
    this.onLoadStop,
  });

  @override
  Widget build(BuildContext context) {
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
            userAgent: initialSettings?.userAgent ??
                "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/105.0.0.0 safari/537.36",
            incognito: initialSettings?.incognito ?? false,
            clearCache: initialSettings?.clearCache ?? false,
            clearSessionCache: initialSettings?.clearSessionCache ?? false,
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
          onLoadStop: onLoadStop,
        ),
      ),
    );
  }
}
