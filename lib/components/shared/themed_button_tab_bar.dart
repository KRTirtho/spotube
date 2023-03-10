import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ThemedButtonsTabBar extends HookWidget implements PreferredSizeWidget {
  final List<String> tabs;
  const ThemedButtonsTabBar({Key? key, required this.tabs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ButtonsTabBar(
        radius: 100,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(15),
        ),
        labelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
        borderWidth: 0,
        unselectedDecoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(15),
        ),
        unselectedLabelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
        tabs: tabs.map((tab) {
          return Tab(text: "   $tab   ");
        }).toList(),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
