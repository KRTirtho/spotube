import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/shared/dialogs/replace_downloaded_dialog.dart';
import 'package:spotube/components/root/bottom_player.dart';
import 'package:spotube/components/root/sidebar.dart';
import 'package:spotube/components/root/spotube_navigation_bar.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/hooks/use_update_checker.dart';
import 'package:spotube/provider/download_manager_provider.dart';
import 'package:spotube/utils/persisted_state_notifier.dart';

const rootPaths = {
  "/": 0,
  "/search": 1,
  "/library": 2,
  "/lyrics": 3,
};

class RootApp extends HookConsumerWidget {
  final Widget child;
  const RootApp({
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final isMounted = useIsMounted();
    final showingDialogCompleter = useRef(Completer()..complete());
    final downloader = ref.watch(downloadManagerProvider);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final theme = Theme.of(context);
    final location = GoRouterState.of(context).matchedLocation;

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final sharedPreferences = await SharedPreferences.getInstance();

        if (sharedPreferences.getBool(kIsUsingEncryption) == false &&
            context.mounted) {
          await PersistedStateNotifier.showNoEncryptionDialog(context);
        }
      });

      final subscription =
          InternetConnectionChecker().onStatusChange.listen((status) {
        switch (status) {
          case InternetConnectionStatus.connected:
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
          case InternetConnectionStatus.disconnected:
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
      });

      return () {
        subscription.cancel();
      };
    }, []);

    useEffect(() {
      downloader.onFileExists = (track) async {
        if (!isMounted()) return false;

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
    useUpdateChecker(ref);

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

    void onSelectIndexChanged(int d) {
      final invertedRouteMap =
          rootPaths.map((key, value) => MapEntry(value, key));

      if (context.mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          GoRouter.of(context).go(invertedRouteMap[d]!);
        });
      }
    }

    return Scaffold(
      body: Sidebar(
        selectedIndex: rootPaths[location] ?? 0,
        onSelectedIndexChanged: onSelectIndexChanged,
        child: child,
      ),
      extendBody: true,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BottomPlayer(),
          SpotubeNavigationBar(
            selectedIndex: rootPaths[location] ?? 0,
            onSelectedIndexChanged: onSelectIndexChanged,
          ),
        ],
      ),
    );
  }
}
