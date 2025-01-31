import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart' show Badge;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:shadcn_flutter/shadcn_flutter_extension.dart';
import 'package:spotube/collections/routes.gr.dart';

import 'package:spotube/collections/side_bar_tiles.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/models/database/database.dart';
import 'package:spotube/provider/download_manager_provider.dart';
import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';

final navigationPanelHeight = StateProvider<double>((ref) => 50);

class SpotubeNavigationBar extends HookConsumerWidget {
  const SpotubeNavigationBar({
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    final mediaQuery = MediaQuery.of(context);

    final downloadCount = ref.watch(downloadManagerProvider).$downloadCount;
    final layoutMode =
        ref.watch(userPreferencesProvider.select((s) => s.layoutMode));

    final navbarTileList = useMemoized(
      () => getNavbarTileList(context.l10n),
      [context.l10n],
    );

    final libraryTiles = useMemoized(
      () => getSidebarLibraryTileList(context.l10n)
          .map((e) => e.route.routeName)
          .toList(),
      [context.l10n],
    );

    final panelHeight = ref.watch(navigationPanelHeight);

    final router = context.watchRouter;
    final selectedIndex = max(
      0,
      navbarTileList.indexWhere(
        (e) =>
            router.topRoute.name == e.route.routeName ||
            (libraryTiles.contains(router.topRoute.name) &&
                e.route.routeName == LibraryRoute.name),
      ),
    );

    if (layoutMode == LayoutMode.extended ||
        (mediaQuery.mdAndUp && layoutMode == LayoutMode.adaptive) ||
        panelHeight < 10) {
      return const SizedBox();
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      height: panelHeight,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Divider(),
            NavigationBar(
              index: selectedIndex,
              surfaceBlur: context.theme.surfaceBlur,
              surfaceOpacity: context.theme.surfaceOpacity,
              onSelected: (i) {
                context.navigateTo(navbarTileList[i].route);
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
          ],
        ),
      ),
    );
  }
}
