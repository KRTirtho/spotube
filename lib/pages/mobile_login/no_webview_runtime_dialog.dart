import 'package:flutter/material.dart';
import 'package:spotube/extensions/context.dart';
import 'package:url_launcher/url_launcher_string.dart';

class NoWebviewRuntimeDialog extends StatelessWidget {
  const NoWebviewRuntimeDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData(:platform) = Theme.of(context);

    return AlertDialog(
      title: Text(context.l10n.webview_not_found),
      content: Text(context.l10n.webview_not_found_description),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(context.l10n.cancel),
        ),
        FilledButton(
          onPressed: () async {
            final url = switch (platform) {
              TargetPlatform.windows =>
                'https://developer.microsoft.com/en-us/microsoft-edge/webview2',
              TargetPlatform.macOS => 'https://www.apple.com/safari/',
              TargetPlatform.linux =>
                'https://webkitgtk.org/reference/webkit2gtk/stable/',
              _ => "",
            };
            if (url.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Unsupported platform')),
              );
            }

            await launchUrlString(url);
          },
          child: Text(switch (platform) {
            TargetPlatform.windows => 'Download Edge WebView2',
            TargetPlatform.macOS => 'Download Safari',
            TargetPlatform.linux => 'Download Webkit2Gtk',
            _ => 'Download Webview',
          }),
        ),
      ],
    );
  }
}
