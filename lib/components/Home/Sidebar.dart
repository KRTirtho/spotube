import 'package:badges/badges.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:spotube/hooks/useBreakpointValue.dart';
import 'package:spotube/hooks/useBreakpoints.dart';
import 'package:spotube/models/sideBarTiles.dart';
import 'package:spotube/provider/Auth.dart';
import 'package:spotube/provider/Downloader.dart';
import 'package:spotube/provider/SpotifyRequests.dart';
import 'package:spotube/utils/platform.dart';
import 'package:spotube/utils/type_conversion_utils.dart';

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
    GoRouter.of(context).push("/settings");
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

    final int titleBarDragMaxWidth = useBreakpointValue(
      md: 80,
      lg: 256,
      sm: 0,
      xl: 256,
      xxl: 256,
    );

    useEffect(() {
      if (breakpoints.isMd && extended.value) {
        extended.value = false;
      } else if (breakpoints.isMoreThanOrEqualTo(Breakpoints.lg) &&
          !extended.value) {
        extended.value = true;
      }
      return null;
    });

    if (breakpoints.isSm) return Container();

    return SafeArea(
      child: Material(
        color: Theme.of(context).navigationRailTheme.backgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (selectedIndex == 3 && kIsDesktop)
              SizedBox(
                height: appWindow.titleBarHeight,
                width: titleBarDragMaxWidth.toDouble(),
                child: MoveWindow(),
              ),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: (extended.value)
                  ? Row(
                      children: [
                        _buildSmallLogo(),
                        const SizedBox(
                          width: 10,
                        ),
                        Text("Spotube",
                            style: Theme.of(context).textTheme.headline4),
                      ],
                    )
                  : _buildSmallLogo(),
            ),
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
              width: titleBarDragMaxWidth.toDouble(),
              child: Builder(
                builder: (context) {
                  final data = meSnapshot.asData?.value;

                  final avatarImg = TypeConversionUtils.image_X_UrlString(
                      data?.images,
                      index: (data?.images?.length ?? 1) - 1);
                  if (extended.value) {
                    return Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (auth.isLoggedIn && data == null)
                              const Center(
                                child: CircularProgressIndicator(),
                              )
                            else if (data != null)
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage:
                                        CachedNetworkImageProvider(avatarImg),
                                    onBackgroundImageError:
                                        (exception, stackTrace) => Container(
                                      height: 16,
                                      width: 16,
                                      color: Theme.of(context).cardColor,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    data.displayName ?? "Guest",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
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
                              CachedNetworkImageProvider(avatarImg),
                          onBackgroundImageError: (exception, stackTrace) =>
                              Container(
                            height: 16,
                            width: 16,
                            color: Theme.of(context).cardColor,
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
