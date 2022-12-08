import 'package:flutter/material.dart';

class ColoredTabBar extends ColoredBox implements PreferredSizeWidget {
  @override
  // ignore: overridden_fields
  final TabBar child;

  const ColoredTabBar({
    required super.color,
    required this.child,
    super.key,
  }) : super(child: child);

  @override
  Size get preferredSize => child.preferredSize;
}
