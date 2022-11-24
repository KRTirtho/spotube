import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:platform_ui/platform_ui.dart';
import 'package:spotube/utils/platform.dart';

class PageWindowTitleBar extends PlatformAppBar {
  PageWindowTitleBar({
    super.backgroundColor,
    List<Widget>? actions,
    super.actionsIconTheme,
    super.automaticallyImplyLeading = false,
    super.centerTitle,
    super.foregroundColor,
    super.key,
    super.leading,
    super.leadingWidth,
    Widget? center,
    super.titleSpacing,
    super.titleTextStyle,
    super.titleWidth,
    super.toolbarOpacity,
    super.toolbarTextStyle,
  }) : super(
          actions: [
            ...?actions,
            if (!kIsMacOS && !kIsMobile)
              platform == TargetPlatform.linux
                  ? MoveWindow(child: const PlatformWindowButtons())
                  : const PlatformWindowButtons(),
          ],
          title: platform == TargetPlatform.linux
              ? MoveWindow(child: Center(child: center))
              : center,
        );

  @override
  Widget build(BuildContext context) {
    return MoveWindow(child: super.build(context));
  }
}
