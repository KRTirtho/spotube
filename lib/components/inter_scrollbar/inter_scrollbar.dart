import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:spotube/utils/platform.dart';

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
    if (kIsDesktop) return child;

    return DraggableScrollbar.semicircle(
      controller: controller,
      child: child,
    );
  }
}
