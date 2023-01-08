import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:platform_ui/platform_ui.dart';
import 'package:spotube/collections/spotube_icons.dart';
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
  final bool isModal;
  const LyricsPage({Key? key, this.isModal = false}) : super(key: key);

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

    Widget body = [
      SyncedLyrics(palette: palette, isModal: isModal),
      GeniusLyrics(palette: palette, isModal: isModal),
    ][index.value];

    final tabbar = PreferredSize(
      preferredSize: const Size.fromHeight(50),
      child: PlatformTabBar(
        isNavigational: PlatformProperty.only(linux: true, other: false),
        selectedIndex: index.value,
        onSelectedIndexChanged: (value) => index.value = value,
        backgroundColor: PlatformTheme.of(context).scaffoldBackgroundColor,
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
    );

    if (isModal) {
      return SafeArea(
        child: Container(
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
            child: Column(
              children: [
                const SizedBox(height: 5),
                Container(
                  height: 7,
                  width: 150,
                  decoration: BoxDecoration(
                    color: palette.titleTextColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                PlatformAppBar(
                  title: tabbar,
                  backgroundColor: Colors.transparent,
                  automaticallyImplyLeading: false,
                  toolbarOpacity: platform == TargetPlatform.iOS ? 0 : 1,
                  actions: [
                    PlatformIconButton(
                      icon: const Icon(SpotubeIcons.minimize),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(width: 5),
                  ],
                ),
                Expanded(child: body),
              ],
            ),
          ),
        ),
      );
    }
    return PlatformScaffold(
      extendBodyBehindAppBar: true,
      appBar: !kIsMacOS
          ? (platform != TargetPlatform.windows && !isModal
              ? PageWindowTitleBar(
                  toolbarOpacity: 0,
                  backgroundColor: Colors.transparent,
                  center: tabbar,
                )
              : tabbar)
          : null,
      body: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: UniversalImage.imageProvider(albumArt),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: ColoredBox(
            color: palette.color.withOpacity(.7),
            child: SafeArea(child: body),
          ),
        ),
      ),
    );
  }
}
