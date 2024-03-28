import 'package:flutter/material.dart';
import 'package:flutter_desktop_tools/flutter_desktop_tools.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/connect/connect_device.dart';
import 'package:spotube/components/home/sections/featured.dart';
import 'package:spotube/components/home/sections/friends.dart';
import 'package:spotube/components/home/sections/genres.dart';
import 'package:spotube/components/home/sections/made_for_user.dart';
import 'package:spotube/components/home/sections/new_releases.dart';
import 'package:spotube/components/shared/page_window_title_bar.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final controller = useScrollController();

    return SafeArea(
        bottom: false,
        child: Scaffold(
          body: CustomScrollView(
            controller: controller,
            slivers: [
              PageWindowTitleBar.sliver(
                pinned: DesktopTools.platform.isDesktop,
                actions: [
                  const ConnectDeviceButton(),
                  const Gap(10),
                  IconButton.filledTonal(
                    icon: const Icon(SpotubeIcons.user),
                    onPressed: () {},
                  ),
                  const Gap(10),
                ],
              ),
              const HomeGenresSection(),
              const SliverToBoxAdapter(child: HomeFeaturedSection()),
              const HomePageFriendsSection(),
              const SliverToBoxAdapter(child: HomeNewReleasesSection()),
              const SliverSafeArea(sliver: HomeMadeForUserSection()),
            ],
          ),
        ));
  }
}
