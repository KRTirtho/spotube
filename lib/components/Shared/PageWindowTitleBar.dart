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
  Size get preferredSize => Size.fromHeight(appWindow.titleBarHeight);

  @override
  Widget build(BuildContext context) {
    return WindowTitleBarBox(
      child: Row(
        children: [
          if (Platform.isMacOS)
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.07,
            ),
          if (leading != null) leading!,
          Expanded(child: MoveWindow(child: Center(child: center))),
          if (!Platform.isMacOS) const TitleBarActionButtons()
        ],
      ),
    );
  }
}
