import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:platform_ui/platform_ui.dart';
import 'package:spotube/components/Lyrics/GeniusLyrics.dart';
import 'package:spotube/components/Lyrics/SyncedLyrics.dart';
import 'package:spotube/components/Shared/PageWindowTitleBar.dart';
import 'package:spotube/components/Shared/UniversalImage.dart';
import 'package:spotube/hooks/useCustomStatusBarColor.dart';
import 'package:spotube/hooks/usePaletteColor.dart';
import 'package:spotube/provider/Playback.dart';
import 'package:spotube/utils/platform.dart';
import 'package:spotube/utils/type_conversion_utils.dart';

class Lyrics extends HookConsumerWidget {
  const Lyrics({Key? key}) : super(key: key);

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
              backgroundColor: Colors.transparent,
              toolbarOpacity: 0,
              center: PlatformTabBar(
                isNavigational:
                    PlatformProperty.only(linux: true, other: false),
                selectedIndex: index.value,
                onSelectedIndexChanged: (value) => index.value = value,
                tabs: [
                  PlatformTab(label: "Synced", icon: const SizedBox.shrink()),
                  PlatformTab(label: "Genius", icon: const SizedBox.shrink()),
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
