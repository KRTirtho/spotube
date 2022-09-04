import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/components/Home/Sidebar.dart';
import 'package:spotube/hooks/useBreakpoints.dart';
import 'package:spotube/models/sideBarTiles.dart';
import 'package:spotube/provider/Downloader.dart';

class SpotubeNavigationBar extends HookConsumerWidget {
  final int selectedIndex;
  final void Function(int) onSelectedIndexChanged;

  const SpotubeNavigationBar({
    required this.selectedIndex,
    required this.onSelectedIndexChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final downloadCount = ref.watch(
      downloaderProvider.select((s) => s.currentlyRunning),
    );
    final breakpoint = useBreakpoints();

    if (breakpoint.isMoreThan(Breakpoints.sm)) return const SizedBox();
    return NavigationBar(
      destinations: [
        ...sidebarTileList.map(
          (e) {
            final icon = Icon(e.icon);
            return NavigationDestination(
              icon: e.title == "Library" && downloadCount > 0
                  ? Badge(
                      badgeColor: Colors.red[100]!,
                      badgeContent: Text(
                        downloadCount.toString(),
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      animationType: BadgeAnimationType.fade,
                      child: icon,
                    )
                  : icon,
              label: e.title,
            );
          },
        ),
        const NavigationDestination(
          icon: Icon(Icons.settings_rounded),
          label: "Settings",
        )
      ],
      selectedIndex: selectedIndex,
      onDestinationSelected: (i) {
        if (i == 4) {
          Sidebar.goToSettings(context);
        } else {
          onSelectedIndexChanged(i);
        }
      },
    );
  }
}
