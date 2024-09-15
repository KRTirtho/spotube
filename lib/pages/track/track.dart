import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spotube/collections/fake.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/heart_button/heart_button.dart';
import 'package:spotube/components/image/universal_image.dart';
import 'package:spotube/components/links/artist_link.dart';
import 'package:spotube/components/links/link_text.dart';
import 'package:spotube/components/titlebar/titlebar.dart';
import 'package:spotube/components/track_tile/track_options.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/extensions/image.dart';
import 'package:spotube/extensions/list.dart';
import 'package:spotube/provider/audio_player/audio_player.dart';
import 'package:spotube/provider/spotify/spotify.dart';
import 'package:spotube/services/audio_player/audio_player.dart';

import 'package:spotube/extensions/constrains.dart';

class TrackPage extends HookConsumerWidget {
  static const name = "track";

  final String trackId;
  const TrackPage({
    super.key,
    required this.trackId,
  });

  @override
  Widget build(BuildContext context, ref) {
    final ThemeData(:textTheme, :colorScheme) = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    final playlist = ref.watch(audioPlayerProvider);
    final playlistNotifier = ref.watch(audioPlayerProvider.notifier);

    final isActive = playlist.activeTrack?.id == trackId;

    final trackQuery = ref.watch(trackProvider(trackId));

    final track = trackQuery.asData?.value ?? FakeData.track;

    void onPlay() async {
      if (isActive) {
        audioPlayer.pause();
      } else {
        await playlistNotifier.load([track], autoPlay: true);
      }
    }

    return Scaffold(
      appBar: const PageWindowTitleBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: UniversalImage.imageProvider(
                    track.album!.images.asUrlString(
                      placeholder: ImagePlaceholder.albumArt,
                    ),
                  ),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    colorScheme.surface.withOpacity(0.5),
                    BlendMode.srcOver,
                  ),
                  alignment: Alignment.topCenter,
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Skeletonizer(
                enabled: trackQuery.isLoading,
                child: Container(
                  alignment: Alignment.topCenter,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        colorScheme.surface,
                        Colors.transparent,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0.2, 1],
                    ),
                  ),
                  child: SafeArea(
                    child: Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      runAlignment: WrapAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: UniversalImage(
                            path: track.album!.images.asUrlString(
                              placeholder: ImagePlaceholder.albumArt,
                            ),
                            height: 200,
                            width: 200,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: mediaQuery.smAndDown
                                ? CrossAxisAlignment.center
                                : CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                track.name!,
                                style: textTheme.titleLarge,
                              ),
                              const Gap(10),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(SpotubeIcons.album),
                                  const Gap(5),
                                  Flexible(
                                    child: LinkText(
                                      track.album!.name!,
                                      '/album/${track.album!.id}',
                                      push: true,
                                      extra: track.album,
                                    ),
                                  ),
                                ],
                              ),
                              const Gap(10),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(SpotubeIcons.artist),
                                  const Gap(5),
                                  Flexible(
                                    child: ArtistLink(
                                      artists: track.artists!,
                                      hideOverflowArtist: false,
                                    ),
                                  ),
                                ],
                              ),
                              const Gap(10),
                              ConstrainedBox(
                                constraints:
                                    const BoxConstraints(maxWidth: 350),
                                child: Row(
                                  mainAxisSize: mediaQuery.smAndDown
                                      ? MainAxisSize.max
                                      : MainAxisSize.min,
                                  children: [
                                    const Gap(5),
                                    if (!isActive &&
                                        !playlist.tracks
                                            .containsBy(track, (t) => t.id))
                                      OutlinedButton.icon(
                                        icon: const Icon(SpotubeIcons.queueAdd),
                                        label: Text(context.l10n.queue),
                                        onPressed: () {
                                          playlistNotifier.addTrack(track);
                                        },
                                      ),
                                    const Gap(5),
                                    if (!isActive &&
                                        !playlist.tracks
                                            .containsBy(track, (t) => t.id))
                                      IconButton.outlined(
                                        icon:
                                            const Icon(SpotubeIcons.lightning),
                                        tooltip: context.l10n.play_next,
                                        onPressed: () {
                                          playlistNotifier
                                              .addTracksAtFirst([track]);
                                        },
                                      ),
                                    const Gap(5),
                                    IconButton.filled(
                                      tooltip: isActive
                                          ? context.l10n.pause_playback
                                          : context.l10n.play,
                                      icon: Icon(
                                        isActive
                                            ? SpotubeIcons.pause
                                            : SpotubeIcons.play,
                                        color: colorScheme.onPrimary,
                                      ),
                                      onPressed: onPlay,
                                    ),
                                    const Gap(5),
                                    if (mediaQuery.smAndDown)
                                      const Spacer()
                                    else
                                      const Gap(20),
                                    TrackHeartButton(track: track),
                                    TrackOptions(
                                      track: track,
                                      userPlaylist: false,
                                    ),
                                    const Gap(5),
                                  ],
                                ),
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
        ],
      ),
    );
  }
}
