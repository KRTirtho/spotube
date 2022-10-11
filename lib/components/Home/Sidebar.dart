import 'package:badges/badges.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:spotube/components/Shared/UniversalImage.dart';
import 'package:spotube/hooks/useBreakpoints.dart';
import 'package:spotube/models/sideBarTiles.dart';
import 'package:spotube/provider/Auth.dart';
import 'package:spotube/provider/Downloader.dart';
import 'package:spotube/provider/SpotifyRequests.dart';
import 'package:spotube/provider/UserPreferences.dart';
import 'package:spotube/utils/platform.dart';
import 'package:spotube/utils/type_conversion_utils.dart';

final sidebarExtendedStateProvider = StateProvider<bool?>((ref) => null);

class Sidebar extends HookConsumerWidget {
  final int selectedIndex;
  final void Function(int) onSelectedIndexChanged;

  const Sidebar({
    required this.selectedIndex,
    required this.onSelectedIndexChanged,
    Key? key,
  }) : super(key: key);

  Widget _buildSmallLogo() {
    return Image.asset(
      "assets/spotube-logo.png",
      height: 50,
      width: 50,
    );
  }

  static void goToSettings(BuildContext context) {
    GoRouter.of(context).go("/settings");
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final breakpoints = useBreakpoints();
    final extended = useState(false);
    final meSnapshot = ref.watch(currentUserQuery);
    final auth = ref.watch(authProvider);
    final downloadCount = ref.watch(
      downloaderProvider.select((s) => s.currentlyRunning),
    );
    final forceExtended = ref.watch(sidebarExtendedStateProvider);

    useEffect(() {
      if (forceExtended != null) {
        if (extended.value != forceExtended) {
          extended.value = forceExtended;
        }
        return;
      }
      if (breakpoints.isMd && extended.value) {
        extended.value = false;
      } else if (breakpoints.isMoreThanOrEqualTo(Breakpoints.lg) &&
          !extended.value) {
        extended.value = true;
      }
      return null;
    });

    final layoutMode =
        ref.watch(userPreferencesProvider.select((s) => s.layoutMode));

    if (layoutMode == LayoutMode.compact ||
        (breakpoints.isSm && layoutMode == LayoutMode.adaptive)) {
      return Container();
    }

    void toggleExtended() =>
        ref.read(sidebarExtendedStateProvider.notifier).state =
            !(forceExtended ?? extended.value);

    return SafeArea(
      top: false,
      child: Material(
        color: Theme.of(context).navigationRailTheme.backgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (kIsDesktop)
              SizedBox(
                height: appWindow.titleBarHeight,
                width: extended.value ? 256 : 80,
                child: MoveWindow(
                  child: !extended.value
                      ? Center(
                          child: IconButton(
                            icon: const Icon(Icons.menu_rounded),
                            onPressed: toggleExtended,
                          ),
                        )
                      : null,
                ),
              ),
            if (!kIsDesktop && !extended.value)
              Center(
                child: IconButton(
                  icon: const Icon(Icons.menu_rounded),
                  onPressed: toggleExtended,
                ),
              ),
            (extended.value)
                ? Row(
                    children: [
                      _buildSmallLogo(),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Spotube",
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      IconButton(
                        icon: const Icon(Icons.menu_rounded),
                        onPressed: toggleExtended,
                      ),
                    ],
                  )
                : _buildSmallLogo(),
            Expanded(
              child: NavigationRail(
                destinations: sidebarTileList.map(
                  (e) {
                    final icon = Icon(e.icon);
                    return NavigationRailDestination(
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
                      label: Text(
                        e.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    );
                  },
                ).toList(),
                selectedIndex: selectedIndex,
                onDestinationSelected: onSelectedIndexChanged,
                extended: extended.value,
              ),
            ),
            SizedBox(
              width: extended.value ? 256 : 80,
              child: Builder(
                builder: (context) {
                  final data = meSnapshot.asData?.value;

                  final avatarImg = TypeConversionUtils.image_X_UrlString(
                    data?.images,
                    index: (data?.images?.length ?? 1) - 1,
                    placeholder: ImagePlaceholder.artist,
                  );
                  if (extended.value) {
                    return Padding(
                        padding: const EdgeInsets.all(16).copyWith(left: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (auth.isLoggedIn && data == null)
                              const Center(
                                child: CircularProgressIndicator(),
                              )
                            else if (data != null)
                              Flexible(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    CircleAvatar(
                                      backgroundImage:
                                          UniversalImage.imageProvider(
                                              avatarImg),
                                      onBackgroundImageError:
                                          (exception, stackTrace) =>
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
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            IconButton(
                                icon: const Icon(Icons.settings_outlined),
                                onPressed: () => goToSettings(context)),
                          ],
                        ));
                  } else {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () => goToSettings(context),
                        child: CircleAvatar(
                          backgroundImage:
                              UniversalImage.imageProvider(avatarImg),
                          onBackgroundImageError: (exception, stackTrace) =>
                              Image.asset(
                            "assets/user-placeholder.png",
                            height: 16,
                            width: 16,
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
