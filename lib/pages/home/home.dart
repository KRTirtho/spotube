import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:shadcn_flutter/shadcn_flutter_extension.dart';
import 'package:spotube/collections/assets.gen.dart';
import 'package:spotube/collections/routes.gr.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/models/database/database.dart';
import 'package:spotube/modules/connect/connect_device.dart';
import 'package:spotube/modules/home/sections/featured.dart';
import 'package:spotube/modules/home/sections/feed.dart';
import 'package:spotube/modules/home/sections/friends.dart';
import 'package:spotube/modules/home/sections/genres/genres.dart';
import 'package:spotube/modules/home/sections/made_for_user.dart';
import 'package:spotube/modules/home/sections/new_releases.dart';
import 'package:spotube/modules/home/sections/recent.dart';
import 'package:spotube/components/titlebar/titlebar.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';
import 'package:spotube/utils/platform.dart';

@RoutePage()
class HomePage extends HookConsumerWidget {
  static const name = "home";
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    final controller = useScrollController();
    final mediaQuery = MediaQuery.of(context);
    final layoutMode =
        ref.watch(userPreferencesProvider.select((s) => s.layoutMode));

    return SafeArea(
        bottom: false,
        child: Scaffold(
          headers: [
            if (kTitlebarVisible) const TitleBar(height: 30),
          ],
          child: CustomScrollView(
            controller: controller,
            slivers: [
              if (mediaQuery.smAndDown || layoutMode == LayoutMode.compact)
                SliverAppBar(
                  floating: true,
                  title: Image.asset(
                    theme.brightness == Brightness.dark
                        ? Assets.spotubeLogoPng.path
                        : Assets.spotubeLogoLight.path,
                    height: 45,
                    width: 45,
                    color: theme.colorScheme.background,
                    colorBlendMode: BlendMode.saturation,
                    cacheHeight:
                        (100 * MediaQuery.devicePixelRatioOf(context)).toInt(),
                  ),
                  backgroundColor: context.theme.colorScheme.background,
                  foregroundColor: context.theme.colorScheme.foreground,
                  actions: [
                    const ConnectDeviceButton(),
                    const Gap(10),
                    IconButton.ghost(
                      icon: const Icon(SpotubeIcons.settings, size: 20),
                      onPressed: () {
                        context.navigateTo(const SettingsRoute());
                      },
                    ),
                    const Gap(10),
                  ],
                )
              else if (kIsMacOS)
                const SliverGap(10),
              const SliverGap(10),
              SliverList.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return switch (index) {
                    0 => const HomeGenresSection(),
                    1 => const HomeRecentlyPlayedSection(),
                    2 => const HomeFeaturedSection(),
                    3 => const HomePageFriendsSection(),
                    _ => const HomeNewReleasesSection()
                  };
                },
              ),
              const HomePageFeedSection(),
              const SliverSafeArea(sliver: HomeMadeForUserSection()),
            ],
          ),
        ));
  }
}
