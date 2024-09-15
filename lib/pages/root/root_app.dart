import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/collections/side_bar_tiles.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/framework/app_pop_scope.dart';
import 'package:spotube/modules/player/player_queue.dart';
import 'package:spotube/components/dialogs/replace_downloaded_dialog.dart';
import 'package:spotube/modules/root/bottom_player.dart';
import 'package:spotube/modules/root/sidebar.dart';
import 'package:spotube/modules/root/spotube_navigation_bar.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/hooks/configurators/use_endless_playback.dart';
import 'package:spotube/pages/home/home.dart';
import 'package:spotube/provider/download_manager_provider.dart';
import 'package:spotube/provider/audio_player/audio_player.dart';
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
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final connectRoutes = ref.watch(serverConnectRoutesProvider);

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        ServiceUtils.checkForUpdates(context, ref);
      });

      final subscriptions = [
        ConnectionCheckerService.instance.onConnectivityChanged
            .listen((status) {
          if (status) {
            scaffoldMessenger.showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(
                      SpotubeIcons.wifi,
                      color: theme.colorScheme.onPrimary,
                    ),
                    const SizedBox(width: 10),
                    Text(context.l10n.connection_restored),
                  ],
                ),
                backgroundColor: theme.colorScheme.primary,
                showCloseIcon: true,
                width: 350,
              ),
            );
          } else {
            scaffoldMessenger.showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(
                      SpotubeIcons.noWifi,
                      color: theme.colorScheme.onError,
                    ),
                    const SizedBox(width: 10),
                    Text(context.l10n.you_are_offline),
                  ],
                ),
                backgroundColor: theme.colorScheme.error,
                showCloseIcon: true,
                width: 300,
              ),
            );
          }
        }),
        connectRoutes.connectClientStream.listen((clientOrigin) {
          scaffoldMessenger.showSnackBar(
            SnackBar(
              backgroundColor: Colors.yellow[600],
              behavior: SnackBarBehavior.floating,
              content: Row(
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
            ),
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

    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;

    useEffect(() {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: backgroundColor, // status bar color
          statusBarIconBrightness: backgroundColor.computeLuminance() > 0.179
              ? Brightness.dark
              : Brightness.light,
        ),
      );
      return null;
    }, [backgroundColor]);

    final navTileNames = useMemoized(() {
      return getSidebarTileList(context.l10n).map((s) => s.name).toList();
    }, []);

    final scaffold = Scaffold(
      body: Sidebar(child: child),
      extendBody: true,
      drawerScrimColor: Colors.transparent,
      endDrawer: kIsDesktop
          ? Container(
              constraints: const BoxConstraints(maxWidth: 800),
              decoration: BoxDecoration(
                boxShadow: theme.brightness == Brightness.light
                    ? null
                    : kElevationToShadow[8],
              ),
              margin: const EdgeInsets.only(
                top: 40,
                bottom: 100,
              ),
              child: Consumer(
                builder: (context, ref, _) {
                  final playlist = ref.watch(audioPlayerProvider);
                  final playlistNotifier =
                      ref.read(audioPlayerProvider.notifier);

                  return PlayerQueue.fromAudioPlayerNotifier(
                    floating: true,
                    playlist: playlist,
                    notifier: playlistNotifier,
                  );
                },
              ),
            )
          : null,
      bottomNavigationBar: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BottomPlayer(),
          SpotubeNavigationBar(),
        ],
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
