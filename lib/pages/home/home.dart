import 'package:flutter/material.dart';
import 'package:flutter_desktop_tools/flutter_desktop_tools.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/home/sections/featured.dart';
import 'package:spotube/components/home/sections/friends.dart';
import 'package:spotube/components/home/sections/genres.dart';
import 'package:spotube/components/home/sections/made_for_user.dart';
import 'package:spotube/components/home/sections/new_releases.dart';
import 'package:spotube/components/shared/page_window_title_bar.dart';
import 'package:spotube/provider/connect/clients.dart';
import 'package:spotube/utils/service_utils.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final ThemeData(:colorScheme) = Theme.of(context);
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
              SliverAppBar(
                actions: [
                  Consumer(
                    builder: (context, ref, _) {
                      final connectClients = ref.watch(connectClientsProvider);

                      return IconButton(
                        icon: const Icon(SpotubeIcons.speaker),
                        style: connectClients.asData?.value.resolvedService !=
                                null
                            ? IconButton.styleFrom(
                                backgroundColor: colorScheme.primaryContainer,
                                foregroundColor: colorScheme.primary,
                              )
                            : null,
                        onPressed: () {
                          ServiceUtils.push(context, "/connect");
                        },
                      );
                    },
                  )
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
