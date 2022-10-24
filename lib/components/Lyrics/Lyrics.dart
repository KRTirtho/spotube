import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/components/Lyrics/GeniusLyrics.dart';
import 'package:spotube/components/Lyrics/SyncedLyrics.dart';
import 'package:spotube/components/Shared/UniversalImage.dart';
import 'package:spotube/hooks/useCustomStatusBarColor.dart';
import 'package:spotube/hooks/usePaletteColor.dart';
import 'package:spotube/provider/Playback.dart';
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

    useCustomStatusBarColor(
      palette.color,
      true,
      noSetBGColor: true,
    );

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: const TabBar(
          isScrollable: true,
          tabs: [
            Tab(text: "Synced Lyrics"),
            Tab(text: "Lyrics (genius.com)"),
          ],
        ),
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
              child: SafeArea(
                child: TabBarView(
                  children: [
                    SyncedLyrics(palette: palette),
                    GeniusLyrics(palette: palette),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
