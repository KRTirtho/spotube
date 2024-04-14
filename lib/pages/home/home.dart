import 'package:flutter/material.dart';
import 'package:flutter_desktop_tools/flutter_desktop_tools.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/components/connect/connect_device.dart';
import 'package:spotube/components/home/sections/featured.dart';
import 'package:spotube/components/home/sections/feed.dart';
import 'package:spotube/components/home/sections/friends.dart';
import 'package:spotube/components/home/sections/genres.dart';
import 'package:spotube/components/home/sections/made_for_user.dart';
import 'package:spotube/components/home/sections/new_releases.dart';
import 'package:spotube/components/shared/image/universal_image.dart';
import 'package:spotube/components/shared/page_window_title_bar.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/extensions/image.dart';
import 'package:spotube/provider/spotify/spotify.dart';
import 'package:spotube/utils/platform.dart';
import 'package:spotube/utils/service_utils.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final controller = useScrollController();
    final mediaQuery = MediaQuery.of(context);

    return SafeArea(
        bottom: false,
        child: Scaffold(
          body: CustomScrollView(
            controller: controller,
            slivers: [
              if (mediaQuery.mdAndDown)
                PageWindowTitleBar.sliver(
                  pinned: DesktopTools.platform.isDesktop,
                  actions: [
                    const ConnectDeviceButton(),
                    const Gap(10),
                    Consumer(builder: (context, ref, _) {
                      final me = ref.watch(meProvider);
                      final meData = me.asData?.value;

                      return IconButton(
                        icon: CircleAvatar(
                          backgroundImage: UniversalImage.imageProvider(
                            (meData?.images).asUrlString(
                              placeholder: ImagePlaceholder.artist,
                            ),
                          ),
                        ),
                        style: IconButton.styleFrom(
                          padding: EdgeInsets.zero,
                        ),
                        onPressed: () {
                          ServiceUtils.push(context, "/profile");
                        },
                      );
                    }),
                    const Gap(10),
                  ],
                )
              else if (kIsMacOS)
                const SliverGap(10),
              const HomeGenresSection(),
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
