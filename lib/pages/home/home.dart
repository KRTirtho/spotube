import 'package:flutter/material.dart';
import 'package:flutter_desktop_tools/flutter_desktop_tools.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/components/home/sections/featured.dart';
import 'package:spotube/components/home/sections/friends.dart';
import 'package:spotube/components/home/sections/genres.dart';
import 'package:spotube/components/home/sections/made_for_user.dart';
import 'package:spotube/components/home/sections/new_releases.dart';
import 'package:spotube/components/shared/page_window_title_bar.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final controller = useScrollController();

    return SafeArea(
        bottom: false,
        child: Scaffold(
          appBar:
              DesktopTools.platform.isLinux || DesktopTools.platform.isWindows
                  ? const PageWindowTitleBar()
                  : null,
          body: CustomScrollView(
            controller: controller,
            slivers: [
              if (DesktopTools.platform.isMacOS || DesktopTools.platform.isWeb)
                const SliverGap(20),
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
