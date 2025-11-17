import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart' show Badge;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:spotube/collections/routes.gr.dart';
import 'package:spotube/collections/side_bar_tiles.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/titlebar/titlebar.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/provider/download_manager_provider.dart';

@RoutePage()
class LibraryPage extends HookConsumerWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final downloadingCount = ref
        .watch(downloadManagerProvider)
        .where((e) =>
            e.status == DownloadStatus.downloading ||
            e.status == DownloadStatus.queued)
        .length;
    final router = context.watchRouter;
    final sidebarLibraryTileList = useMemoized(
      () => [
        ...getSidebarLibraryTileList(context.l10n),
        SideBarTiles(
          id: "downloads",
          pathPrefix: "library/downloads",
          title: context.l10n.downloads,
          route: const UserDownloadsRoute(),
          icon: SpotubeIcons.download,
        ),
      ],
      [context.l10n],
    );
    final index = sidebarLibraryTileList.indexWhere(
      (e) => router.currentPath.startsWith(e.pathPrefix),
    );

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        context.navigateTo(const HomeRoute());
      },
      child: SafeArea(
        bottom: false,
        child: LayoutBuilder(builder: (context, constraints) {
          return Scaffold(
            headers: [
              if (constraints.smAndDown)
                TitleBar(
                  automaticallyImplyLeading: false,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: TabList(
                      index: index,
                      onChanged: (index) {
                        context.navigateTo(sidebarLibraryTileList[index].route);
                      },
                      children: [
                        for (final tile in sidebarLibraryTileList)
                          TabItem(
                            child: Badge(
                              isLabelVisible: tile.id == 'downloads' &&
                                  downloadingCount > 0,
                              label: Text(downloadingCount.toString()),
                              child: Text(tile.title),
                            ),
                          ),
                      ],
                    ),
                  ),
                )
              else
                const TitleBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.transparent,
                  surfaceBlur: 0,
                  height: 32,
                ),
              const Gap(10),
            ],
            child: const AutoRouter(),
          );
        }),
      ),
    );
  }
}
