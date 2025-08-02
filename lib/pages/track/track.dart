import 'dart:ui';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spotube/collections/fake.dart';
import 'package:spotube/collections/routes.gr.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/heart_button/heart_button.dart';
import 'package:spotube/components/image/universal_image.dart';
import 'package:spotube/components/links/artist_link.dart';
import 'package:spotube/components/links/link_text.dart';
import 'package:spotube/components/titlebar/titlebar.dart';
import 'package:spotube/components/track_tile/track_options_button.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/extensions/list.dart';
import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/provider/audio_player/audio_player.dart';
import 'package:spotube/provider/metadata_plugin/tracks/track.dart';
import 'package:spotube/services/audio_player/audio_player.dart';

import 'package:spotube/extensions/constrains.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class TrackPage extends HookConsumerWidget {
  static const name = "track";

  final String trackId;
  const TrackPage({
    super.key,
    @PathParam("id") required this.trackId,
  });

  @override
  Widget build(BuildContext context, ref) {
    final ThemeData(:typography, :colorScheme) = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    final playlist = ref.watch(audioPlayerProvider);
    final playlistNotifier = ref.watch(audioPlayerProvider.notifier);

    final isActive = playlist.activeTrack?.id == trackId;

    final trackQuery = ref.watch(metadataPluginTrackProvider(trackId));

    final track = trackQuery.asData?.value ?? FakeData.track;

    void onPlay() async {
      if (isActive) {
        audioPlayer.pause();
      } else {
        await playlistNotifier.load([track], autoPlay: true);
      }
    }

    return SafeArea(
      bottom: false,
      child: Scaffold(
        headers: const [
          TitleBar(
            backgroundColor: Colors.transparent,
            surfaceBlur: 0,
          )
        ],
        floatingHeader: true,
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: UniversalImage.imageProvider(
                      track.album.images.asUrlString(
                        placeholder: ImagePlaceholder.albumArt,
                      ),
                    ),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      colorScheme.background.withValues(alpha: 0.5),
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
                          colorScheme.background,
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
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: UniversalImage(
                                path: track.album.images.asUrlString(
                                  placeholder: ImagePlaceholder.albumArt,
                                ),
                                height: 200,
                                width: 200,
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              crossAxisAlignment: mediaQuery.smAndDown
                                  ? CrossAxisAlignment.center
                                  : CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  track.name,
                                ).large().semiBold(),
                                const Gap(10),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(SpotubeIcons.album),
                                    const Gap(5),
                                    Flexible(
                                      child: LinkText(
                                        track.album.name,
                                        AlbumRoute(
                                          id: track.album.id,
                                          album: track.album,
                                        ),
                                        push: true,
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
                                        artists: track.artists,
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
                                        Button.outline(
                                          leading:
                                              const Icon(SpotubeIcons.queueAdd),
                                          child: Text(context.l10n.queue),
                                          onPressed: () {
                                            playlistNotifier.addTrack(track);
                                          },
                                        ),
                                      const Gap(5),
                                      if (!isActive &&
                                          !playlist.tracks
                                              .containsBy(track, (t) => t.id))
                                        Tooltip(
                                          tooltip: TooltipContainer(
                                            child: Text(context.l10n.play_next),
                                          ).call,
                                          child: IconButton.outline(
                                            icon: const Icon(
                                                SpotubeIcons.lightning),
                                            onPressed: () {
                                              playlistNotifier
                                                  .addTracksAtFirst([track]);
                                            },
                                          ),
                                        ),
                                      const Gap(5),
                                      Tooltip(
                                        tooltip: TooltipContainer(
                                          child: Text(
                                            isActive
                                                ? context.l10n.pause_playback
                                                : context.l10n.play,
                                          ),
                                        ).call,
                                        child: IconButton.primary(
                                          shape: ButtonShape.circle,
                                          icon: Icon(
                                            isActive
                                                ? SpotubeIcons.pause
                                                : SpotubeIcons.play,
                                          ),
                                          onPressed: onPlay,
                                        ),
                                      ),
                                      const Gap(5),
                                      if (mediaQuery.smAndDown)
                                        const Spacer()
                                      else
                                        const Gap(20),
                                      TrackHeartButton(track: track),
                                      TrackOptionsButton(
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
      ),
    );
  }
}
