import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

class TitleBarActionButtons extends StatelessWidget {
  const TitleBarActionButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextButton(
            onPressed: () {
              appWindow.minimize();
            },
            style: ButtonStyle(
              foregroundColor:
                  MaterialStateProperty.all(Theme.of(context).iconTheme.color),
            ),
            child: const Icon(Icons.minimize_rounded)),
        TextButton(
            onPressed: () {
              appWindow.maximizeOrRestore();
            },
            style: ButtonStyle(
              foregroundColor:
                  MaterialStateProperty.all(Theme.of(context).iconTheme.color),
            ),
            child: const Icon(Icons.crop_square_rounded)),
        TextButton(
            onPressed: () {
              appWindow.close();
            },
            style: ButtonStyle(
              foregroundColor:
                  MaterialStateProperty.all(Theme.of(context).iconTheme.color),
              overlayColor: MaterialStateProperty.all(Colors.redAccent),
            ),
            child: const Icon(
              Icons.close_rounded,
            )),
      ],
    );
  }
}

class PageWindowTitleBar extends StatelessWidget
    implements PreferredSizeWidget {
  final Widget? leading;
  final Widget? center;
  const PageWindowTitleBar({Key? key, this.leading, this.center})
      : super(key: key);
  @override
  Size get preferredSize => Size.fromHeight(
        !Platform.isIOS && !Platform.isAndroid ? appWindow.titleBarHeight : 35,
      );

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS || Platform.isAndroid) {
      return PreferredSize(
        preferredSize: const Size.fromHeight(300),
        child: Row(
          children: [
            if (leading != null) leading!,
            Expanded(child: Center(child: center)),
          ],
        ),
      );
    }
    return WindowTitleBarBox(
      child: Container(
        color: Theme.of(context).backgroundColor,
        child: Row(
          children: [
            if (Platform.isMacOS)
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.045,
              ),
            if (leading != null) leading!,
            Expanded(child: MoveWindow(child: Center(child: center))),
            if (!Platform.isMacOS && !Platform.isIOS && !Platform.isAndroid)
              const TitleBarActionButtons()
          ],
        ),
      ),
    );
  }
}
