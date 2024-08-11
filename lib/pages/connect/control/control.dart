import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/modules/player/player_queue.dart';
import 'package:spotube/modules/player/volume_slider.dart';
import 'package:spotube/components/image/universal_image.dart';
import 'package:spotube/components/links/anchor_button.dart';
import 'package:spotube/components/links/artist_link.dart';
import 'package:spotube/components/titlebar/titlebar.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/extensions/duration.dart';
import 'package:spotube/extensions/image.dart';
import 'package:spotube/pages/track/track.dart';
import 'package:spotube/provider/connect/clients.dart';
import 'package:spotube/provider/connect/connect.dart';
import 'package:media_kit/media_kit.dart' hide Track;
import 'package:spotube/utils/service_utils.dart';

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

class ConnectControlPage extends HookConsumerWidget {
  static const name = "connect_control";

  const ConnectControlPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final ThemeData(:textTheme, :colorScheme) = Theme.of(context);

    final resolvedService =
        ref.watch(connectClientsProvider).asData?.value.resolvedService;
    final connectNotifier = ref.read(connectProvider.notifier);
    final playlist = ref.watch(queueProvider);
    final playing = ref.watch(playingProvider);
    final shuffled = ref.watch(shuffleProvider);
    final loopMode = ref.watch(loopModeProvider);

    final resumePauseStyle = IconButton.styleFrom(
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
      padding: const EdgeInsets.all(12),
      iconSize: 24,
    );
    final buttonStyle = IconButton.styleFrom(
      backgroundColor: colorScheme.surface.withOpacity(0.4),
      minimumSize: const Size(28, 28),
    );

    final activeButtonStyle = IconButton.styleFrom(
      backgroundColor: colorScheme.primaryContainer,
      foregroundColor: colorScheme.onPrimaryContainer,
      minimumSize: const Size(28, 28),
    );

    ref.listen(connectClientsProvider, (prev, next) {
      if (next.asData?.value.resolvedService == null) {
        context.pop();
      }
    });

    return SafeArea(
      child: Scaffold(
        appBar: PageWindowTitleBar(
          title: Text(resolvedService!.name),
          automaticallyImplyLeading: true,
        ),
        body: LayoutBuilder(builder: (context, constrains) {
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
                            const BoxConstraints(maxHeight: 400, maxWidth: 400),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: UniversalImage(
                            path: (playlist.activeTrack?.album?.images)
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
                              style: textTheme.titleLarge!,
                              onTap: () {
                                if (playlist.activeTrack == null) return;
                                ServiceUtils.pushNamed(
                                  context,
                                  TrackPage.name,
                                  pathParameters: {
                                    "id": playlist.activeTrack!.id!,
                                  },
                                );
                              },
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: ArtistLink(
                              artists: playlist.activeTrack?.artists ?? [],
                              textStyle: textTheme.bodyMedium!,
                              mainAxisAlignment: WrapAlignment.start,
                              onOverflowArtistClick: () =>
                                  ServiceUtils.pushNamed(
                                context,
                                TrackPage.name,
                                pathParameters: {
                                  "id": playlist.activeTrack!.id!,
                                },
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

                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Column(
                              children: [
                                Slider(
                                  value: position > duration
                                      ? 0
                                      : position.inSeconds.toDouble(),
                                  min: 0,
                                  max: duration.inSeconds.toDouble(),
                                  onChanged: (value) {
                                    connectNotifier
                                        .seek(Duration(seconds: value.toInt()));
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
                        children: [
                          IconButton(
                            tooltip: shuffled
                                ? context.l10n.unshuffle_playlist
                                : context.l10n.shuffle_playlist,
                            icon: const Icon(SpotubeIcons.shuffle),
                            style: shuffled ? activeButtonStyle : buttonStyle,
                            onPressed: playlist.activeTrack == null
                                ? null
                                : () {
                                    connectNotifier.setShuffle(!shuffled);
                                  },
                          ),
                          IconButton(
                            tooltip: context.l10n.previous_track,
                            icon: const Icon(SpotubeIcons.skipBack),
                            onPressed: playlist.activeTrack == null
                                ? null
                                : connectNotifier.previous,
                          ),
                          IconButton(
                            tooltip: playing
                                ? context.l10n.pause_playback
                                : context.l10n.resume_playback,
                            icon: playlist.activeTrack == null
                                ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: colorScheme.onPrimary,
                                    ),
                                  )
                                : Icon(
                                    playing
                                        ? SpotubeIcons.pause
                                        : SpotubeIcons.play,
                                  ),
                            style: resumePauseStyle,
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
                          IconButton(
                            tooltip: context.l10n.next_track,
                            icon: const Icon(SpotubeIcons.skipForward),
                            onPressed: playlist.activeTrack == null
                                ? null
                                : connectNotifier.next,
                          ),
                          IconButton(
                            tooltip: loopMode == PlaylistMode.single
                                ? context.l10n.loop_track
                                : loopMode == PlaylistMode.loop
                                    ? context.l10n.repeat_playlist
                                    : null,
                            icon: Icon(
                              loopMode == PlaylistMode.single
                                  ? SpotubeIcons.repeatOne
                                  : SpotubeIcons.repeat,
                            ),
                            style: loopMode == PlaylistMode.single ||
                                    loopMode == PlaylistMode.loop
                                ? activeButtonStyle
                                : buttonStyle,
                            onPressed: playlist.activeTrack == null
                                ? null
                                : () async {
                                    connectNotifier.setLoopMode(
                                      switch (loopMode) {
                                        PlaylistMode.loop =>
                                          PlaylistMode.single,
                                        PlaylistMode.single =>
                                          PlaylistMode.none,
                                        PlaylistMode.none => PlaylistMode.loop,
                                      },
                                    );
                                  },
                          )
                        ],
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
                    const SliverGap(30),
                    if (constrains.mdAndDown)
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        sliver: SliverToBoxAdapter(
                          child: OutlinedButton.icon(
                            icon: const Icon(SpotubeIcons.queue),
                            label: Text(context.l10n.queue),
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return const RemotePlayerQueue();
                                },
                              );
                            },
                          ),
                        ),
                      )
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
