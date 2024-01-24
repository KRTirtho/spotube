import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:spotube/hooks/utils/use_breakpoint_value.dart';
import 'package:spotube/hooks/utils/use_brightness_value.dart';
import 'package:spotube/utils/platform.dart';

class ThemedButtonsTabBar extends HookWidget implements PreferredSizeWidget {
  final List<Widget> tabs;
  const ThemedButtonsTabBar({Key? key, required this.tabs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = useBrightnessValue(
      theme.colorScheme.primaryContainer,
      Color.lerp(theme.colorScheme.primary, Colors.black, 0.7)!,
    );

    final breakpoint = useBreakpointValue(
      xs: 85.0,
      sm: 85.0,
      md: 35.0,
      others: 0.0,
    );

    return Padding(
      padding: EdgeInsets.only(
        left: kIsMacOS ? breakpoint : 0,
        top: 8,
        bottom: 8,
      ),
      child: ButtonsTabBar(
        radius: 100,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(15),
        ),
        labelStyle: theme.textTheme.labelLarge?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
        borderWidth: 0,
        unselectedDecoration: BoxDecoration(
          color: theme.colorScheme.background,
          borderRadius: BorderRadius.circular(15),
        ),
        unselectedLabelStyle: theme.textTheme.labelLarge?.copyWith(
          color: theme.colorScheme.primary,
        ),
        tabs: tabs,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
