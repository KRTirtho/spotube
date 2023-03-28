import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:palette_generator/palette_generator.dart';

import 'package:spotify/spotify.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/player/player_actions.dart';
import 'package:spotube/components/player/player_controls.dart';
import 'package:spotube/components/shared/page_window_title_bar.dart';
import 'package:spotube/components/shared/image/universal_image.dart';
import 'package:spotube/hooks/use_breakpoints.dart';
import 'package:spotube/hooks/use_custom_status_bar_color.dart';
import 'package:spotube/hooks/use_palette_color.dart';
import 'package:spotube/models/local_track.dart';
import 'package:spotube/pages/lyrics/lyrics.dart';
import 'package:spotube/provider/authentication_provider.dart';
import 'package:spotube/provider/playlist_queue_provider.dart';
import 'package:spotube/utils/type_conversion_utils.dart';

class PlayerView extends HookConsumerWidget {
  const PlayerView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    final auth = ref.watch(AuthenticationNotifier.provider);
    final currentTrack = ref.watch(PlaylistQueueNotifier.provider.select(
      (value) => value?.activeTrack,
    ));
    final isLocalTrack = ref.watch(PlaylistQueueNotifier.provider.select(
      (value) => value?.activeTrack is LocalTrack,
    ));
    final breakpoint = useBreakpoints();

    useEffect(() {
      if (breakpoint.isMoreThan(Breakpoints.md)) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          GoRouter.of(context).pop();
        });
      }
      return null;
    }, [breakpoint]);

    String albumArt = useMemoized(
      () => TypeConversionUtils.image_X_UrlString(
        currentTrack?.album?.images,
        placeholder: ImagePlaceholder.albumArt,
      ),
      [currentTrack?.album?.images],
    );

    final PaletteColor paletteColor = usePaletteColor(albumArt, ref);

    useCustomStatusBarColor(
      paletteColor.color,
      GoRouter.of(context).location == "/player",
      noSetBGColor: true,
    );

    return Scaffold(
      appBar: PageWindowTitleBar(
        backgroundColor: Colors.transparent,
        foregroundColor: paletteColor.titleTextColor,
        toolbarOpacity: 1,
        leading: BackButton(color: paletteColor.titleTextColor),
      ),
      extendBodyBehindAppBar: true,
      body: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: UniversalImage.imageProvider(albumArt),
            fit: BoxFit.cover,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: UniversalImage(
                      path: albumArt,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          currentTrack?.name ?? "Not playing",
                          style: TextStyle(
                            fontSize: 20,
                            color: paletteColor.titleTextColor,
                          ),
                          maxLines: 1,
                          textAlign: TextAlign.start,
                        ),
                        if (isLocalTrack)
                          Text(
                            TypeConversionUtils.artists_X_String<Artist>(
                              currentTrack?.artists ?? [],
                            ),
                            style: theme.textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: paletteColor.bodyTextColor,
                            ),
                          )
                        else
                          TypeConversionUtils.artists_X_ClickableArtists(
                            currentTrack?.artists ?? [],
                            textStyle: theme.textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: paletteColor.bodyTextColor,
                            ),
                            onRouteChange: (route) {
                              GoRouter.of(context).pop();
                              GoRouter.of(context).push(route);
                            },
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  PlayerControls(iconColor: paletteColor.bodyTextColor),
                  const Spacer(),
                  PlayerActions(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    floatingQueue: false,
                    extraActions: [
                      if (auth != null)
                        IconButton(
                          tooltip: "Open Lyrics",
                          icon: const Icon(SpotubeIcons.music),
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
                                maxHeight:
                                    MediaQuery.of(context).size.height * 0.8,
                              ),
                              builder: (context) =>
                                  const LyricsPage(isModal: true),
                            );
                          },
                        )
                    ],
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
