import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:platform_ui/platform_ui.dart';
import 'package:spotube/utils/platform.dart';
import 'package:window_manager/window_manager.dart';

class PageWindowTitleBar extends StatefulHookWidget with PreferredSizeWidget {
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
  final Widget? center;
  final bool hideWhenWindows;

  PageWindowTitleBar({
    Key? key,
    this.actions,
    this.center,
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
    this.hideWhenWindows = true,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(
        platform == TargetPlatform.windows ? 33 : kToolbarHeight,
      );

  @override
  State<PageWindowTitleBar> createState() => _PageWindowTitleBarState();
}

class _PageWindowTitleBarState extends State<PageWindowTitleBar> {
  @override
  Widget build(BuildContext context) {
    final isMaximized = useState<bool?>(null);

    useEffect(() {
      if (platform == TargetPlatform.windows &&
          widget.hideWhenWindows &&
          Navigator.of(context).canPop()) {
        final entry = OverlayEntry(
          builder: (context) => const Positioned(
            left: 5,
            top: 5,
            child: PlatformBackButton(),
          ),
        );

        WidgetsBinding.instance.addPostFrameCallback((_) {
          Overlay.of(context)?.insert(entry);
        });

        return () {
          entry.remove();
        };
      }
      return null;
    }, [platform, widget.hideWhenWindows]);

    if (platform == TargetPlatform.windows && widget.hideWhenWindows) {
      return const SizedBox.shrink();
    }

    maximizeOrRestore() async {
      if (await windowManager.isMaximized()) {
        await windowManager.unmaximize();
        isMaximized.value = false;
      } else {
        await windowManager.maximize();
        isMaximized.value = true;
      }
    }

    return PlatformAppBar(
      actions: [
        ...?widget.actions,
        if (!kIsMacOS && !kIsMobile)
          PlatformWindowButtons(
            isMaximized: () async =>
                isMaximized.value ?? await windowManager.isMaximized(),
            onMaximize: maximizeOrRestore,
            onRestore: maximizeOrRestore,
            onMinimize: () {
              windowManager.minimize();
            },
            onClose: () {
              windowManager.close();
            },
            showCloseButton: true,
            showMaximizeButton: true,
            showMinimizeButton: true,
          ),
      ],
      onDrag: () {
        if (kIsDesktop) windowManager.startDragging();
      },
      title: widget.center,
      toolbarOpacity: widget.toolbarOpacity,
      backgroundColor: widget.backgroundColor,
      actionsIconTheme: widget.actionsIconTheme,
      automaticallyImplyLeading: widget.automaticallyImplyLeading,
      centerTitle: widget.centerTitle,
      foregroundColor: widget.foregroundColor,
      leading: widget.leading,
      leadingWidth: widget.leadingWidth,
      titleSpacing: widget.titleSpacing,
      titleTextStyle: widget.titleTextStyle,
      titleWidth: widget.titleWidth,
      toolbarTextStyle: widget.toolbarTextStyle,
    );
  }
}
