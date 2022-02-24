import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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
    final width = MediaQuery.of(context).size.width;

    if (width > 400) return Container();
    return NavigationBar(
      destinations: sidebarTileList
          .map(
            (e) => NavigationDestination(icon: Icon(e.icon), label: e.title),
          )
          .toList(),
      selectedIndex: selectedIndex,
      onDestinationSelected: onSelectedIndexChanged,
    );
  }
}
