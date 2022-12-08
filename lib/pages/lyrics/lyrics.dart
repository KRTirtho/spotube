import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:platform_ui/platform_ui.dart';
import 'package:spotube/components/shared/page_window_title_bar.dart';
import 'package:spotube/components/shared/image/universal_image.dart';
import 'package:spotube/hooks/use_custom_status_bar_color.dart';
import 'package:spotube/hooks/use_palette_color.dart';
import 'package:spotube/pages/lyrics/genius_lyrics.dart';
import 'package:spotube/pages/lyrics/synced_lyrics.dart';
import 'package:spotube/provider/playback_provider.dart';
import 'package:spotube/utils/platform.dart';
import 'package:spotube/utils/type_conversion_utils.dart';

class LyricsPage extends HookConsumerWidget {
  const LyricsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    Playback playback = ref.watch(playbackProvider);
    String albumArt = useMemoized(
      () => TypeConversionUtils.image_X_UrlString(
        playback.track?.album?.images,
        index: (playback.track?.album?.images?.length ?? 1) - 1,
        placeholder: ImagePlaceholder.albumArt,
      ),
      [playback.track?.album?.images],
    );
    final palette = usePaletteColor(albumArt, ref);
    final index = useState(0);

    useCustomStatusBarColor(
      palette.color,
      true,
      noSetBGColor: true,
    );

    final body = [
      SyncedLyrics(palette: palette),
      GeniusLyrics(palette: palette),
    ][index.value];

    return PlatformScaffold(
      extendBodyBehindAppBar: true,
      appBar: !kIsMacOS
          ? PageWindowTitleBar(
              toolbarOpacity: 0,
              backgroundColor: Colors.transparent,
              center: PlatformTabBar(
                isNavigational:
                    PlatformProperty.only(linux: true, other: false),
                selectedIndex: index.value,
                onSelectedIndexChanged: (value) => index.value = value,
                backgroundColor:
                    PlatformTheme.of(context).scaffoldBackgroundColor,
                tabs: [
                  PlatformTab(
                    label: "Synced",
                    icon: const SizedBox.shrink(),
                    color: PlatformTextTheme.of(context).caption?.color,
                  ),
                  PlatformTab(
                    label: "Genius",
                    icon: const SizedBox.shrink(),
                    color: PlatformTextTheme.of(context).caption?.color,
                  ),
                ],
              ),
            )
          : null,
      body: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: UniversalImage.imageProvider(albumArt),
            fit: BoxFit.cover,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            color: palette.color.withOpacity(.7),
            child: SafeArea(child: body),
          ),
        ),
      ),
    );
  }
}
