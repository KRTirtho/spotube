import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:platform_ui/platform_ui.dart';
import 'package:spotube/components/Home/Sidebar.dart';
import 'package:spotube/hooks/useBreakpoints.dart';
import 'package:spotube/models/sideBarTiles.dart';
import 'package:spotube/provider/Downloader.dart';
import 'package:spotube/provider/UserPreferences.dart';

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
    final layoutMode =
        ref.watch(userPreferencesProvider.select((s) => s.layoutMode));

    final insideSelectedIndex = useState<int>(selectedIndex);

    useEffect(() {
      insideSelectedIndex.value = selectedIndex;
      return null;
    }, [selectedIndex]);

    if (layoutMode == LayoutMode.extended ||
        (breakpoint.isMoreThan(Breakpoints.sm) &&
            layoutMode == LayoutMode.adaptive)) return const SizedBox();
    return PlatformBottomNavigationBar(
      items: [
        ...sidebarTileList.map(
          (e) {
            return PlatformBottomNavigationBarItem(
              icon: e.icon,
              label: e.title,
            );
          },
        ),
        const PlatformBottomNavigationBarItem(
          icon: Icons.settings_rounded,
          label: "Settings",
        )
      ],
      selectedIndex: insideSelectedIndex.value,
      onSelectedIndexChanged: (i) {
        if (i == 4) {
          insideSelectedIndex.value = 4;
          Sidebar.goToSettings(context);
        } else {
          insideSelectedIndex.value = i;
          onSelectedIndexChanged(i);
        }
      },
    );
  }
}
