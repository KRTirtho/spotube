import 'package:flutter/material.dart';
import 'package:flutter_desktop_tools/flutter_desktop_tools.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/components/home/sections/featured.dart';
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
          appBar: DesktopTools.platform.isMobile
              ? null
              : const PageWindowTitleBar(),
          body: CustomScrollView(
            controller: controller,
            slivers: [
              const HomeGenresSection(),
              SliverList.list(
                children: const [
                  HomeFeaturedSection(),
                  HomeNewReleasesSection(),
                ],
              ),
              const SliverSafeArea(sliver: HomeMadeForUserSection()),
            ],
          ),
        ));
  }
}
