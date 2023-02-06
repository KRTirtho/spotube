import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:platform_ui/platform_ui.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/shared/page_window_title_bar.dart';
import 'package:spotube/pages/home/genres.dart';
import 'package:spotube/pages/home/personalized.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final index = useState(0);
    final tabbar = PlatformTabBar(
      androidIsScrollable: true,
      selectedIndex: index.value,
      onSelectedIndexChanged: (value) => index.value = value,
      isNavigational:
          PlatformProperty.byPlatformGroup(mobile: false, desktop: true),
      tabs: [
        PlatformTab(
          label: 'Genres',
          icon: PlatformProperty.only(
            android: const SizedBox.shrink(),
            other: const Icon(SpotubeIcons.genres),
          ).resolve(platform!),
        ),
        PlatformTab(
          label: 'Personalized',
          icon: PlatformProperty.only(
            android: const SizedBox.shrink(),
            other: const Icon(SpotubeIcons.personalized),
          ).resolve(platform!),
        ),
      ],
    );

    return PlatformScaffold(
      appBar: platform == TargetPlatform.windows
          ? PreferredSize(
              preferredSize: const Size.fromHeight(40),
              child: tabbar,
            )
          : PageWindowTitleBar(
              titleWidth: 347,
              centerTitle: true,
              center: tabbar,
            ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) => SlideTransition(
          position: animation.drive(
            Tween<Offset>(
              begin: const Offset(1, 0),
              end: const Offset(0, 0),
            ),
          ),
          child: child,
        ),
        child: [
          const GenrePage(),
          const PersonalizedPage(),
        ][index.value],
      ),
    );
  }
}
