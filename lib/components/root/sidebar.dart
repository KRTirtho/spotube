import 'package:badges/badges.dart';
import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:platform_ui/platform_ui.dart';
import 'package:spotube/collections/side_bar_tiles.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/shared/image/universal_image.dart';
import 'package:spotube/hooks/use_breakpoints.dart';
import 'package:spotube/provider/auth_provider.dart';
import 'package:spotube/provider/downloader_provider.dart';
import 'package:spotube/provider/spotify_provider.dart';

import 'package:spotube/provider/user_preferences_provider.dart';
import 'package:spotube/services/queries/queries.dart';
import 'package:spotube/utils/platform.dart';
import 'package:spotube/utils/type_conversion_utils.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent_ui;

class Sidebar extends HookConsumerWidget {
  final int selectedIndex;
  final void Function(int) onSelectedIndexChanged;
  final Widget child;

  const Sidebar({
    required this.selectedIndex,
    required this.onSelectedIndexChanged,
    required this.child,
    Key? key,
  }) : super(key: key);

  static Widget brandLogo() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Image.asset(
        "assets/spotube-logo.png",
        height: 50,
      ),
    );
  }

  static Widget macSpacer = const SizedBox(height: 25);

  static void goToSettings(BuildContext context) {
    GoRouter.of(context).go("/settings");
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final breakpoints = useBreakpoints();

    final downloadCount = ref.watch(
      downloaderProvider.select((s) => s.currentlyRunning),
    );

    final layoutMode =
        ref.watch(userPreferencesProvider.select((s) => s.layoutMode));

    if (breakpoints.isMd) {
      return Row(
        children: [
          NavigationRail(
            selectedIndex: selectedIndex,
            onDestinationSelected: onSelectedIndexChanged,
            labelType: NavigationRailLabelType.all,
            extended: false,
            backgroundColor: PlatformTheme.of(context).scaffoldBackgroundColor,
            leading: Column(
              children: [
                if (kIsMacOS) macSpacer,
                brandLogo(),
              ],
            ),
            trailing: PlatformIconButton(
              icon: const Icon(fluent_ui.FluentIcons.settings),
              onPressed: () => goToSettings(context),
            ),
            destinations: [
              for (final e in sidebarTileList)
                NavigationRailDestination(
                  icon: Badge(
                    badgeColor: PlatformTheme.of(context).primaryColor!,
                    showBadge: e.title == "Library" && downloadCount > 0,
                    badgeContent: Text(
                      downloadCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                    child: Icon(e.icon),
                  ),
                  label: PlatformText.label(
                    e.title,
                    style: selectedIndex == sidebarTileList.indexOf(e)
                        ? TextStyle(
                            color: PlatformTheme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          )
                        : null,
                  ),
                ),
            ],
          ),
          Container(
            width: 1,
            height: double.infinity,
            color: PlatformTheme.of(context).borderColor,
          ),
          Expanded(child: child)
        ],
      );
    }

    if (layoutMode == LayoutMode.compact ||
        (breakpoints.isSm && layoutMode == LayoutMode.adaptive)) {
      return PlatformScaffold(body: child);
    }

    return SafeArea(
      top: false,
      child: PlatformSidebar(
        currentIndex: selectedIndex,
        onIndexChanged: onSelectedIndexChanged,
        body: Map.fromEntries(
          sidebarTileList.map(
            (e) {
              final icon = Icon(e.icon);
              return MapEntry(
                PlatformSidebarItem(
                  icon: Badge(
                    badgeColor: PlatformTheme.of(context).primaryColor!,
                    showBadge: e.title == "Library" && downloadCount > 0,
                    badgeContent: Text(
                      downloadCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                    child: icon,
                  ),
                  title: Text(
                    e.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                child,
              );
            },
          ),
        ),
        expanded: true,
        header: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              if (kIsMacOS) macSpacer,
              Row(
                children: [
                  brandLogo(),
                  const SizedBox(width: 10),
                  PlatformText.headline("Spotube"),
                ],
              ),
            ],
          ),
        ),
        windowsFooterItems: [
          fluent_ui.PaneItemAction(
            icon: const Icon(SpotubeIcons.settings),
            onTap: () => goToSettings(context),
          ),
        ],
        footer: const SidebarFooter(),
      ),
    );
  }
}

class SidebarFooter extends HookConsumerWidget {
  const SidebarFooter({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return SizedBox(
      width: 256,
      child: HookBuilder(
        builder: (context) {
          var spotify = ref.watch(spotifyProvider);
          final me = useQuery(
            job: Queries.user.me,
            externalData: spotify,
          );
          final data = me.data;

          final avatarImg = TypeConversionUtils.image_X_UrlString(
            data?.images,
            index: (data?.images?.length ?? 1) - 1,
            placeholder: ImagePlaceholder.artist,
          );

          // TODO: Remove below code after fl-query ^0.4.0
          /// Temporary fix before fl-query 0.4.0
          final auth = ref.watch(authProvider);

          useEffect(() {
            if (auth.isLoggedIn && me.hasError) {
              me.setExternalData(spotify);
              me.refetch();
            }
            return null;
          }, [auth, me.hasError]);

          /// ===================================

          return Padding(
              padding: const EdgeInsets.all(16).copyWith(left: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (auth.isLoggedIn && data == null)
                    const Center(
                      child: PlatformCircularProgressIndicator(),
                    )
                  else if (data != null)
                    Flexible(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CircleAvatar(
                            backgroundImage:
                                UniversalImage.imageProvider(avatarImg),
                            onBackgroundImageError: (exception, stackTrace) =>
                                Image.asset(
                              "assets/user-placeholder.png",
                              height: 16,
                              width: 16,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            child: Text(
                              data.displayName ?? "Guest",
                              maxLines: 1,
                              softWrap: false,
                              overflow: TextOverflow.fade,
                              style: PlatformTheme.of(context)
                                  .textTheme
                                  ?.body
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  PlatformIconButton(
                      icon: const Icon(SpotubeIcons.settings),
                      onPressed: () => Sidebar.goToSettings(context)),
                ],
              ));
        },
      ),
    );
  }
}
