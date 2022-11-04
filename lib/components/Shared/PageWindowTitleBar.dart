import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:fluent_ui/fluent_ui.dart' show FluentTheme;
import 'package:flutter/material.dart';
import 'package:platform_ui/platform_ui.dart';
import 'package:spotube/utils/platform.dart';

class TitleBarActionButtons extends StatelessWidget {
  final Color? color;
  const TitleBarActionButtons({
    Key? key,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButtonTheme(
      data: TextButtonThemeData(
        style: ButtonStyle(
          splashFactory: NoSplash.splashFactory,
          shape: MaterialStateProperty.all(const RoundedRectangleBorder()),
          overlayColor: MaterialStateProperty.all(Colors.black12),
          padding: MaterialStateProperty.all(EdgeInsets.zero),
          minimumSize: MaterialStateProperty.all(const Size(50, 40)),
          maximumSize: MaterialStateProperty.all(const Size(50, 40)),
        ),
      ),
      child: IconTheme(
        data: const IconThemeData(size: 16),
        child: Row(
          children: [
            TextButton(
                onPressed: () {
                  appWindow.minimize();
                },
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(
                      PlatformTheme.of(context).iconTheme?.color),
                ),
                child: Icon(
                  Icons.minimize_rounded,
                  color: color,
                )),
            TextButton(
                onPressed: () async {
                  appWindow.maximizeOrRestore();
                },
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(
                      PlatformTheme.of(context).iconTheme?.color),
                ),
                child: Icon(
                  Icons.crop_square_rounded,
                  color: color,
                )),
            TextButton(
                onPressed: () {
                  appWindow.close();
                },
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(
                      color ?? PlatformTheme.of(context).iconTheme?.color),
                  overlayColor: MaterialStateProperty.all(Colors.redAccent),
                ),
                child: const Icon(
                  Icons.close_rounded,
                )),
          ],
        ),
      ),
    );
  }
}

class PageWindowTitleBar extends StatelessWidget
    implements PreferredSizeWidget {
  final Widget? leading;
  final Widget? center;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Size? _preferredSize;
  const PageWindowTitleBar({
    Key? key,
    Size? preferredSize,
    this.leading,
    this.center,
    this.backgroundColor,
    this.foregroundColor,
  })  : _preferredSize = preferredSize,
        super(key: key);

  static Size get staticPreferredSize => Size.fromHeight(
        (kIsDesktop ? appWindow.titleBarHeight : 35),
      );

  @override
  Size get preferredSize => _preferredSize ?? staticPreferredSize;

  @override
  Widget build(BuildContext context) {
    if (kIsMobile) {
      return PreferredSize(
        preferredSize: const Size.fromHeight(300),
        child: Container(
          color: backgroundColor,
          child: Row(
            children: [
              if (leading != null) leading!,
              Expanded(child: Center(child: center)),
            ],
          ),
        ),
      );
    }
    return WindowTitleBarBox(
      child: Container(
        color: backgroundColor ??
            FluentTheme.maybeOf(context)?.micaBackgroundColor,
        child: Row(
          children: [
            if (kIsMacOS)
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.045,
              ),
            if (leading != null) leading!,
            Expanded(child: MoveWindow(child: Center(child: center))),
            if (!kIsMacOS && !kIsMobile)
              TitleBarActionButtons(color: foregroundColor)
          ],
        ),
      ),
    );
  }
}
