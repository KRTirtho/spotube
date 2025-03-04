import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'package:spotube/collections/assets.gen.dart';
import 'package:spotube/collections/routes.gr.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/framework/app_pop_scope.dart';
import 'package:spotube/modules/player/player_actions.dart';
import 'package:spotube/modules/player/player_controls.dart';
import 'package:spotube/modules/player/volume_slider.dart';
import 'package:spotube/components/dialogs/track_details_dialog.dart';
import 'package:spotube/components/links/artist_link.dart';
import 'package:spotube/components/titlebar/titlebar.dart';
import 'package:spotube/components/image/universal_image.dart';
import 'package:spotube/extensions/artist_simple.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/extensions/image.dart';
import 'package:spotube/models/local_track.dart';
import 'package:spotube/modules/root/spotube_navigation_bar.dart';
import 'package:spotube/provider/authentication/authentication.dart';
import 'package:spotube/provider/audio_player/audio_player.dart';
import 'package:spotube/provider/server/active_sourced_track.dart';
import 'package:spotube/provider/volume_provider.dart';
import 'package:spotube/services/sourced_track/sources/youtube.dart';

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

    final shouldHide = useState(true);

    ref.listen(navigationPanelHeight, (_, height) {
      shouldHide.value = height.ceil() == 50;
    });

    if (shouldHide.value) {
      return const SizedBox();
    }

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

    useEffect(() {
      for (final renderView in WidgetsBinding.instance.renderViews) {
        renderView.automaticSystemUiAdjustment = false;
      }

      return () {
        for (final renderView in WidgetsBinding.instance.renderViews) {
          renderView.automaticSystemUiAdjustment = true;
        }
      };
    }, [panelController.isAttached && panelController.isPanelOpen]);

    return AppPopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        await panelController.close();
      },
      child: SurfaceCard(
        borderWidth: 0,
        surfaceOpacity: 0.9,
        padding: EdgeInsets.zero,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          headers: [
            SafeArea(
              child: TitleBar(
                surfaceOpacity: 0,
                surfaceBlur: 0,
                leading: [
                  IconButton.ghost(
                    icon: const Icon(SpotubeIcons.angleDown, size: 18),
                    onPressed: panelController.close,
                  )
                ],
                trailing: [
                  if (currentTrack is YoutubeSourcedTrack)
                    TextButton(
                      leading: Assets.logos.songlinkTransparent.image(
                        width: 20,
                        height: 20,
                        color: theme.colorScheme.foreground,
                      ),
                      onPressed: () {
                        final url = "https://song.link/s/${currentTrack.id}";

                        launchUrlString(url);
                      },
                      child: Text(context.l10n.song_link),
                    ),
                  Tooltip(
                    tooltip: TooltipContainer(
                      child: Text(context.l10n.details),
                    ),
                    child: IconButton.ghost(
                      icon: const Icon(SpotubeIcons.info, size: 18),
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
                    ),
                  )
                ],
              ),
            ),
          ],
          child: SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(8),
                    constraints:
                        const BoxConstraints(maxHeight: 300, maxWidth: 300),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(100),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: Offset.zero,
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
                  const SizedBox(height: 60),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          currentTrack?.name ?? context.l10n.not_playing,
                          style: const TextStyle(fontSize: 22),
                          maxFontSize: 22,
                          maxLines: 1,
                          textAlign: TextAlign.start,
                        ),
                        if (isLocalTrack)
                          Text(
                            currentTrack.artists?.asString() ?? "",
                            style: theme.typography.normal
                                .copyWith(fontWeight: FontWeight.bold),
                          )
                        else
                          ArtistLink(
                            artists: currentTrack?.artists ?? [],
                            textStyle: theme.typography.normal
                                .copyWith(fontWeight: FontWeight.bold),
                            onRouteChange: (route) {
                              panelController.close();
                              context.router.navigateNamed(route);
                            },
                            onOverflowArtistClick: () => context.navigateTo(
                              TrackRoute(trackId: currentTrack!.id!),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  const PlayerControls(),
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
                        child: OutlineButton(
                          leading: const Icon(SpotubeIcons.queue),
                          child: Text(context.l10n.queue),
                          onPressed: () {
                            context.pushRoute(const PlayerQueueRoute());
                          },
                        ),
                      ),
                      if (auth.asData?.value != null) const SizedBox(width: 10),
                      if (auth.asData?.value != null)
                        Expanded(
                          child: OutlineButton(
                            leading: const Icon(SpotubeIcons.music),
                            child: Text(context.l10n.lyrics),
                            onPressed: () {
                              context.pushRoute(const PlayerLyricsRoute());
                            },
                          ),
                        ),
                      const SizedBox(width: 10),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Consumer(builder: (context, ref, _) {
                      final volume = ref.watch(volumeProvider);
                      return VolumeSlider(
                        fullWidth: true,
                        value: volume,
                        onChanged: (value) {
                          ref.read(volumeProvider.notifier).setVolume(value);
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
