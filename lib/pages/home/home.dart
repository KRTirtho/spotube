import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/collections/assets.gen.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/models/database/database.dart';
import 'package:spotube/modules/connect/connect_device.dart';
import 'package:spotube/modules/home/sections/featured.dart';
import 'package:spotube/modules/home/sections/feed.dart';
import 'package:spotube/modules/home/sections/friends.dart';
import 'package:spotube/modules/home/sections/genres.dart';
import 'package:spotube/modules/home/sections/made_for_user.dart';
import 'package:spotube/modules/home/sections/new_releases.dart';
import 'package:spotube/modules/home/sections/recent.dart';
import 'package:spotube/components/titlebar/titlebar.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/pages/settings/settings.dart';
import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';
import 'package:spotube/utils/platform.dart';
import 'package:spotube/utils/service_utils.dart';

class HomePage extends HookConsumerWidget {
  static const name = "home";
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final controller = useScrollController();
    final mediaQuery = MediaQuery.of(context);
    final layoutMode =
        ref.watch(userPreferencesProvider.select((s) => s.layoutMode));

    return SafeArea(
        bottom: false,
        child: Scaffold(
          appBar: kIsMobile || kIsMacOS ? null : const PageWindowTitleBar(),
          body: CustomScrollView(
            controller: controller,
            slivers: [
              if (mediaQuery.smAndDown || layoutMode == LayoutMode.compact)
                SliverAppBar(
                  floating: true,
                  title: Assets.spotubeLogoPng.image(height: 45),
                  actions: [
                    const ConnectDeviceButton(),
                    const Gap(10),
                    IconButton(
                      icon: const Icon(SpotubeIcons.settings, size: 20),
                      onPressed: () {
                        ServiceUtils.pushNamed(context, SettingsPage.name);
                      },
                    ),
                    const Gap(10),
                  ],
                )
              else if (kIsMacOS)
                const SliverGap(10),
              const HomeGenresSection(),
              const SliverGap(10),
              const SliverToBoxAdapter(child: HomeRecentlyPlayedSection()),
              const SliverToBoxAdapter(child: HomeFeaturedSection()),
              const HomePageFriendsSection(),
              const SliverToBoxAdapter(child: HomeNewReleasesSection()),
              const HomePageFeedSection(),
              const SliverSafeArea(sliver: HomeMadeForUserSection()),
            ],
          ),
        ));
  }
}
