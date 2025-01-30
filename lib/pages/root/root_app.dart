import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:spotube/collections/side_bar_tiles.dart';
import 'package:spotube/components/framework/app_pop_scope.dart';
import 'package:spotube/modules/root/bottom_player.dart';
import 'package:spotube/modules/root/sidebar.dart';
import 'package:spotube/modules/root/spotube_navigation_bar.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/hooks/configurators/use_endless_playback.dart';
import 'package:spotube/modules/root/use_downloader_dialogs.dart';
import 'package:spotube/modules/root/use_global_subscriptions.dart';
import 'package:spotube/pages/home/home.dart';
import 'package:spotube/provider/glance/glance.dart';
import 'package:spotube/utils/platform.dart';

class RootApp extends HookConsumerWidget {
  final Widget child;
  const RootApp({
    required this.child,
    super.key,
  });

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
      return getSidebarTileList(context.l10n).map((s) => s.name).toList();
    }, []);

    final scaffold = MediaQuery.removeViewInsets(
      context: context,
      removeBottom: true,
      child: Scaffold(
        footers: const [
          BottomPlayer(),
          SpotubeNavigationBar(),
        ],
        floatingFooter: true,
        child: Sidebar(child: child),
      ),
    );

    if (!kIsAndroid) {
      return scaffold;
    }

    final topRoute = GoRouterState.of(context).topRoute;
    final canPop = topRoute != null && !navTileNames.contains(topRoute.name);

    return AppPopScope(
      canPop: canPop,
      onPopInvoked: (didPop) {
        if (didPop) return;

        if (topRoute?.name == HomePage.name) {
          SystemNavigator.pop();
        } else {
          context.goNamed(HomePage.name);
        }
      },
      child: scaffold,
    );
  }
}
