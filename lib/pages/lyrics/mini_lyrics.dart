import 'package:flutter/material.dart';
import 'package:flutter_desktop_tools/flutter_desktop_tools.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/player/player_controls.dart';
import 'package:spotube/components/player/player_queue.dart';
import 'package:spotube/components/root/sidebar.dart';
import 'package:spotube/components/shared/fallbacks/anonymous_fallback.dart';
import 'package:spotube/components/shared/page_window_title_bar.dart';
import 'package:spotube/hooks/use_force_update.dart';
import 'package:spotube/pages/lyrics/plain_lyrics.dart';
import 'package:spotube/pages/lyrics/synced_lyrics.dart';
import 'package:spotube/provider/authentication_provider.dart';
import 'package:spotube/provider/playlist_queue_provider.dart';
import 'package:spotube/utils/platform.dart';

class MiniLyricsPage extends HookConsumerWidget {
  const MiniLyricsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    final update = useForceUpdate();
    final prevSize = useRef<Size?>(null);

    final playlistQueue = ref.watch(PlaylistQueueNotifier.provider);

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        prevSize.value = await DesktopTools.window.getSize();
        await DesktopTools.window.setMinimumSize(const Size(300, 300));
        await DesktopTools.window.setAlwaysOnTop(true);
        if (!kIsLinux) await DesktopTools.window.setHasShadow(false);
        await DesktopTools.window.setSize(const Size(400, 500));
      });
      return null;
    }, []);

    final auth = ref.watch(AuthenticationNotifier.provider);

    if (auth == null) {
      return const Scaffold(
        appBar: PageWindowTitleBar(),
        body: AnonymousFallback(),
      );
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface.withOpacity(0.4),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: DragToMoveArea(
            child: Row(
              children: [
                const SizedBox(width: 10),
                SizedBox(
                  height: 30,
                  width: 30,
                  child: Sidebar.brandLogo(),
                ),
                const Spacer(),
                const SizedBox(
                  height: 30,
                  child: TabBar(
                    tabs: [Tab(text: 'Synced'), Tab(text: 'Plain')],
                    isScrollable: true,
                  ),
                ),
                const Spacer(),
                FutureBuilder(
                    future: DesktopTools.window.isAlwaysOnTop(),
                    builder: (context, snapshot) {
                      return IconButton(
                        tooltip: 'Always on top',
                        icon: Icon(
                          snapshot.data == true
                              ? SpotubeIcons.pinOn
                              : SpotubeIcons.pinOff,
                        ),
                        style: ButtonStyle(
                          foregroundColor: snapshot.data == true
                              ? MaterialStateProperty.all(
                                  theme.colorScheme.primary)
                              : null,
                        ),
                        onPressed: snapshot.data == null
                            ? null
                            : () async {
                                await DesktopTools.window.setAlwaysOnTop(
                                  snapshot.data == true ? false : true,
                                );
                                update();
                              },
                      );
                    }),
                IconButton(
                  tooltip: 'Exit Mini Player',
                  icon: const Icon(SpotubeIcons.maximize),
                  onPressed: () async {
                    try {
                      await DesktopTools.window
                          .setMinimumSize(const Size(300, 700));
                      await DesktopTools.window.setAlwaysOnTop(false);
                      await DesktopTools.window.setSize(prevSize.value!);
                      await DesktopTools.window.setAlignment(Alignment.center);
                      if (!kIsLinux) {
                        await DesktopTools.window.setHasShadow(true);
                      }
                    } finally {
                      if (context.mounted) GoRouter.of(context).go('/');
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            if (playlistQueue != null)
              Text(
                playlistQueue.activeTrack.name!,
                style: theme.textTheme.titleMedium,
              ),
            Expanded(
              child: TabBarView(
                children: [
                  SyncedLyrics(
                    palette: PaletteColor(theme.colorScheme.background, 0),
                    isModal: true,
                    defaultTextZoom: 65,
                  ),
                  PlainLyrics(
                    palette: PaletteColor(theme.colorScheme.background, 0),
                    isModal: true,
                    defaultTextZoom: 65,
                  ),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(SpotubeIcons.queue),
                  tooltip: 'Queue',
                  onPressed: playlistQueue != null
                      ? () {
                          showModalBottomSheet(
                            context: context,
                            isDismissible: true,
                            enableDrag: true,
                            isScrollControlled: true,
                            backgroundColor: Colors.black12,
                            barrierColor: Colors.black12,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            constraints: BoxConstraints(
                              maxHeight:
                                  MediaQuery.of(context).size.height * .7,
                            ),
                            builder: (context) {
                              return const PlayerQueue(floating: true);
                            },
                          );
                        }
                      : null,
                ),
                Flexible(child: PlayerControls(compact: true))
              ],
            )
          ],
        ),
      ),
    );
  }
}
