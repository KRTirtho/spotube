import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/player/player_track_details.dart';
import 'package:spotube/collections/intents.dart';
import 'package:spotube/hooks/use_progress.dart';
import 'package:spotube/provider/proxy_playlist/proxy_playlist_provider.dart';
import 'package:spotube/services/audio_player/audio_player.dart';
import 'package:spotube/utils/service_utils.dart';

class PlayerOverlay extends HookConsumerWidget {
  final String albumArt;

  const PlayerOverlay({
    required this.albumArt,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final canShow = ref.watch(
      ProxyPlaylistNotifier.provider.select((s) => s.active != null),
    );
    final playlistNotifier = ref.watch(ProxyPlaylistNotifier.notifier);
    final playlist = ref.watch(ProxyPlaylistNotifier.provider);
    final playing =
        useStream(audioPlayer.playingStream).data ?? audioPlayer.isPlaying;

    final theme = Theme.of(context);
    final textColor = theme.colorScheme.primary;

    const radius = BorderRadius.only(
      topLeft: Radius.circular(10),
      topRight: Radius.circular(10),
    );

    return GestureDetector(
      onVerticalDragEnd: (details) {
        int sensitivity = 8;
        if (details.primaryVelocity != null &&
            details.primaryVelocity! < -sensitivity) {
          ServiceUtils.push(context, "/player");
        }
      },
      child: ClipRRect(
        borderRadius: radius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: MediaQuery.of(context).size.width,
            height: canShow ? 53 : 0,
            decoration: BoxDecoration(
              color: theme.colorScheme.secondaryContainer.withOpacity(.8),
              borderRadius: radius,
            ),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 250),
              opacity: canShow ? 1 : 0,
              child: Material(
                type: MaterialType.transparency,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    HookBuilder(
                      builder: (context) {
                        final progress = useProgress(ref);
                        // animated
                        return TweenAnimationBuilder<double>(
                          duration: const Duration(milliseconds: 250),
                          tween: Tween<double>(
                            begin: 0,
                            end: progress.progressStatic,
                          ),
                          builder: (context, value, child) {
                            return LinearProgressIndicator(
                              value: value,
                              minHeight: 2,
                              backgroundColor: Colors.transparent,
                              valueColor: AlwaysStoppedAnimation(
                                theme.colorScheme.primary,
                              ),
                            );
                          },
                        );
                      },
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () =>
                                    GoRouter.of(context).push("/player"),
                                child: PlayerTrackDetails(
                                  albumArt: albumArt,
                                  color: textColor,
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  SpotubeIcons.skipBack,
                                  color: textColor,
                                ),
                                onPressed: playlistNotifier.previous,
                              ),
                              Consumer(
                                builder: (context, ref, _) {
                                  return IconButton(
                                    icon: playlist.isFetching
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(),
                                          )
                                        : Icon(
                                            playing
                                                ? SpotubeIcons.pause
                                                : SpotubeIcons.play,
                                            color: textColor,
                                          ),
                                    onPressed: Actions.handler<PlayPauseIntent>(
                                      context,
                                      PlayPauseIntent(ref),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  SpotubeIcons.skipForward,
                                  color: textColor,
                                ),
                                onPressed: playlistNotifier.next,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
