import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotube/components/shared/dialogs/replace_downloaded_dialog.dart';
import 'package:spotube/components/root/bottom_player.dart';
import 'package:spotube/components/root/sidebar.dart';
import 'package:spotube/components/root/spotube_navigation_bar.dart';
import 'package:spotube/hooks/use_update_checker.dart';
import 'package:spotube/provider/download_manager_provider.dart';
import 'package:spotube/utils/persisted_state_notifier.dart';

const rootPaths = {
  0: "/",
  1: "/search",
  2: "/library",
  3: "/lyrics",
};

class RootApp extends HookConsumerWidget {
  final Widget child;
  const RootApp({
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final index = useState(0);
    final isMounted = useIsMounted();
    final showingDialogCompleter = useRef(Completer()..complete());
    final downloader = ref.watch(downloadManagerProvider);

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final sharedPreferences = await SharedPreferences.getInstance();

        if (sharedPreferences.getBool(kIsUsingEncryption) == false &&
            context.mounted) {
          await PersistedStateNotifier.showNoEncryptionDialog(context);
        }
      });
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

    return Scaffold(
      body: Sidebar(
        selectedIndex: index.value,
        onSelectedIndexChanged: (i) {
          index.value = i;
          GoRouter.of(context).go(rootPaths[index.value]!);
        },
        child: child,
      ),
      extendBody: true,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BottomPlayer(),
          SpotubeNavigationBar(
            selectedIndex: index.value,
            onSelectedIndexChanged: (selectedIndex) {
              index.value = selectedIndex;
              GoRouter.of(context).go(rootPaths[selectedIndex]!);
            },
          ),
        ],
      ),
    );
  }
}
