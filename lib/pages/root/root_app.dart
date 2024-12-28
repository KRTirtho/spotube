import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:spotube/collections/side_bar_tiles.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/framework/app_pop_scope.dart';
import 'package:spotube/components/dialogs/replace_downloaded_dialog.dart';
import 'package:spotube/modules/root/bottom_player.dart';
import 'package:spotube/modules/root/sidebar.dart';
import 'package:spotube/modules/root/spotube_navigation_bar.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/hooks/configurators/use_endless_playback.dart';
import 'package:spotube/pages/home/home.dart';
import 'package:spotube/provider/download_manager_provider.dart';
import 'package:spotube/provider/glance/glance.dart';
import 'package:spotube/provider/server/routes/connect.dart';
import 'package:spotube/services/connectivity_adapter.dart';
import 'package:spotube/utils/platform.dart';
import 'package:spotube/utils/service_utils.dart';

class RootApp extends HookConsumerWidget {
  final Widget child;
  const RootApp({
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);

    final showingDialogCompleter = useRef(Completer()..complete());
    final downloader = ref.watch(downloadManagerProvider);

    final connectRoutes = ref.watch(serverConnectRoutesProvider);

    ref.listen(glanceProvider, (_, __) {});

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        ServiceUtils.checkForUpdates(context, ref);
      });

      final subscriptions = [
        ConnectionCheckerService.instance.onConnectivityChanged
            .listen((status) {
          if (!context.mounted) return;
          if (status) {
            showToast(
              context: context,
              builder: (context, overlay) {
                return SurfaceCard(
                  fillColor: theme.colorScheme.primary,
                  child: Row(
                    children: [
                      Icon(
                        SpotubeIcons.wifi,
                        color: theme.colorScheme.primaryForeground,
                      ),
                      const SizedBox(width: 10),
                      Text(context.l10n.connection_restored),
                    ],
                  ),
                );
              },
            );
          } else {
            showToast(
              context: context,
              builder: (context, overlay) {
                return SurfaceCard(
                  fillColor: theme.colorScheme.destructive,
                  child: Row(
                    children: [
                      Icon(
                        SpotubeIcons.noWifi,
                        color: theme.colorScheme.destructiveForeground,
                      ),
                      const SizedBox(width: 10),
                      Text(context.l10n.you_are_offline),
                    ],
                  ),
                );
              },
            );
          }
        }),
        connectRoutes.connectClientStream.listen((clientOrigin) {
          if (!context.mounted) return;
          showToast(
            context: context,
            builder: (context, overlay) {
              return SurfaceCard(
                fillColor: Colors.yellow[600],
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      SpotubeIcons.error,
                      color: Colors.black,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      context.l10n.connect_client_alert(clientOrigin),
                      style: const TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              );
            },
          );
        })
      ];

      return () {
        for (final subscription in subscriptions) {
          subscription.cancel();
        }
      };
    }, []);

    useEffect(() {
      downloader.onFileExists = (track) async {
        if (!context.mounted) return false;

        if (!showingDialogCompleter.value.isCompleted) {
          await showingDialogCompleter.value.future;
        }

        final replaceAll = ref.read(replaceDownloadedFileState);

        if (replaceAll != null) return replaceAll;

        showingDialogCompleter.value = Completer();

        if (context.mounted) {
          final result = await showDialog<bool>(
                context: context,
                builder: (context) => ReplaceDownloadedDialog(
                  track: track,
                ),
              ) ??
              false;

          showingDialogCompleter.value.complete();
          return result;
        }

        // it'll never reach here as root_app is always mounted
        return false;
      };
      return null;
    }, [downloader]);

    // checks for latest version of the application

    useEndlessPlayback(ref);

    final backgroundColor = Theme.of(context).colorScheme.background;
    final brightness = Theme.of(context).brightness;

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
