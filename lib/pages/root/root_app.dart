import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:platform_ui/platform_ui.dart';
import 'package:spotube/components/shared/dialogs/replace_downloaded_dialog.dart';
import 'package:spotube/components/root/bottom_player.dart';
import 'package:spotube/components/root/sidebar.dart';
import 'package:spotube/components/root/spotube_navigation_bar.dart';
import 'package:spotube/components/shared/page_window_title_bar.dart';
import 'package:spotube/hooks/use_update_checker.dart';
import 'package:spotube/provider/downloader_provider.dart';
import 'package:spotube/utils/platform.dart';

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

    final downloader = ref.watch(downloaderProvider);

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Window.setEffect(
          effect: kIsLinux ? WindowEffect.transparent : WindowEffect.acrylic,
          color: PlatformTheme.of(context).scaffoldBackgroundColor!,
          dark: PlatformTheme.of(context).brightness == Brightness.dark,
        );
      });
      return null;
    }, []);

    useEffect(() {
      downloader.onFileExists = (track) async {
        if (!isMounted()) return false;
        return await showPlatformAlertDialog<bool>(
              context,
              builder: (context) => ReplaceDownloadedDialog(
                track: track,
              ),
            ) ??
            false;
      };
      return null;
    }, [downloader]);

    // checks for latest version of the application
    useUpdateChecker(ref);

    final backgroundColor = Theme.of(context).backgroundColor;

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

    return PlatformScaffold(
      appBar: platform == TargetPlatform.windows
          ? PageWindowTitleBar(hideWhenWindows: false) as PreferredSizeWidget?
          : null,
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
