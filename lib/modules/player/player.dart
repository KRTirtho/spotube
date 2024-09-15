import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:spotube/collections/assets.gen.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/framework/app_pop_scope.dart';
import 'package:spotube/modules/player/player_actions.dart';
import 'package:spotube/modules/player/player_controls.dart';
import 'package:spotube/modules/player/player_queue.dart';
import 'package:spotube/modules/player/volume_slider.dart';
import 'package:spotube/components/animated_gradient.dart';
import 'package:spotube/components/dialogs/track_details_dialog.dart';
import 'package:spotube/components/links/artist_link.dart';
import 'package:spotube/components/titlebar/titlebar.dart';
import 'package:spotube/components/image/universal_image.dart';
import 'package:spotube/components/panels/sliding_up_panel.dart';
import 'package:spotube/extensions/artist_simple.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/extensions/image.dart';
import 'package:spotube/hooks/utils/use_custom_status_bar_color.dart';
import 'package:spotube/hooks/utils/use_palette_color.dart';
import 'package:spotube/models/local_track.dart';
import 'package:spotube/pages/lyrics/lyrics.dart';
import 'package:spotube/pages/track/track.dart';
import 'package:spotube/provider/authentication/authentication.dart';
import 'package:spotube/provider/audio_player/audio_player.dart';
import 'package:spotube/provider/server/active_sourced_track.dart';
import 'package:spotube/provider/volume_provider.dart';
import 'package:spotube/services/sourced_track/sources/youtube.dart';
import 'package:spotube/utils/service_utils.dart';

import 'package:url_launcher/url_launcher_string.dart';

class PlayerView extends HookConsumerWidget {
  final PanelController panelController;
  final ScrollController scrollController;
  const PlayerView({
    super.key,
    required this.panelController,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    final auth = ref.watch(authenticationProvider);
    final sourcedCurrentTrack = ref.watch(activeSourcedTrackProvider);
    final currentActiveTrack =
        ref.watch(audioPlayerProvider.select((s) => s.activeTrack));
    final currentTrack = sourcedCurrentTrack ?? currentActiveTrack;
    final isLocalTrack = currentTrack is LocalTrack;
    final mediaQuery = MediaQuery.of(context);

    useEffect(() {
      if (mediaQuery.lgAndUp) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          panelController.close();
        });
      }
      return null;
    }, [mediaQuery.lgAndUp]);

    String albumArt = useMemoized(
      () => (currentTrack?.album?.images).asUrlString(
        placeholder: ImagePlaceholder.albumArt,
      ),
      [currentTrack?.album?.images],
    );

    final palette = usePaletteGenerator(albumArt);
    final titleTextColor = palette.dominantColor?.titleTextColor;
    final bodyTextColor = palette.dominantColor?.bodyTextColor;

    final bgColor = palette.dominantColor?.color ?? theme.colorScheme.primary;

    final GlobalKey<ScaffoldState> scaffoldKey =
        useMemoized(() => GlobalKey(), []);

    useEffect(() {
      for (final renderView in WidgetsBinding.instance.renderViews) {
        renderView.automaticSystemUiAdjustment = false;
      }

      return () {
        for (final renderView in WidgetsBinding.instance.renderViews) {
          renderView.automaticSystemUiAdjustment = true;
        }
      };
    }, [panelController.isPanelOpen]);

    useCustomStatusBarColor(
      bgColor,
      panelController.isPanelOpen,
      noSetBGColor: true,
      automaticSystemUiAdjustment: false,
    );

    final topPadding = MediaQueryData.fromView(View.of(context)).padding.top;

    return AppPopScope(
      canPop: context.canPop(),
      onPopInvoked: (didPop) async {
        await panelController.close();
      },
      child: IconTheme(
        data: theme.iconTheme.copyWith(color: bodyTextColor),
        child: AnimateGradient(
          animateAlignments: true,
          primaryBegin: Alignment.topLeft,
          primaryEnd: Alignment.bottomLeft,
          secondaryBegin: Alignment.bottomRight,
          secondaryEnd: Alignment.topRight,
          duration: const Duration(seconds: 15),
          primaryColors: [
            palette.dominantColor?.color ?? theme.colorScheme.primary,
            palette.mutedColor?.color ?? theme.colorScheme.secondary,
          ],
          secondaryColors: [
            (palette.darkVibrantColor ?? palette.lightVibrantColor)?.color ??
                theme.colorScheme.primaryContainer,
            (palette.darkMutedColor ?? palette.lightMutedColor)?.color ??
                theme.colorScheme.secondaryContainer,
          ],
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: Colors.transparent,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(
                kToolbarHeight + topPadding,
              ),
              child: ForceDraggableWidget(
                child: Padding(
                  padding: EdgeInsets.only(top: topPadding),
                  child: PageWindowTitleBar(
                    backgroundColor: Colors.transparent,
                    foregroundColor: titleTextColor,
                    toolbarOpacity: 1,
                    leading: IconButton(
                      icon: const Icon(SpotubeIcons.angleDown, size: 18),
                      onPressed: panelController.close,
                    ),
                    actions: [
                      if (currentTrack is YoutubeSourcedTrack)
                        TextButton.icon(
                          icon: Assets.logos.songlinkTransparent.image(
                            width: 20,
                            height: 20,
                            color: bodyTextColor,
                          ),
                          label: Text(context.l10n.song_link),
                          style: TextButton.styleFrom(
                            foregroundColor: bodyTextColor,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                          ),
                          onPressed: () {
                            final url =
                                "https://song.link/s/${currentTrack.id}";

                            launchUrlString(url);
                          },
                        ),
                      IconButton(
                        icon: const Icon(SpotubeIcons.info, size: 18),
                        tooltip: context.l10n.details,
                        style: IconButton.styleFrom(
                          foregroundColor: bodyTextColor,
                        ),
                        onPressed: currentTrack == null
                            ? null
                            : () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return TrackDetailsDialog(
                                        track: currentTrack,
                                      );
                                    });
                              },
                      )
                    ],
                  ),
                ),
              ),
            ),
            extendBodyBehindAppBar: true,
            body: SingleChildScrollView(
              controller: scrollController,
              child: Container(
                alignment: Alignment.center,
                width: double.infinity,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 580),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          ForceDraggableWidget(
                            child: Container(
                              margin: const EdgeInsets.all(8),
                              constraints: const BoxConstraints(
                                  maxHeight: 300, maxWidth: 300),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    spreadRadius: 2,
                                    blurRadius: 10,
                                    offset: Offset(0, 0),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: UniversalImage(
                                  path: albumArt,
                                  placeholder: Assets.albumPlaceholder.path,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 60),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AutoSizeText(
                                  currentTrack?.name ??
                                      context.l10n.not_playing,
                                  style: TextStyle(
                                    color: titleTextColor,
                                    fontSize: 22,
                                  ),
                                  maxFontSize: 22,
                                  maxLines: 1,
                                  textAlign: TextAlign.start,
                                ),
                                if (isLocalTrack)
                                  Text(
                                    currentTrack.artists?.asString() ?? "",
                                    style: theme.textTheme.bodyMedium!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: bodyTextColor,
                                    ),
                                  )
                                else
                                  ArtistLink(
                                    artists: currentTrack?.artists ?? [],
                                    textStyle:
                                        theme.textTheme.bodyMedium!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: bodyTextColor,
                                    ),
                                    onRouteChange: (route) {
                                      panelController.close();
                                      GoRouter.of(context).push(route);
                                    },
                                    onOverflowArtistClick: () =>
                                        ServiceUtils.pushNamed(
                                      context,
                                      TrackPage.name,
                                      pathParameters: {
                                        "id": currentTrack!.id!,
                                      },
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          PlayerControls(palette: palette),
                          const SizedBox(height: 25),
                          const PlayerActions(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            showQueue: false,
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const SizedBox(width: 10),
                              Expanded(
                                child: OutlinedButton.icon(
                                    icon: const Icon(SpotubeIcons.queue),
                                    label: Text(context.l10n.queue),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: bodyTextColor,
                                      side: BorderSide(
                                        color: bodyTextColor ?? Colors.white,
                                      ),
                                    ),
                                    onPressed: currentTrack != null
                                        ? () {
                                            showModalBottomSheet(
                                              context: context,
                                              isDismissible: true,
                                              enableDrag: true,
                                              isScrollControlled: true,
                                              backgroundColor: Colors.black12,
                                              barrierColor: Colors.black12,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              constraints: BoxConstraints(
                                                maxHeight:
                                                    MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        .7,
                                              ),
                                              builder: (context) => Consumer(
                                                builder: (context, ref, _) {
                                                  final playlist = ref.watch(
                                                    audioPlayerProvider,
                                                  );
                                                  final playlistNotifier = ref
                                                      .read(audioPlayerProvider
                                                          .notifier);
                                                  return PlayerQueue
                                                      .fromAudioPlayerNotifier(
                                                    floating: false,
                                                    playlist: playlist,
                                                    notifier: playlistNotifier,
                                                  );
                                                },
                                              ),
                                            );
                                          }
                                        : null),
                              ),
                              if (auth.asData?.value != null)
                                const SizedBox(width: 10),
                              if (auth.asData?.value != null)
                                Expanded(
                                  child: OutlinedButton.icon(
                                    label: Text(context.l10n.lyrics),
                                    icon: const Icon(SpotubeIcons.music),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: bodyTextColor,
                                      side: BorderSide(
                                        color: bodyTextColor ?? Colors.white,
                                      ),
                                    ),
                                    onPressed: () {
                                      showModalBottomSheet(
                                        context: context,
                                        isDismissible: true,
                                        enableDrag: true,
                                        isScrollControlled: true,
                                        backgroundColor: Colors.black38,
                                        barrierColor: Colors.black12,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.circular(20),
                                          ),
                                        ),
                                        constraints: BoxConstraints(
                                          maxHeight: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.8,
                                        ),
                                        builder: (context) =>
                                            const LyricsPage(isModal: true),
                                      );
                                    },
                                  ),
                                ),
                              const SizedBox(width: 10),
                            ],
                          ),
                          const SizedBox(height: 25),
                          SliderTheme(
                            data: theme.sliderTheme.copyWith(
                              activeTrackColor: titleTextColor,
                              inactiveTrackColor: bodyTextColor,
                              thumbColor: titleTextColor,
                              overlayColor: titleTextColor?.withOpacity(0.2),
                              trackHeight: 2,
                              thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 8,
                              ),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Consumer(builder: (context, ref, _) {
                                final volume = ref.watch(volumeProvider);
                                return VolumeSlider(
                                  fullWidth: true,
                                  value: volume,
                                  onChanged: (value) {
                                    ref
                                        .read(volumeProvider.notifier)
                                        .setVolume(value);
                                  },
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
