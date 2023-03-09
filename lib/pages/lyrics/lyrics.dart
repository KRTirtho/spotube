import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/shared/page_window_title_bar.dart';
import 'package:spotube/components/shared/image/universal_image.dart';
import 'package:spotube/hooks/use_custom_status_bar_color.dart';
import 'package:spotube/hooks/use_palette_color.dart';
import 'package:spotube/pages/lyrics/plain_lyrics.dart';
import 'package:spotube/pages/lyrics/synced_lyrics.dart';
import 'package:spotube/provider/playlist_queue_provider.dart';
import 'package:spotube/utils/platform.dart';
import 'package:spotube/utils/type_conversion_utils.dart';

class LyricsPage extends HookConsumerWidget {
  final bool isModal;
  const LyricsPage({Key? key, this.isModal = false}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final playlist = ref.watch(PlaylistQueueNotifier.provider);
    String albumArt = useMemoized(
      () => TypeConversionUtils.image_X_UrlString(
        playlist?.activeTrack.album?.images,
        index: (playlist?.activeTrack.album?.images?.length ?? 1) - 1,
        placeholder: ImagePlaceholder.albumArt,
      ),
      [playlist?.activeTrack.album?.images],
    );
    final palette = usePaletteColor(albumArt, ref);

    useCustomStatusBarColor(
      palette.color,
      true,
      noSetBGColor: true,
    );

    const tabbar = TabBar(
      isScrollable: true,
      tabs: [
        Tab(text: "Synced"),
        Tab(text: "Plain"),
      ],
    );

    if (isModal) {
      return DefaultTabController(
        length: 2,
        child: SafeArea(
          child: Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background.withOpacity(.4),
              borderRadius: const BorderRadius.only(
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
                  AppBar(
                    title: tabbar,
                    backgroundColor: Colors.transparent,
                    automaticallyImplyLeading: false,
                    toolbarOpacity: 1,
                    actions: [
                      IconButton(
                        icon: const Icon(SpotubeIcons.minimize),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const SizedBox(width: 5),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        SyncedLyrics(palette: palette, isModal: isModal),
                        PlainLyrics(palette: palette, isModal: isModal),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: !kIsMacOS
            ? const PageWindowTitleBar(
                toolbarOpacity: 0,
                backgroundColor: Colors.transparent,
                title: tabbar,
              )
            : tabbar as PreferredSizeWidget?,
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
              child: SafeArea(
                child: TabBarView(
                  children: [
                    SyncedLyrics(palette: palette, isModal: isModal),
                    PlainLyrics(palette: palette, isModal: isModal),
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
