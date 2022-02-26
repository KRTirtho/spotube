import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:spotube/components/Home/Sidebar.dart';
import 'package:spotube/hooks/useBreakpoints.dart';
import 'package:spotube/models/sideBarTiles.dart';

class SpotubeNavigationBar extends HookWidget {
  final int selectedIndex;
  final void Function(int) onSelectedIndexChanged;

  const SpotubeNavigationBar({
    required this.selectedIndex,
    required this.onSelectedIndexChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final breakpoint = useBreakpoints();

    if (breakpoint.isMoreThan(Breakpoints.sm)) return Container();
    return NavigationBar(
      destinations: [
        ...sidebarTileList.map(
          (e) => NavigationDestination(icon: Icon(e.icon), label: e.title),
        ),
        const NavigationDestination(
          icon: Icon(Icons.settings_rounded),
          label: "Settings",
        )
      ],
      selectedIndex: selectedIndex,
      onDestinationSelected: (i) => Sidebar.goToSettings(context),
    );
  }
}
