import 'package:flutter/material.dart' show Badge;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:spotube/collections/side_bar_tiles.dart';
import 'package:spotube/components/titlebar/titlebar.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/provider/download_manager_provider.dart';

class LibraryPage extends HookConsumerWidget {
  final Widget child;
  const LibraryPage({super.key, required this.child});

  @override
  Widget build(BuildContext context, ref) {
    final downloadingCount = ref.watch(downloadManagerProvider).$downloadCount;
    final routerState = GoRouterState.of(context);
    final sidebarLibraryTileList = useMemoized(
      () => getSidebarLibraryTileList(context.l10n),
      [context.l10n],
    );
    final index = sidebarLibraryTileList.indexWhere(
      (e) => routerState.namedLocation(e.name) == routerState.matchedLocation,
    );

    return SafeArea(
      bottom: false,
      child: LayoutBuilder(builder: (context, constraints) {
        return Scaffold(
          headers: [
            if (constraints.smAndDown)
              TitleBar(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: TabList(
                    index: index,
                    children: [
                      for (final tile in sidebarLibraryTileList)
                        TabButton(
                          child: Badge(
                            isLabelVisible:
                                tile.id == 'downloads' && downloadingCount > 0,
                            label: Text(downloadingCount.toString()),
                            child: Text(tile.title),
                          ),
                          onPressed: () {
                            context.goNamed(tile.name);
                          },
                        ),
                    ],
                  ),
                ),
              ),
            const Gap(10),
          ],
          child: child,
        );
      }),
    );
  }
}
