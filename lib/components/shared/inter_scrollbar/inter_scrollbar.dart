import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_desktop_tools/flutter_desktop_tools.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class InterScrollbar extends HookWidget {
  final Widget child;
  final ScrollController controller;

  const InterScrollbar({
    super.key,
    required this.child,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    if (DesktopTools.platform.isDesktop) return child;

    return DraggableScrollbar.semicircle(
      controller: controller,
      child: child,
    );
  }
}
