import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';
import 'package:spotube/utils/platform.dart';
import 'package:titlebar_buttons/titlebar_buttons.dart';
import 'dart:math';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

import 'package:window_manager/window_manager.dart';

class PageWindowTitleBar extends StatefulHookConsumerWidget
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

  final bool _sliver;

  const PageWindowTitleBar({
    super.key,
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
  })  : _sliver = false,
        pinned = false,
        floating = false,
        snap = false,
        stretch = false;

  final bool pinned;
  final bool floating;
  final bool snap;
  final bool stretch;

  const PageWindowTitleBar.sliver({
    super.key,
    this.actions,
    this.title,
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
    this.pinned = false,
    this.floating = false,
    this.snap = false,
    this.stretch = false,
  })  : _sliver = true,
        toolbarOpacity = 1;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  ConsumerState<PageWindowTitleBar> createState() => _PageWindowTitleBarState();
}

class _PageWindowTitleBarState extends ConsumerState<PageWindowTitleBar> {
  void onDrag(details) {
    final systemTitleBar =
        ref.read(userPreferencesProvider.select((s) => s.systemTitleBar));
    if (kIsDesktop && !systemTitleBar) {
      windowManager.startDragging();
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    if (widget._sliver) {
      return SliverLayoutBuilder(
        builder: (context, constraints) {
          final hasFullscreen =
              mediaQuery.size.width == constraints.crossAxisExtent;
          final hasLeadingOrCanPop =
              widget.leading != null || Navigator.canPop(context);

          return SliverPadding(
            padding: EdgeInsets.only(
              left: kIsMacOS && hasFullscreen && hasLeadingOrCanPop ? 65 : 0,
            ),
            sliver: SliverAppBar(
              leading: widget.leading,
              automaticallyImplyLeading: widget.automaticallyImplyLeading,
              actions: [
                ...?widget.actions,
                WindowTitleBarButtons(foregroundColor: widget.foregroundColor),
              ],
              backgroundColor: widget.backgroundColor,
              foregroundColor: widget.foregroundColor,
              actionsIconTheme: widget.actionsIconTheme,
              centerTitle: widget.centerTitle,
              titleSpacing: widget.titleSpacing,
              leadingWidth: widget.leadingWidth,
              toolbarTextStyle: widget.toolbarTextStyle,
              titleTextStyle: widget.titleTextStyle,
              title: SizedBox(
                width: double.infinity, // workaround to force dragging
                child: widget.title ?? const Text(""),
              ),
              pinned: widget.pinned,
              floating: widget.floating,
              snap: widget.snap,
              stretch: widget.stretch,
            ),
          );
        },
      );
    }

    return LayoutBuilder(builder: (context, constrains) {
      final hasFullscreen = mediaQuery.size.width == constrains.maxWidth;
      final hasLeadingOrCanPop =
          widget.leading != null || Navigator.canPop(context);

      return GestureDetector(
        onHorizontalDragStart: onDrag,
        onVerticalDragStart: onDrag,
        child: Padding(
          padding: EdgeInsets.only(
            left: kIsMacOS && hasFullscreen && hasLeadingOrCanPop ? 65 : 0,
          ),
          child: AppBar(
            leading: widget.leading,
            automaticallyImplyLeading: widget.automaticallyImplyLeading,
            actions: [
              ...?widget.actions,
              WindowTitleBarButtons(foregroundColor: widget.foregroundColor),
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
            title: SizedBox(
              width: double.infinity, // workaround to force dragging
              child: widget.title ?? const Text(""),
            ),
            scrolledUnderElevation: 0,
            shadowColor: Colors.transparent,
            forceMaterialTransparency: true,
            elevation: 0,
          ),
        ),
      );
    });
  }
}

class WindowTitleBarButtons extends HookConsumerWidget {
  final Color? foregroundColor;
  const WindowTitleBarButtons({
    super.key,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context, ref) {
    final preferences = ref.watch(userPreferencesProvider);
    final isMaximized = useState<bool?>(null);
    const type = ThemeType.auto;

    Future<void> onClose() async {
      await windowManager.close();
    }

    useEffect(() {
      if (kIsDesktop) {
        windowManager.isMaximized().then((value) {
          isMaximized.value = value;
        });
      }
      return null;
    }, []);

    if (!kIsDesktop || kIsMacOS || preferences.systemTitleBar) {
      return const SizedBox.shrink();
    }

    if (kIsWindows) {
      final theme = Theme.of(context);
      final colors = WindowButtonColors(
        normal: Colors.transparent,
        iconNormal: foregroundColor ?? theme.colorScheme.onBackground,
        mouseOver: theme.colorScheme.onBackground.withOpacity(0.1),
        mouseDown: theme.colorScheme.onBackground.withOpacity(0.2),
        iconMouseOver: theme.colorScheme.onBackground,
        iconMouseDown: theme.colorScheme.onBackground,
      );

      final closeColors = WindowButtonColors(
        normal: Colors.transparent,
        iconNormal: foregroundColor ?? theme.colorScheme.onBackground,
        mouseOver: Colors.red,
        mouseDown: Colors.red[800]!,
        iconMouseOver: Colors.white,
        iconMouseDown: Colors.black,
      );

      return Padding(
        padding: const EdgeInsets.only(bottom: 25),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MinimizeWindowButton(
              onPressed: windowManager.minimize,
              colors: colors,
            ),
            if (isMaximized.value != true)
              MaximizeWindowButton(
                colors: colors,
                onPressed: () {
                  windowManager.maximize();
                  isMaximized.value = true;
                },
              )
            else
              RestoreWindowButton(
                colors: colors,
                onPressed: () {
                  windowManager.unmaximize();
                  isMaximized.value = false;
                },
              ),
            CloseWindowButton(
              colors: closeColors,
              onPressed: onClose,
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 20, left: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DecoratedMinimizeButton(
            type: type,
            onPressed: windowManager.minimize,
          ),
          DecoratedMaximizeButton(
            type: type,
            onPressed: () async {
              if (await windowManager.isMaximized()) {
                await windowManager.unmaximize();
                isMaximized.value = false;
              } else {
                await windowManager.maximize();
                isMaximized.value = true;
              }
            },
          ),
          DecoratedCloseButton(
            type: type,
            onPressed: onClose,
          ),
        ],
      ),
    );
  }
}

typedef WindowButtonIconBuilder = Widget Function(
    WindowButtonContext buttonContext);
typedef WindowButtonBuilder = Widget Function(
    WindowButtonContext buttonContext, Widget icon);

class WindowButtonContext {
  BuildContext context;
  MouseState mouseState;
  Color? backgroundColor;
  Color iconColor;
  WindowButtonContext(
      {required this.context,
      required this.mouseState,
      this.backgroundColor,
      required this.iconColor});
}

class WindowButtonColors {
  late Color normal;
  late Color mouseOver;
  late Color mouseDown;
  late Color iconNormal;
  late Color iconMouseOver;
  late Color iconMouseDown;
  WindowButtonColors(
      {Color? normal,
      Color? mouseOver,
      Color? mouseDown,
      Color? iconNormal,
      Color? iconMouseOver,
      Color? iconMouseDown}) {
    this.normal = normal ?? _defaultButtonColors.normal;
    this.mouseOver = mouseOver ?? _defaultButtonColors.mouseOver;
    this.mouseDown = mouseDown ?? _defaultButtonColors.mouseDown;
    this.iconNormal = iconNormal ?? _defaultButtonColors.iconNormal;
    this.iconMouseOver = iconMouseOver ?? _defaultButtonColors.iconMouseOver;
    this.iconMouseDown = iconMouseDown ?? _defaultButtonColors.iconMouseDown;
  }
}

final _defaultButtonColors = WindowButtonColors(
  normal: Colors.transparent,
  iconNormal: const Color(0xFF805306),
  mouseOver: const Color(0xFF404040),
  mouseDown: const Color(0xFF202020),
  iconMouseOver: const Color(0xFFFFFFFF),
  iconMouseDown: const Color(0xFFF0F0F0),
);

class WindowButton extends StatelessWidget {
  final WindowButtonBuilder? builder;
  final WindowButtonIconBuilder? iconBuilder;
  late final WindowButtonColors colors;
  final bool animate;
  final EdgeInsets? padding;
  final VoidCallback? onPressed;

  WindowButton(
      {super.key,
      WindowButtonColors? colors,
      this.builder,
      @required this.iconBuilder,
      this.padding,
      this.onPressed,
      this.animate = false}) {
    this.colors = colors ?? _defaultButtonColors;
  }

  Color getBackgroundColor(MouseState mouseState) {
    if (mouseState.isMouseDown) return colors.mouseDown;
    if (mouseState.isMouseOver) return colors.mouseOver;
    return colors.normal;
  }

  Color getIconColor(MouseState mouseState) {
    if (mouseState.isMouseDown) return colors.iconMouseDown;
    if (mouseState.isMouseOver) return colors.iconMouseOver;
    return colors.iconNormal;
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Container();
    } else {
      // Don't show button on macOS
      if (Platform.isMacOS) {
        return Container();
      }
    }

    return MouseStateBuilder(
      builder: (context, mouseState) {
        WindowButtonContext buttonContext = WindowButtonContext(
            mouseState: mouseState,
            context: context,
            backgroundColor: getBackgroundColor(mouseState),
            iconColor: getIconColor(mouseState));

        var icon =
            (iconBuilder != null) ? iconBuilder!(buttonContext) : Container();

        var fadeOutColor =
            getBackgroundColor(MouseState()..isMouseOver = true).withOpacity(0);
        var padding = this.padding ?? const EdgeInsets.all(10);
        var animationMs =
            mouseState.isMouseOver ? (animate ? 100 : 0) : (animate ? 200 : 0);
        Widget iconWithPadding = Padding(padding: padding, child: icon);
        iconWithPadding = AnimatedContainer(
            curve: Curves.easeOut,
            duration: Duration(milliseconds: animationMs),
            color: buttonContext.backgroundColor ?? fadeOutColor,
            child: iconWithPadding);
        var button =
            (builder != null) ? builder!(buttonContext, icon) : iconWithPadding;
        return SizedBox(
          width: 45,
          height: 32,
          child: button,
        );
      },
      onPressed: () {
        if (onPressed != null) onPressed!();
      },
    );
  }
}

class MinimizeWindowButton extends WindowButton {
  MinimizeWindowButton(
      {super.key, super.colors, super.onPressed, bool? animate})
      : super(
          animate: animate ?? false,
          iconBuilder: (buttonContext) =>
              MinimizeIcon(color: buttonContext.iconColor),
        );
}

class MaximizeWindowButton extends WindowButton {
  MaximizeWindowButton(
      {super.key, super.colors, super.onPressed, bool? animate})
      : super(
          animate: animate ?? false,
          iconBuilder: (buttonContext) =>
              MaximizeIcon(color: buttonContext.iconColor),
        );
}

class RestoreWindowButton extends WindowButton {
  RestoreWindowButton({super.key, super.colors, super.onPressed, bool? animate})
      : super(
          animate: animate ?? false,
          iconBuilder: (buttonContext) =>
              RestoreIcon(color: buttonContext.iconColor),
        );
}

final _defaultCloseButtonColors = WindowButtonColors(
    mouseOver: const Color(0xFFD32F2F),
    mouseDown: const Color(0xFFB71C1C),
    iconNormal: const Color(0xFF805306),
    iconMouseOver: const Color(0xFFFFFFFF));

class CloseWindowButton extends WindowButton {
  CloseWindowButton(
      {super.key, WindowButtonColors? colors, super.onPressed, bool? animate})
      : super(
          colors: colors ?? _defaultCloseButtonColors,
          animate: animate ?? false,
          iconBuilder: (buttonContext) =>
              CloseIcon(color: buttonContext.iconColor),
        );
}

// Switched to CustomPaint icons by https://github.com/esDotDev

/// Close
class CloseIcon extends StatelessWidget {
  final Color color;
  const CloseIcon({super.key, required this.color});
  @override
  Widget build(BuildContext context) => Align(
        alignment: Alignment.topLeft,
        child: Stack(children: [
          // Use rotated containers instead of a painter because it renders slightly crisper than a painter for some reason.
          Transform.rotate(
              angle: pi * .25,
              child:
                  Center(child: Container(width: 14, height: 1, color: color))),
          Transform.rotate(
              angle: pi * -.25,
              child:
                  Center(child: Container(width: 14, height: 1, color: color))),
        ]),
      );
}

/// Maximize
class MaximizeIcon extends StatelessWidget {
  final Color color;
  const MaximizeIcon({super.key, required this.color});
  @override
  Widget build(BuildContext context) => _AlignedPaint(_MaximizePainter(color));
}

class _MaximizePainter extends _IconPainter {
  _MaximizePainter(super.color);
  @override
  void paint(Canvas canvas, Size size) {
    Paint p = getPaint(color);
    canvas.drawRect(Rect.fromLTRB(0, 0, size.width - 1, size.height - 1), p);
  }
}

/// Restore
class RestoreIcon extends StatelessWidget {
  final Color color;
  const RestoreIcon({
    super.key,
    required this.color,
  });
  @override
  Widget build(BuildContext context) => _AlignedPaint(_RestorePainter(color));
}

class _RestorePainter extends _IconPainter {
  _RestorePainter(super.color);
  @override
  void paint(Canvas canvas, Size size) {
    Paint p = getPaint(color);
    canvas.drawRect(Rect.fromLTRB(0, 2, size.width - 2, size.height), p);
    canvas.drawLine(const Offset(2, 2), const Offset(2, 0), p);
    canvas.drawLine(const Offset(2, 0), Offset(size.width, 0), p);
    canvas.drawLine(
        Offset(size.width, 0), Offset(size.width, size.height - 2), p);
    canvas.drawLine(Offset(size.width, size.height - 2),
        Offset(size.width - 2, size.height - 2), p);
  }
}

/// Minimize
class MinimizeIcon extends StatelessWidget {
  final Color color;
  const MinimizeIcon({super.key, required this.color});
  @override
  Widget build(BuildContext context) => _AlignedPaint(_MinimizePainter(color));
}

class _MinimizePainter extends _IconPainter {
  _MinimizePainter(super.color);
  @override
  void paint(Canvas canvas, Size size) {
    Paint p = getPaint(color);
    canvas.drawLine(
        Offset(0, size.height / 2), Offset(size.width, size.height / 2), p);
  }
}

/// Helpers
abstract class _IconPainter extends CustomPainter {
  _IconPainter(this.color);
  final Color color;

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _AlignedPaint extends StatelessWidget {
  const _AlignedPaint(this.painter);
  final CustomPainter painter;

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.center,
        child: CustomPaint(size: const Size(10, 10), painter: painter));
  }
}

Paint getPaint(Color color, [bool isAntiAlias = false]) => Paint()
  ..color = color
  ..style = PaintingStyle.stroke
  ..isAntiAlias = isAntiAlias
  ..strokeWidth = 1;

typedef MouseStateBuilderCB = Widget Function(
    BuildContext context, MouseState mouseState);

class MouseState {
  bool isMouseOver = false;
  bool isMouseDown = false;
  MouseState();
  @override
  String toString() {
    return "isMouseDown: $isMouseDown - isMouseOver: $isMouseOver";
  }
}

T? _ambiguate<T>(T? value) => value;

class MouseStateBuilder extends StatefulWidget {
  final MouseStateBuilderCB builder;
  final VoidCallback? onPressed;
  const MouseStateBuilder({super.key, required this.builder, this.onPressed});
  @override
  // ignore: library_private_types_in_public_api
  _MouseStateBuilderState createState() => _MouseStateBuilderState();
}

class _MouseStateBuilderState extends State<MouseStateBuilder> {
  late MouseState _mouseState;
  _MouseStateBuilderState() {
    _mouseState = MouseState();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
        onEnter: (event) {
          setState(() {
            _mouseState.isMouseOver = true;
          });
        },
        onExit: (event) {
          setState(() {
            _mouseState.isMouseOver = false;
          });
        },
        child: GestureDetector(
            onTapDown: (_) {
              setState(() {
                _mouseState.isMouseDown = true;
              });
            },
            onTapCancel: () {
              setState(() {
                _mouseState.isMouseDown = false;
              });
            },
            onTap: () {
              setState(() {
                _mouseState.isMouseDown = false;
                _mouseState.isMouseOver = false;
              });
              _ambiguate(WidgetsBinding.instance)!.addPostFrameCallback((_) {
                if (widget.onPressed != null) {
                  widget.onPressed!();
                }
              });
            },
            onTapUp: (_) {},
            child: widget.builder(context, _mouseState)));
  }
}
