import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

class PageWindowTitleBar extends StatelessWidget {
  final Widget? leading;
  final Widget? center;
  const PageWindowTitleBar({Key? key, this.leading, this.center})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return WindowTitleBarBox(
      child: Row(
        children: [
          if (leading != null) leading!,
          Expanded(child: MoveWindow(child: Center(child: center))),
          MinimizeWindowButton(animate: true),
          MaximizeWindowButton(animate: true),
          CloseWindowButton(animate: true),
        ],
      ),
    );
  }
}
