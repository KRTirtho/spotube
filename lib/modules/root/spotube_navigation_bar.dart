import 'package:flutter/material.dart' show Badge;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'package:spotube/collections/side_bar_tiles.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/models/database/database.dart';
import 'package:spotube/provider/download_manager_provider.dart';
import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';

import 'package:spotube/utils/service_utils.dart';

final navigationPanelHeight = StateProvider<double>((ref) => 50);

class SpotubeNavigationBar extends HookConsumerWidget {
  const SpotubeNavigationBar({
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    final routerState = GoRouterState.of(context);

    final downloadCount = ref.watch(downloadManagerProvider).$downloadCount;
    final mediaQuery = MediaQuery.of(context);
    final layoutMode =
        ref.watch(userPreferencesProvider.select((s) => s.layoutMode));

    final navbarTileList = useMemoized(
      () => getNavbarTileList(context.l10n),
      [context.l10n],
    );

    final panelHeight = ref.watch(navigationPanelHeight);

    final selectedIndex = useMemoized(() {
      final index = navbarTileList.indexWhere(
        (e) => routerState.namedLocation(e.name) == routerState.matchedLocation,
      );

      return index == -1 ? 0 : index;
    }, [navbarTileList, routerState.matchedLocation]);

    if (layoutMode == LayoutMode.extended ||
        (mediaQuery.mdAndUp && layoutMode == LayoutMode.adaptive) ||
        panelHeight < 10) {
      return const SizedBox();
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      child: NavigationBar(
        index: selectedIndex,
        onSelected: (i) {
          ServiceUtils.navigateNamed(context, navbarTileList[i].name);
        },
        children: [
          for (final tile in navbarTileList)
            NavigationButton(
              style: const ButtonStyle.muted(density: ButtonDensity.icon),
              selectedStyle:
                  const ButtonStyle.fixed(density: ButtonDensity.icon),
              child: Badge(
                isLabelVisible: tile.id == "library" && downloadCount > 0,
                label: Text(downloadCount.toString()),
                child: Icon(tile.icon),
              ),
            )
        ],
      ),
    );
  }
}
