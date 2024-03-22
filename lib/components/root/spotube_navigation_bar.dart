import 'dart:ui';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:spotube/collections/side_bar_tiles.dart';
import 'package:spotube/components/root/sidebar.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/hooks/utils/use_brightness_value.dart';
import 'package:spotube/provider/download_manager_provider.dart';
import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';
import 'package:spotube/provider/user_preferences/user_preferences_state.dart';

final navigationPanelHeight = StateProvider<double>((ref) => 50);

class SpotubeNavigationBar extends HookConsumerWidget {
  final int? selectedIndex;
  final void Function(int) onSelectedIndexChanged;

  const SpotubeNavigationBar({
    required this.selectedIndex,
    required this.onSelectedIndexChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    final downloadCount = ref.watch(downloadManagerProvider).$downloadCount;
    final mediaQuery = MediaQuery.of(context);
    final layoutMode =
        ref.watch(userPreferencesProvider.select((s) => s.layoutMode));

    final insideSelectedIndex = useState<int>(selectedIndex ?? 0);

    final buttonColor = useBrightnessValue(
      theme.colorScheme.inversePrimary,
      theme.colorScheme.primary.withOpacity(0.2),
    );

    final navbarTileList =
        useMemoized(() => getNavbarTileList(context.l10n), [context.l10n]);

    final panelHeight = ref.watch(navigationPanelHeight);

    useEffect(() {
      if (selectedIndex != null) {
        insideSelectedIndex.value = selectedIndex!;
      }
      return null;
    }, [selectedIndex]);

    if (layoutMode == LayoutMode.extended ||
        (mediaQuery.mdAndUp && layoutMode == LayoutMode.adaptive) ||
        panelHeight < 10) {
      return const SizedBox();
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      height: panelHeight,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: CurvedNavigationBar(
            backgroundColor:
                theme.colorScheme.secondaryContainer.withOpacity(0.72),
            buttonBackgroundColor: buttonColor,
            color: theme.colorScheme.background,
            height: panelHeight,
            animationDuration: const Duration(milliseconds: 350),
            items: navbarTileList.map(
              (e) {
                /// Using this [Builder] as an workaround for the first item's
                /// icon color not updating unless navigating to another page
                return Builder(builder: (context) {
                  return MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Badge(
                      isLabelVisible: e.id == "library" && downloadCount > 0,
                      label: Text(downloadCount.toString()),
                      child: Icon(
                        e.icon,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  );
                });
              },
            ).toList(),
            index: insideSelectedIndex.value,
            onTap: (i) {
              insideSelectedIndex.value = i;
              if (navbarTileList[i].id == "settings") {
                Sidebar.goToSettings(context);
                return;
              }
              onSelectedIndexChanged(i);
            },
          ),
        ),
      ),
    );
  }
}
