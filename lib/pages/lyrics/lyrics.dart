import 'dart:ui';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/titlebar/titlebar.dart';
import 'package:spotube/components/image/universal_image.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/extensions/image.dart';
import 'package:spotube/hooks/utils/use_custom_status_bar_color.dart';
import 'package:spotube/hooks/utils/use_palette_color.dart';
import 'package:spotube/pages/lyrics/plain_lyrics.dart';
import 'package:spotube/pages/lyrics/synced_lyrics.dart';
import 'package:spotube/provider/audio_player/audio_player.dart';
import 'package:spotube/utils/platform.dart';
import 'package:spotube/provider/spotify/spotify.dart';

class LyricsPage extends HookConsumerWidget {
  static const name = "lyrics";

  final bool isModal;
  const LyricsPage({super.key, this.isModal = false});

  @override
  Widget build(BuildContext context, ref) {
    final playlist = ref.watch(audioPlayerProvider);
    String albumArt = useMemoized(
      () => (playlist.activeTrack?.album?.images).asUrlString(
        index: (playlist.activeTrack?.album?.images?.length ?? 1) - 1,
        placeholder: ImagePlaceholder.albumArt,
      ),
      [playlist.activeTrack?.album?.images],
    );
    final palette = usePaletteColor(albumArt, ref);
    final mediaQuery = MediaQuery.of(context);
    final route = ModalRoute.of(context);
    final selectedIndex = useState(0);

    final resetStatusBar = useCustomStatusBarColor(
      palette.color,
      route?.isCurrent ?? false,
      noSetBGColor: true,
    );

    Widget tabbar = Padding(
      padding: const EdgeInsets.all(10),
      child: Opacity(
        opacity: 0.8,
        child: Tabs(
          index: selectedIndex.value,
          onChanged: (index) => selectedIndex.value = index,
          tabs: [
            Text(context.l10n.synced),
            Text(context.l10n.plain),
          ],
        ),
      ),
    );

    tabbar = Row(
      children: [
        tabbar,
        const Spacer(),
        Consumer(
          builder: (context, ref, child) {
            final playback = ref.watch(audioPlayerProvider);
            final lyric = ref.watch(syncedLyricsProvider(playback.activeTrack));
            final providerName = lyric.asData?.value.provider;

            if (providerName == null) {
              return const SizedBox.shrink();
            }

            return Align(
              alignment: Alignment.bottomRight,
              child: Text(context.l10n.powered_by_provider(providerName)),
            );
          },
        ),
        const Gap(5),
      ],
    );

    if (isModal) {
      return PopScope(
        canPop: true,
        onPopInvokedWithResult: (_, __) => resetStatusBar(),
        child: SafeArea(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background.withOpacity(.4),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
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
                    leading: [tabbar],
                    backgroundColor: Colors.transparent,
                    trailing: [
                      IconButton.ghost(
                        icon: const Icon(SpotubeIcons.minimize),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const SizedBox(width: 5),
                    ],
                  ),
                  Expanded(
                    child: IndexedStack(
                      index: selectedIndex.value,
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
    return SafeArea(
      bottom: mediaQuery.mdAndUp,
      child: Scaffold(
        floatingHeader: true,
        headers: [
          !kIsMacOS
              ? TitleBar(
                  backgroundColor: Colors.transparent,
                  title: tabbar,
                )
              : tabbar
        ],
        child: Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: UniversalImage.imageProvider(albumArt),
              fit: BoxFit.cover,
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(10),
            ),
          ),
          margin: const EdgeInsets.only(bottom: 10),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: ColoredBox(
              color: palette.color.withOpacity(.7),
              child: SafeArea(
                child: IndexedStack(
                  index: selectedIndex.value,
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
