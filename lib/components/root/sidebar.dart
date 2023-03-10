import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';

import 'package:spotube/collections/assets.gen.dart';
import 'package:spotube/collections/side_bar_tiles.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/shared/image/universal_image.dart';
import 'package:spotube/hooks/use_breakpoints.dart';
import 'package:spotube/hooks/use_brightness_value.dart';
import 'package:spotube/hooks/use_sidebarx_controller.dart';
import 'package:spotube/provider/authentication_provider.dart';
import 'package:spotube/provider/downloader_provider.dart';

import 'package:spotube/provider/user_preferences_provider.dart';
import 'package:spotube/services/queries/queries.dart';
import 'package:spotube/utils/platform.dart';
import 'package:spotube/utils/type_conversion_utils.dart';

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
      child: Assets.spotubeLogoPng.image(height: 50),
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

    final controller = useSidebarXController(
      selectedIndex: selectedIndex,
      extended: breakpoints > Breakpoints.md,
    );

    final bg = Theme.of(context).colorScheme.surfaceVariant;

    final bgColor = useBrightnessValue(
      Color.lerp(bg, Colors.white, 0.7),
      Color.lerp(bg, Colors.black, 0.45)!,
    );

    useEffect(() {
      controller.addListener(() {
        onSelectedIndexChanged(controller.selectedIndex);
      });
      return null;
    }, [controller]);

    useEffect(() {
      if (breakpoints > Breakpoints.md && !controller.extended) {
        controller.setExtended(true);
      } else if (breakpoints <= Breakpoints.md && controller.extended) {
        controller.setExtended(false);
      }
      return null;
    }, [breakpoints, controller]);

    if (layoutMode == LayoutMode.compact ||
        (breakpoints.isSm && layoutMode == LayoutMode.adaptive)) {
      return Scaffold(body: child);
    }

    return Row(
      children: [
        SidebarX(
          controller: controller,
          items: sidebarTileList.map(
            (e) {
              return SidebarXItem(
                // iconWidget: Badge(
                //   backgroundColor: Theme.of(context).primaryColor,
                //   isLabelVisible: e.title == "Library" && downloadCount > 0,
                //   label: Text(
                //     downloadCount.toString(),
                //     style: const TextStyle(
                //       color: Colors.white,
                //       fontSize: 10,
                //     ),
                //   ),
                //   child: Icon(e.icon),
                // ),
                icon: e.icon,
                label: e.title,
              );
            },
          ).toList(),
          headerBuilder: (_, __) => const SidebarHeader(),
          footerBuilder: (_, __) => const Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: SidebarFooter(),
          ),
          showToggleButton: false,
          theme: SidebarXTheme(
            width: 60,
            margin: const EdgeInsets.all(10).copyWith(bottom: 122),
          ),
          extendedTheme: SidebarXTheme(
            width: 250,
            margin: const EdgeInsets.all(10).copyWith(bottom: 122, left: 0),
            padding: const EdgeInsets.symmetric(horizontal: 6),
            decoration: BoxDecoration(
                color: bgColor?.withOpacity(0.8),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                )),
            selectedItemDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            ),
            selectedIconTheme: IconThemeData(
              color: Theme.of(context).colorScheme.primary,
            ),
            selectedTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
            itemTextPadding: const EdgeInsets.only(left: 10),
            selectedItemTextPadding: const EdgeInsets.only(left: 10),
          ),
        ),
        Expanded(child: child)
      ],
    );
  }
}

class SidebarHeader extends HookWidget {
  const SidebarHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final breakpoint = useBreakpoints();

    if (breakpoint <= Breakpoints.md) {
      return Sidebar.brandLogo();
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          if (kIsMacOS) const SizedBox(height: 25),
          Row(
            children: [
              Sidebar.brandLogo(),
              const SizedBox(width: 10),
              Text(
                "Spotube",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ],
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
    final breakpoint = useBreakpoints();
    final me = useQueries.user.me(ref);
    final data = me.data;

    final avatarImg = TypeConversionUtils.image_X_UrlString(
      data?.images,
      index: (data?.images?.length ?? 1) - 1,
      placeholder: ImagePlaceholder.artist,
    );

    final auth = ref.watch(AuthenticationNotifier.provider);

    if (breakpoint <= Breakpoints.md) {
      return IconButton(
        icon: const Icon(SpotubeIcons.settings),
        onPressed: () => Sidebar.goToSettings(context),
      );
    }

    return Container(
      padding: const EdgeInsets.only(left: 12),
      width: 250,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (auth != null && data == null)
            const CircularProgressIndicator()
          else if (data != null)
            Flexible(
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: UniversalImage.imageProvider(avatarImg),
                    onBackgroundImageError: (exception, stackTrace) =>
                        Assets.userPlaceholder.image(
                      height: 16,
                      width: 16,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      data.displayName ?? "Guest",
                      maxLines: 1,
                      softWrap: false,
                      overflow: TextOverflow.fade,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          IconButton(
            icon: const Icon(SpotubeIcons.settings),
            onPressed: () => Sidebar.goToSettings(context),
          ),
        ],
      ),
    );
  }
}
