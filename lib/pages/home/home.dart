import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:spotube/collections/routes.gr.dart';
import 'package:spotube/components/titlebar/titlebar.dart';
import 'package:spotube/modules/connect/connect_device.dart';
import 'package:spotube/modules/home/sections/featured.dart';
import 'package:spotube/modules/home/sections/sections.dart';
import 'package:spotube/modules/home/sections/new_releases.dart';
import 'package:spotube/modules/home/sections/recent.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';
import 'package:spotube/theme/spotify_colors.dart';
import 'package:spotube/utils/platform.dart';

@RoutePage()
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
        headers: [
          if (kTitlebarVisible) const TitleBar(height: 30),
        ],
        backgroundColor: SpotifyColors.background,
        body: CustomScrollView(
          controller: controller,
          slivers: [
            if (mediaQuery.smAndDown || layoutMode == LayoutMode.compact)
              SliverAppBar(
                floating: true,
                title: Text(
                  "Spotify",
                  style: const TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.04,
                    color: SpotifyColors.primaryText,
                  ),
                ),
                backgroundColor: SpotifyColors.background,
                foregroundColor: SpotifyColors.primaryText,
                elevation: 0,
                scrolledUnderElevation: 0,
                shadowColor: Colors.transparent,
                actions: [
                  const ConnectDeviceButton(),
                  const Gap(10),
                  IconButton(
                    icon: const Icon(Icons.settings_rounded,
                        size: 20, color: SpotifyColors.secondaryText),
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
              itemCount: 3,
              itemBuilder: (context, index) {
                return switch (index) {
                  0 => const HomeRecentlyPlayedSection(),
                  1 => const HomeFeaturedSection(),
                  _ => const HomeNewReleasesSection()
                };
              },
            ),
            const SliverSafeArea(sliver: HomePageBrowseSection()),
          ],
        ),
      ),
    );
  }
}
