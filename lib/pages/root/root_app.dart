import 'package:auto_route/auto_route.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:spotube/collections/routes.gr.dart';
import 'package:spotube/collections/side_bar_tiles.dart';
import 'package:spotube/components/framework/app_pop_scope.dart';
import 'package:spotube/modules/root/bottom_player.dart';
import 'package:spotube/modules/root/sidebar/sidebar.dart';
import 'package:spotube/modules/root/spotube_navigation_bar.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/hooks/configurators/use_endless_playback.dart';
import 'package:spotube/modules/root/use_downloader_dialogs.dart';
import 'package:spotube/modules/root/use_global_subscriptions.dart';
import 'package:spotube/provider/glance/glance.dart';
import 'package:spotube/utils/platform.dart';

@RoutePage()
class RootAppPage extends HookConsumerWidget {
  const RootAppPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final backgroundColor = Theme.of(context).colorScheme.background;
    final brightness = Theme.of(context).brightness;

    ref.listen(glanceProvider, (_, __) {});
    useGlobalSubscriptions(ref);
    useDownloaderDialogs(ref);
    useEndlessPlayback(ref);

    useEffect(() {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: backgroundColor, // status bar color
          statusBarIconBrightness: brightness == Brightness.dark
              ? Brightness.light
              : Brightness.dark,
        ),
      );
      return null;
    }, [backgroundColor, brightness]);

    final navTileNames = useMemoized(() {
      return getSidebarTileList(context.l10n).map((s) => s.route).toList();
    }, []);

    final scaffold = MediaQuery.removeViewInsets(
      context: context,
      removeBottom: true,
      child: const Scaffold(
        footers: [
          BottomPlayer(),
          SpotubeNavigationBar(),
        ],
        floatingFooter: true,
        child: Sidebar(child: AutoRouter()),
      ),
    );

    if (!kIsAndroid) {
      return scaffold;
    }

    final topRoute = context.router.topRoute;
    final canPop = navTileNames.any((name) => name.routeName == topRoute.name);

    return AppPopScope(
      canPop: canPop,
      onPopInvoked: (didPop) {
        if (didPop) return;

        if (topRoute.path == const HomeRoute().fragment) {
          SystemNavigator.pop();
        } else {
          context.navigateTo(const HomeRoute());
        }
      },
      child: scaffold,
    );
  }
}
