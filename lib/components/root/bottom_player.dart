import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter_desktop_tools/flutter_desktop_tools.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:spotube/collections/assets.gen.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/player/player_actions.dart';
import 'package:spotube/components/player/player_overlay.dart';
import 'package:spotube/components/player/player_track_details.dart';
import 'package:spotube/components/player/player_controls.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/hooks/use_brightness_value.dart';
import 'package:spotube/models/logger.dart';
import 'package:flutter/material.dart';
import 'package:spotube/provider/proxy_playlist/proxy_playlist_provider.dart';
import 'package:spotube/provider/user_preferences_provider.dart';
import 'package:spotube/services/audio_player/audio_player.dart';
import 'package:spotube/utils/platform.dart';
import 'package:spotube/utils/type_conversion_utils.dart';

class BottomPlayer extends HookConsumerWidget {
  BottomPlayer({Key? key}) : super(key: key);

  final logger = getLogger(BottomPlayer);
  @override
  Widget build(BuildContext context, ref) {
    final playlist = ref.watch(ProxyPlaylistNotifier.provider);
    final layoutMode =
        ref.watch(userPreferencesProvider.select((s) => s.layoutMode));

    final mediaQuery = MediaQuery.of(context);

    String albumArt = useMemoized(
      () => playlist.activeTrack?.album?.images?.isNotEmpty == true
          ? TypeConversionUtils.image_X_UrlString(
              playlist.activeTrack?.album?.images,
              index: (playlist.activeTrack?.album?.images?.length ?? 1) - 1,
              placeholder: ImagePlaceholder.albumArt,
            )
          : Assets.albumPlaceholder.path,
      [playlist.activeTrack?.album?.images],
    );

    final theme = Theme.of(context);
    final bg = theme.colorScheme.surfaceVariant;

    final bgColor = useBrightnessValue(
      Color.lerp(bg, Colors.white, 0.7),
      Color.lerp(bg, Colors.black, 0.45)!,
    );

    // returning an empty non spacious Container as the overlay will take
    // place in the global overlay stack aka [_entries]
    if (layoutMode == LayoutMode.compact ||
        ((mediaQuery.isSm || mediaQuery.isMd) &&
            layoutMode == LayoutMode.adaptive)) {
      return PlayerOverlay(albumArt: albumArt);
    }

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: DecoratedBox(
          decoration: BoxDecoration(color: bgColor?.withOpacity(0.8)),
          child: Material(
            type: MaterialType.transparency,
            textStyle: theme.textTheme.bodyMedium!,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(child: PlayerTrackDetails(albumArt: albumArt)),
                // controls
                Flexible(
                  flex: 3,
                  child: PlayerControls(),
                ),
                // add to saved tracks
                Expanded(
                  flex: 1,
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    runAlignment: WrapAlignment.center,
                    children: [
                      Container(
                        height: 20,
                        constraints: const BoxConstraints(maxWidth: 200),
                        child: HookBuilder(builder: (context) {
                          final volumeState =
                              useStream(audioPlayer.volumeStream).data ??
                                  audioPlayer.volume;
                          final volume = useState(volumeState);

                          useEffect(() {
                            if (volume.value != volumeState) {
                              volume.value = volumeState;
                            }
                            return null;
                          }, [volumeState]);

                          return Listener(
                            onPointerSignal: (event) async {
                              if (event is PointerScrollEvent) {
                                if (event.scrollDelta.dy > 0) {
                                  final value = volume.value - .2;
                                  audioPlayer.setVolume(value < 0 ? 0 : value);
                                } else {
                                  final value = volume.value + .2;
                                  audioPlayer.setVolume(value > 1 ? 1 : value);
                                }
                              }
                            },
                            child: Slider(
                              min: 0,
                              max: 1,
                              value: volume.value,
                              onChanged: (v) {
                                volume.value = v;
                              },
                              onChangeEnd: audioPlayer.setVolume,
                            ),
                          );
                        }),
                      ),
                      PlayerActions(
                        extraActions: [
                          IconButton(
                            tooltip: context.l10n.mini_player,
                            icon: const Icon(SpotubeIcons.miniPlayer),
                            onPressed: () async {
                              await DesktopTools.window.setMinimumSize(
                                const Size(300, 300),
                              );
                              await DesktopTools.window.setAlwaysOnTop(true);
                              if (!kIsLinux) {
                                await DesktopTools.window.setHasShadow(false);
                              }
                              await DesktopTools.window
                                  .setAlignment(Alignment.topRight);
                              await DesktopTools.window
                                  .setSize(const Size(400, 500));
                              await Future.delayed(
                                const Duration(milliseconds: 100),
                                () async {
                                  GoRouter.of(context).go('/mini-player');
                                },
                              );
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
