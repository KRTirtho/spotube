import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/collections/routes.gr.dart';
import 'package:spotube/collections/side_bar_tiles.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/provider/download_manager_provider.dart';
import 'package:spotube/theme/spotify_colors.dart';
import 'package:spotube/theme/spotify_typography.dart';

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
            backgroundColor: SpotifyColors.background,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (constraints.smAndDown)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TabList(
                      index: index,
                      onChanged: (index) {
                        context.navigateTo(sidebarLibraryTileList[index].route);
                      },
                      children: [
                        for (final tile in sidebarLibraryTileList)
                          _SpotifyTabItem(
                            selected: index == sidebarLibraryTileList.indexOf(tile),
                            label: tile.title,
                            badge: tile.id == 'downloads' && downloadingCount > 0
                                ? downloadingCount.toString()
                                : null,
                            onPressed: () =>
                                context.navigateTo(tile.route),
                          ),
                      ],
                    ),
                  )
                else
                  const SizedBox(height: 10),
                const SizedBox(height: 10),
                Expanded(child: const AutoRouter()),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _SpotifyTabItem extends HookConsumerWidget {
  final bool selected;
  final String label;
  final String? badge;
  final VoidCallback onPressed;

  const _SpotifyTabItem({
    required this.selected,
    required this.label,
    this.badge,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context, ref) {
    final textTheme = SpotifyTypography.buildTextTheme(context);
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: 32,
        decoration: BoxDecoration(
          color: selected ? SpotifyColors.hover : Colors.transparent,
          borderRadius: BorderRadius.circular(500),
        ),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          label,
          style: textTheme.labelMedium?.copyWith(
            color: selected
                ? SpotifyColors.primaryText
                : SpotifyColors.secondaryText,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
