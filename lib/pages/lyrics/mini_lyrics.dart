import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' hide Consumer;
import 'package:shadcn_flutter/shadcn_flutter_extension.dart';
import 'package:spotube/collections/routes.gr.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/modules/player/player_controls.dart';
import 'package:spotube/modules/player/player_queue.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/hooks/utils/use_force_update.dart';
import 'package:spotube/pages/lyrics/plain_lyrics.dart';
import 'package:spotube/pages/lyrics/synced_lyrics.dart';
import 'package:spotube/provider/audio_player/audio_player.dart';
import 'package:spotube/utils/platform.dart';
import 'package:window_manager/window_manager.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
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

    final index = useState(0);

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
      child: Scaffold(
        backgroundColor: theme.colorScheme.background.withValues(alpha: 0.4),
        headers: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: AnimatedCrossFade(
              duration: const Duration(milliseconds: 200),
              crossFadeState: areaActive.value
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              secondChild: const SizedBox(),
              firstChild: DragToMoveArea(
                child: Row(
                  spacing: 2,
                  children: [
                    const Gap(10),
                    if (kIsMacOS) const SizedBox(width: 65),
                    if (showLyrics.value)
                      Tabs(
                        index: index.value,
                        onChanged: (i) {
                          index.value = i;
                        },
                        children: [
                          TabItem(child: Text(context.l10n.synced)),
                          TabItem(child: Text(context.l10n.plain)),
                        ],
                      ),
                    const Spacer(),
                    Tooltip(
                      tooltip:
                          TooltipContainer(child: Text(context.l10n.lyrics))
                              .call,
                      child: IconButton(
                        variance: showLyrics.value
                            ? ButtonVariance.secondary
                            : ButtonVariance.ghost,
                        icon: showLyrics.value
                            ? const Icon(SpotubeIcons.lyrics)
                            : const Icon(SpotubeIcons.lyricsOff),
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
                    ),
                    Tooltip(
                      tooltip: TooltipContainer(
                        child: Text(context.l10n.show_hide_ui_on_hover),
                      ).call,
                      child: IconButton(
                        variance: hoverMode.value
                            ? ButtonVariance.secondary
                            : ButtonVariance.ghost,
                        icon: hoverMode.value
                            ? const Icon(SpotubeIcons.hoverOn)
                            : const Icon(SpotubeIcons.hoverOff),
                        onPressed: () async {
                          areaActive.value = true;
                          hoverMode.value = !hoverMode.value;
                        },
                      ),
                    ),
                    if (kIsDesktop)
                      FutureBuilder(
                        future: windowManager.isAlwaysOnTop(),
                        builder: (context, snapshot) {
                          return Tooltip(
                            tooltip: TooltipContainer(
                              child: Text(context.l10n.always_on_top),
                            ).call,
                            child: IconButton(
                              variance: snapshot.data == true
                                  ? ButtonVariance.secondary
                                  : ButtonVariance.ghost,
                              icon: Icon(
                                snapshot.data == true
                                    ? SpotubeIcons.pinOn
                                    : SpotubeIcons.pinOff,
                              ),
                              onPressed: snapshot.data == null
                                  ? null
                                  : () async {
                                      await windowManager.setAlwaysOnTop(
                                        snapshot.data == true ? false : true,
                                      );
                                      update();
                                    },
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
        child: Column(
          children: [
            if (playlistQueue.activeTrack != null)
              Text(playlistQueue.activeTrack!.name!).semiBold(),
            if (showLyrics.value)
              Expanded(
                child: IndexedStack(
                  index: index.value,
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
                  Tooltip(
                    tooltip: TooltipContainer(
                      child: Text(context.l10n.queue),
                    ).call,
                    child: IconButton.ghost(
                      icon: const Icon(SpotubeIcons.queue),
                      onPressed: playlistQueue.activeTrack != null
                          ? () {
                              openDrawer(
                                context: context,
                                barrierDismissible: true,
                                draggable: true,
                                barrierColor: Colors.black.withAlpha(100),
                                borderRadius: BorderRadius.circular(10),
                                transformBackdrop: false,
                                position: OverlayPosition.bottom,
                                surfaceBlur: context.theme.surfaceBlur,
                                surfaceOpacity: 0.7,
                                expands: true,
                                builder: (context) => Consumer(
                                  builder: (context, ref, _) {
                                    final playlist = ref.watch(
                                      audioPlayerProvider,
                                    );
                                    final playlistNotifier =
                                        ref.read(audioPlayerProvider.notifier);
                                    return ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxHeight:
                                            MediaQuery.of(context).size.height *
                                                0.8,
                                      ),
                                      child:
                                          PlayerQueue.fromAudioPlayerNotifier(
                                        floating: false,
                                        playlist: playlist,
                                        notifier: playlistNotifier,
                                      ),
                                    );
                                  },
                                ),
                              );
                            }
                          : null,
                    ),
                  ),
                  const Flexible(child: PlayerControls(compact: true)),
                  Tooltip(
                    tooltip: TooltipContainer(
                            child: Text(context.l10n.exit_mini_player))
                        .call,
                    child: IconButton.ghost(
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
                            context.navigateTo(const LyricsRoute());
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
