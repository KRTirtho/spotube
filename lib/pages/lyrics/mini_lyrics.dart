import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/modules/player/player_controls.dart';
import 'package:spotube/modules/player/player_queue.dart';
import 'package:spotube/modules/root/sidebar.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/hooks/utils/use_force_update.dart';
import 'package:spotube/pages/lyrics/plain_lyrics.dart';
import 'package:spotube/pages/lyrics/synced_lyrics.dart';
import 'package:spotube/provider/audio_player/audio_player.dart';
import 'package:spotube/utils/platform.dart';
import 'package:window_manager/window_manager.dart';

class MiniLyricsPage extends HookConsumerWidget {
  static const name = "mini_lyrics";

  final Size prevSize;
  const MiniLyricsPage({super.key, required this.prevSize});

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    final update = useForceUpdate();
    final wasMaximized = useRef<bool>(false);

    final playlistQueue = ref.watch(audioPlayerProvider);

    final areaActive = useState(false);
    final hoverMode = useState(true);
    final showLyrics = useState(true);

    useEffect(() {
      if (kIsDesktop) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          wasMaximized.value = await windowManager.isMaximized();
        });
      }
      return null;
    }, []);

  

    return MouseRegion(
      onEnter: !hoverMode.value
          ? null
          : (event) {
              areaActive.value = true;
            },
      onExit: !hoverMode.value
          ? null
          : (event) {
              areaActive.value = false;
            },
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: theme.colorScheme.surface.withOpacity(0.4),
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: AnimatedCrossFade(
              duration: const Duration(milliseconds: 200),
              crossFadeState: areaActive.value
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              secondChild: const SizedBox(),
              firstChild: DragToMoveArea(
                child: Row(
                  children: [
                    const Gap(10),
                    if (!kIsMacOS)
                      SizedBox(
                        height: 30,
                        width: 30,
                        child: Sidebar.brandLogo(),
                      ),
                    const Spacer(),
                    if (showLyrics.value)
                      SizedBox(
                        height: 30,
                        child: TabBar(
                          tabs: [
                            Tab(text: context.l10n.synced),
                            Tab(text: context.l10n.plain),
                          ],
                          isScrollable: true,
                        ),
                      ),
                    const Spacer(),
                    IconButton(
                      tooltip: context.l10n.lyrics,
                      icon: showLyrics.value
                          ? const Icon(SpotubeIcons.lyrics)
                          : const Icon(SpotubeIcons.lyricsOff),
                      style: ButtonStyle(
                        foregroundColor: showLyrics.value
                            ? WidgetStateProperty.all(theme.colorScheme.primary)
                            : null,
                      ),
                      onPressed: () async {
                        showLyrics.value = !showLyrics.value;
                        areaActive.value = true;
                        hoverMode.value = false;

                        if (kIsDesktop) {
                          await windowManager.setSize(
                            showLyrics.value
                                ? const Size(400, 500)
                                : const Size(400, 150),
                          );
                        }
                      },
                    ),
                    IconButton(
                      tooltip: context.l10n.show_hide_ui_on_hover,
                      icon: hoverMode.value
                          ? const Icon(SpotubeIcons.hoverOn)
                          : const Icon(SpotubeIcons.hoverOff),
                      style: ButtonStyle(
                        foregroundColor: hoverMode.value
                            ? WidgetStateProperty.all(theme.colorScheme.primary)
                            : null,
                      ),
                      onPressed: () async {
                        areaActive.value = true;
                        hoverMode.value = !hoverMode.value;
                      },
                    ),
                    if (kIsDesktop)
                      FutureBuilder(
                        future: windowManager.isAlwaysOnTop(),
                        builder: (context, snapshot) {
                          return IconButton(
                            tooltip: context.l10n.always_on_top,
                            icon: Icon(
                              snapshot.data == true
                                  ? SpotubeIcons.pinOn
                                  : SpotubeIcons.pinOff,
                            ),
                            style: ButtonStyle(
                              foregroundColor: snapshot.data == true
                                  ? WidgetStateProperty.all(
                                      theme.colorScheme.primary)
                                  : null,
                            ),
                            onPressed: snapshot.data == null
                                ? null
                                : () async {
                                    await windowManager.setAlwaysOnTop(
                                      snapshot.data == true ? false : true,
                                    );
                                    update();
                                  },
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
          ),
          body: Column(
            children: [
              if (playlistQueue.activeTrack != null)
                Text(
                  playlistQueue.activeTrack!.name!,
                  style: theme.textTheme.titleMedium,
                ),
              if (showLyrics.value)
                Expanded(
                  child: TabBarView(
                    children: [
                      SyncedLyrics(
                        palette: PaletteColor(theme.colorScheme.surface, 0),
                        isModal: true,
                        defaultTextZoom: 65,
                      ),
                      PlainLyrics(
                        palette: PaletteColor(theme.colorScheme.surface, 0),
                        isModal: true,
                        defaultTextZoom: 65,
                      ),
                    ],
                  ),
                )
              else
                const Gap(20),
              AnimatedCrossFade(
                crossFadeState: areaActive.value
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                duration: const Duration(milliseconds: 200),
                secondChild: const SizedBox(),
                firstChild: Row(
                  children: [
                    IconButton(
                      icon: const Icon(SpotubeIcons.queue),
                      tooltip: context.l10n.queue,
                      onPressed: playlistQueue.activeTrack != null
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
                                  return Consumer(builder: (context, ref, _) {
                                    final playlist =
                                        ref.watch(audioPlayerProvider);

                                    return PlayerQueue.fromAudioPlayerNotifier(
                                      floating: true,
                                      playlist: playlist,
                                      notifier: ref
                                          .read(audioPlayerProvider.notifier),
                                    );
                                  });
                                },
                              );
                            }
                          : null,
                    ),
                    const Flexible(child: PlayerControls(compact: true)),
                    IconButton(
                      tooltip: context.l10n.exit_mini_player,
                      icon: const Icon(SpotubeIcons.maximize),
                      onPressed: () async {
                        if (!kIsDesktop) return;

                        try {
                          await windowManager
                              .setMinimumSize(const Size(300, 700));
                          await windowManager.setAlwaysOnTop(false);
                          if (wasMaximized.value) {
                            await windowManager.maximize();
                          } else {
                            await windowManager.setSize(prevSize);
                          }
                          await windowManager.setAlignment(Alignment.center);
                          if (!kIsLinux) {
                            await windowManager.setHasShadow(true);
                          }
                          await Future.delayed(
                              const Duration(milliseconds: 200));
                        } finally {
                          if (context.mounted) {
                            GoRouter.of(context).go('/lyrics');
                          }
                        }
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
