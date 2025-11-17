import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:shadcn_flutter/shadcn_flutter_extension.dart';
import 'package:spotube/collections/routes.gr.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/models/connect/connect.dart';
import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/modules/player/player_queue.dart';
import 'package:spotube/modules/player/volume_slider.dart';
import 'package:spotube/components/image/universal_image.dart';
import 'package:spotube/components/links/anchor_button.dart';
import 'package:spotube/components/links/artist_link.dart';
import 'package:spotube/components/titlebar/titlebar.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/extensions/duration.dart';
import 'package:spotube/provider/connect/clients.dart';
import 'package:spotube/provider/connect/connect.dart';
import 'package:media_kit/media_kit.dart' hide Track;

class RemotePlayerQueue extends ConsumerWidget {
  const RemotePlayerQueue({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final connectNotifier = ref.watch(connectProvider.notifier);
    final playlist = ref.watch(queueProvider);
    return PlayerQueue(
      playlist: playlist,
      floating: true,
      onJump: (track) async {
        final index = playlist.tracks.toList().indexOf(track);
        connectNotifier.jumpTo(index);
      },
      onRemove: (track) async {
        await connectNotifier.removeTrack(track);
      },
      onStop: () async => connectNotifier.stop(),
      onReorder: (oldIndex, newIndex) async {
        await connectNotifier.reorder(
          (oldIndex: oldIndex, newIndex: newIndex),
        );
      },
    );
  }
}

@RoutePage()
class ConnectControlPage extends HookConsumerWidget {
  static const name = "connect_control";

  const ConnectControlPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final ThemeData(:typography, :colorScheme) = Theme.of(context);

    final resolvedService =
        ref.watch(connectClientsProvider).asData?.value.resolvedService;
    final connect = ref.watch(connectProvider);
    final connectNotifier = ref.read(connectProvider.notifier);
    final playlist = ref.watch(queueProvider);
    final playing = ref.watch(playingProvider);
    final shuffled = ref.watch(shuffleProvider);
    final loopMode = ref.watch(loopModeProvider);

    ref.listen(connectClientsProvider, (prev, next) {
      if (next.asData?.value.resolvedService == null) {
        context.back();
      }
    });

    useEffect(() {
      if (connect.asData?.value == null) return null;

      final subscription = connect.asData?.value?.stream.listen((message) {
        final event = WebSocketEvent.fromJson(
          jsonDecode(message),
          (data) => data,
        );
        event.onError((event) {
          if (event.data != "Connection denied") return;
          if (!context.mounted) return;
          context.back();
        });
      });

      return () {
        subscription?.cancel();
      };
    }, [connect.asData?.value]);

    return SafeArea(
      bottom: false,
      child: Scaffold(
        headers: [
          TitleBar(
            title: Text(resolvedService?.name ?? ""),
          )
        ],
        child: LayoutBuilder(builder: (context, constrains) {
          return Row(
            children: [
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ).copyWith(top: 0),
                        constraints:
                            const BoxConstraints(maxHeight: 350, maxWidth: 350),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: UniversalImage(
                            path: (playlist.activeTrack?.album.images)
                                .asUrlString(
                              placeholder: ImagePlaceholder.albumArt,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      sliver: SliverMainAxisGroup(
                        slivers: [
                          SliverToBoxAdapter(
                            child: AnchorButton(
                              playlist.activeTrack?.name ?? "",
                              style: typography.h4,
                              onTap: () {
                                if (playlist.activeTrack == null) return;
                                context.navigateTo(
                                  TrackRoute(trackId: playlist.activeTrack!.id),
                                );
                              },
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: ArtistLink(
                              artists: playlist.activeTrack?.artists ?? [],
                              textStyle: typography.normal,
                              mainAxisAlignment: WrapAlignment.start,
                              onOverflowArtistClick: () => context.navigateTo(
                                TrackRoute(trackId: playlist.activeTrack!.id),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SliverGap(30),
                    SliverToBoxAdapter(
                      child: Consumer(
                        builder: (context, ref, _) {
                          final position = ref.watch(positionProvider);
                          final duration = ref.watch(durationProvider);

                          final progress = duration.inSeconds == 0
                              ? 0
                              : position.inSeconds / duration.inSeconds;

                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Column(
                              children: [
                                Slider(
                                  value:
                                      SliderValue.single(progress.toDouble()),
                                  onChanged: (value) {
                                    connectNotifier.seek(
                                      Duration(
                                        seconds:
                                            (value.value * duration.inSeconds)
                                                .toInt(),
                                      ),
                                    );
                                  },
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(position.toHumanReadableString()),
                                    Text(duration.toHumanReadableString()),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 20,
                        children: [
                          Tooltip(
                            tooltip: TooltipContainer(
                              child: Text(
                                shuffled
                                    ? context.l10n.unshuffle_playlist
                                    : context.l10n.shuffle_playlist,
                              ),
                            ).call,
                            child: IconButton(
                              icon: const Icon(SpotubeIcons.shuffle),
                              variance: shuffled
                                  ? ButtonVariance.secondary
                                  : ButtonVariance.ghost,
                              onPressed: playlist.activeTrack == null
                                  ? null
                                  : () {
                                      connectNotifier.setShuffle(!shuffled);
                                    },
                            ),
                          ),
                          Tooltip(
                            tooltip: TooltipContainer(
                              child: Text(context.l10n.previous_track),
                            ).call,
                            child: IconButton.ghost(
                              icon: const Icon(SpotubeIcons.skipBack),
                              onPressed: playlist.activeTrack == null
                                  ? null
                                  : connectNotifier.previous,
                            ),
                          ),
                          Tooltip(
                            tooltip: TooltipContainer(
                              child: Text(
                                playing
                                    ? context.l10n.pause_playback
                                    : context.l10n.resume_playback,
                              ),
                            ).call,
                            child: IconButton.primary(
                              shape: ButtonShape.circle,
                              icon: playlist.activeTrack == null
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                          onSurface: false),
                                    )
                                  : Icon(
                                      playing
                                          ? SpotubeIcons.pause
                                          : SpotubeIcons.play,
                                    ),
                              onPressed: playlist.activeTrack == null
                                  ? null
                                  : () {
                                      if (playing) {
                                        connectNotifier.pause();
                                      } else {
                                        connectNotifier.resume();
                                      }
                                    },
                            ),
                          ),
                          Tooltip(
                            tooltip: TooltipContainer(
                                    child: Text(context.l10n.next_track))
                                .call,
                            child: IconButton.ghost(
                              icon: const Icon(SpotubeIcons.skipForward),
                              onPressed: playlist.activeTrack == null
                                  ? null
                                  : connectNotifier.next,
                            ),
                          ),
                          Tooltip(
                            tooltip: TooltipContainer(
                              child: Text(
                                loopMode == PlaylistMode.single
                                    ? context.l10n.loop_track
                                    : loopMode == PlaylistMode.loop
                                        ? context.l10n.repeat_playlist
                                        : context.l10n.no_loop,
                              ),
                            ).call,
                            child: IconButton(
                              icon: Icon(
                                loopMode == PlaylistMode.single
                                    ? SpotubeIcons.repeatOne
                                    : SpotubeIcons.repeat,
                              ),
                              variance: loopMode == PlaylistMode.single ||
                                      loopMode == PlaylistMode.loop
                                  ? ButtonVariance.secondary
                                  : ButtonVariance.ghost,
                              onPressed: playlist.activeTrack == null
                                  ? null
                                  : () async {
                                      connectNotifier.setLoopMode(
                                        switch (loopMode) {
                                          PlaylistMode.loop =>
                                            PlaylistMode.single,
                                          PlaylistMode.single =>
                                            PlaylistMode.none,
                                          PlaylistMode.none =>
                                            PlaylistMode.loop,
                                        },
                                      );
                                    },
                            ),
                          )
                        ],
                      ),
                    ),
                    const SliverGap(30),
                    if (constrains.mdAndDown)
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        sliver: SliverToBoxAdapter(
                          child: Button.outline(
                            leading: const Icon(SpotubeIcons.queue),
                            child: Text(context.l10n.queue),
                            onPressed: () {
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
                                builder: (context) {
                                  return ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxHeight:
                                          MediaQuery.sizeOf(context).height *
                                              0.8,
                                    ),
                                    child: const RemotePlayerQueue(),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    const SliverGap(30),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      sliver: SliverToBoxAdapter(
                        child: Consumer(builder: (context, ref, _) {
                          final volume = ref.watch(volumeProvider);
                          return VolumeSlider(
                            fullWidth: true,
                            value: volume,
                            onChanged: (value) {
                              ref.read(volumeProvider.notifier).state = value;
                              connectNotifier.setVolume(value);
                            },
                          );
                        }),
                      ),
                    ),
                    const SliverSafeArea(sliver: SliverGap(10)),
                  ],
                ),
              ),
              if (constrains.lgAndUp) ...[
                const VerticalDivider(thickness: 1),
                const Expanded(
                  child: RemotePlayerQueue(),
                ),
              ]
            ],
          );
        }),
      ),
    );
  }
}
