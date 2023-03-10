import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:spotube/utils/platform.dart';

import 'package:window_manager/window_manager.dart';

class PageWindowTitleBar extends StatefulHookWidget
    implements PreferredSizeWidget {
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final IconThemeData? actionsIconTheme;
  final bool? centerTitle;
  final double? titleSpacing;
  final double toolbarOpacity;
  final double? leadingWidth;
  final TextStyle? toolbarTextStyle;
  final TextStyle? titleTextStyle;
  final double? titleWidth;
  final Widget? title;

  const PageWindowTitleBar({
    Key? key,
    this.actions,
    this.title,
    this.toolbarOpacity = 1,
    this.backgroundColor,
    this.actionsIconTheme,
    this.automaticallyImplyLeading = false,
    this.centerTitle,
    this.foregroundColor,
    this.leading,
    this.leadingWidth,
    this.titleSpacing,
    this.titleTextStyle,
    this.titleWidth,
    this.toolbarTextStyle,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<PageWindowTitleBar> createState() => _PageWindowTitleBarState();
}

class _PageWindowTitleBarState extends State<PageWindowTitleBar> {
  @override
  Widget build(BuildContext context) {
    final isMaximized = useState<bool?>(null);

    maximizeOrRestore() async {
      if (await windowManager.isMaximized()) {
        await windowManager.unmaximize();
        isMaximized.value = false;
      } else {
        await windowManager.maximize();
        isMaximized.value = true;
      }
    }

    return GestureDetector(
      onHorizontalDragStart: (details) {
        if (kIsDesktop) {
          windowManager.startDragging();
        }
      },
      onVerticalDragStart: (details) {
        if (kIsDesktop) {
          windowManager.startDragging();
        }
      },
      child: AppBar(
        leading: widget.leading,
        automaticallyImplyLeading: widget.automaticallyImplyLeading,
        actions: [
          ...?widget.actions,
          if (kIsDesktop && !kIsMacOS) ...[
            IconButton(
              icon: const Icon(Icons.minimize),
              onPressed: () => windowManager.minimize(),
            ),
            IconButton(
              icon: Icon(
                isMaximized.value ?? false
                    ? Icons.fullscreen_exit
                    : Icons.fullscreen,
              ),
              onPressed: maximizeOrRestore,
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => windowManager.close(),
            ),
          ]
        ],
        backgroundColor: widget.backgroundColor,
        foregroundColor: widget.foregroundColor,
        actionsIconTheme: widget.actionsIconTheme,
        centerTitle: widget.centerTitle,
        titleSpacing: widget.titleSpacing,
        toolbarOpacity: widget.toolbarOpacity,
        leadingWidth: widget.leadingWidth,
        toolbarTextStyle: widget.toolbarTextStyle,
        titleTextStyle: widget.titleTextStyle,
        title: widget.title,
      ),
    );
  }
}
