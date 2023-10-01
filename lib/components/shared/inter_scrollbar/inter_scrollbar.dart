import 'package:flutter/material.dart';
import 'package:flutter_desktop_tools/flutter_desktop_tools.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class InterScrollbar extends HookWidget {
  final Widget child;
  final ScrollController? controller;
  final bool? thumbVisibility;
  final bool? trackVisibility;
  final double? thickness;
  final Radius? radius;
  final bool Function(ScrollNotification)? notificationPredicate;
  final bool? interactive;
  final ScrollbarOrientation? scrollbarOrientation;

  const InterScrollbar({
    super.key,
    required this.child,
    this.controller,
    this.thumbVisibility,
    this.trackVisibility,
    this.thickness,
    this.radius,
    this.notificationPredicate,
    this.interactive,
    this.scrollbarOrientation,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (DesktopTools.platform.isDesktop) return child;

    return ScrollbarTheme(
      data: theme.scrollbarTheme.copyWith(
        crossAxisMargin: 10,
        minThumbLength: 80,
        thickness: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.hovered) ||
              states.contains(MaterialState.dragged) ||
              states.contains(MaterialState.pressed)) {
            return 40;
          }
          return 20;
        }),
        radius: const Radius.circular(20),
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.hovered) ||
              states.contains(MaterialState.dragged)) {
            return theme.colorScheme.onSurface.withOpacity(0.5);
          }
          return theme.colorScheme.onSurface.withOpacity(0.3);
        }),
      ),
      child: Scrollbar(
        controller: controller,
        thumbVisibility: thumbVisibility,
        trackVisibility: trackVisibility,
        thickness: thickness,
        radius: radius,
        notificationPredicate: notificationPredicate,
        interactive: interactive ?? true,
        scrollbarOrientation: scrollbarOrientation,
        child: child,
      ),
    );
  }
}
