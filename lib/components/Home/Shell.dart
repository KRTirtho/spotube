import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/components/Home/Sidebar.dart';
import 'package:spotube/components/Home/SpotubeNavigationBar.dart';
import 'package:spotube/components/Player/Player.dart';
import 'package:spotube/components/Shared/PageWindowTitleBar.dart';
import 'package:spotube/components/Shared/ReplaceDownloadedFileDialog.dart';
import 'package:spotube/hooks/useUpdateChecker.dart';
import 'package:spotube/provider/Downloader.dart';

const _path = {
  0: "/",
  1: "/search",
  2: "/library",
  3: "/lyrics",
};

class Shell extends HookConsumerWidget {
  final Widget child;
  const Shell({
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final index = useState(0);
    final isMounted = useIsMounted();

    final downloader = ref.watch(downloaderProvider);
    useEffect(() {
      downloader.onFileExists = (track) async {
        if (!isMounted()) return false;
        return await showDialog<bool>(
              context: context,
              builder: (context) => ReplaceDownloadedFileDialog(
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

    const pageWindowTitleBar = PageWindowTitleBar();
    return Scaffold(
      primary: true,
      appBar: _path.values.contains(GoRouter.of(context).location)
          ? pageWindowTitleBar
          : null,
      extendBodyBehindAppBar: true,
      body: Row(
        children: [
          Sidebar(
            selectedIndex: index.value,
            onSelectedIndexChanged: (selectedIndex) {
              index.value = selectedIndex;
              GoRouter.of(context).go(_path[selectedIndex]!);
            },
          ),
          Expanded(
            child: Column(
              children: [
                Expanded(child: child),
              ],
            ),
          ),
        ],
      ),
      extendBody: true,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Player(),
          SpotubeNavigationBar(
            selectedIndex: index.value,
            onSelectedIndexChanged: (selectedIndex) {
              index.value = selectedIndex;
              GoRouter.of(context).go(_path[selectedIndex]!);
            },
          ),
        ],
      ),
    );
  }
}
