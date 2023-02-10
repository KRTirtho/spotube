import 'package:flutter/cupertino.dart';
import 'package:platform_ui/platform_ui.dart';
import 'package:spotube/components/root/sidebar.dart';

Future<bool> showPromptDialog({
  required BuildContext context,
  required String title,
  required String message,
  String okText = "Ok",
  String cancelText = "Cancel",
}) async {
  return showPlatformAlertDialog<bool>(
    context,
    builder: (context) {
      return PlatformAlertDialog(
        title: PlatformText(title),
        content: PlatformText(message),
        macosAppIcon: Sidebar.brandLogo(),
        primaryActions: [
          if (platform == TargetPlatform.iOS)
            CupertinoDialogAction(
              isDefaultAction: false,
              isDestructiveAction: true,
              child: PlatformText(okText),
              onPressed: () => Navigator.of(context).pop(true),
            )
          else
            PlatformFilledButton(
              child: PlatformText(okText),
              onPressed: () => Navigator.of(context).pop(true),
            ),
        ],
        secondaryActions: [
          if (platform == TargetPlatform.iOS)
            CupertinoDialogAction(
              isDefaultAction: true,
              child: PlatformText(cancelText),
              onPressed: () => Navigator.of(context).pop(false),
            )
          else
            PlatformFilledButton(
              isSecondary: true,
              onPressed: () => Navigator.of(context).pop(false),
              child: PlatformText(cancelText),
            ),
        ],
      );
    },
  ).then((value) => value ?? false);
}
