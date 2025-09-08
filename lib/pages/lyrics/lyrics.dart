import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' hide Consumer;
import 'package:shadcn_flutter/shadcn_flutter_extension.dart';

import 'package:spotube/components/titlebar/titlebar.dart';
import 'package:spotube/components/image/universal_image.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/hooks/utils/use_palette_color.dart';
import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/pages/lyrics/plain_lyrics.dart';
import 'package:spotube/pages/lyrics/synced_lyrics.dart';
import 'package:spotube/provider/audio_player/audio_player.dart';
import 'package:spotube/provider/lyrics/synced.dart';
import 'package:spotube/utils/platform.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class LyricsPage extends HookConsumerWidget {
  static const name = "lyrics";

  const LyricsPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final playlist = ref.watch(audioPlayerProvider);
    String albumArt = useMemoized(
      () => (playlist.activeTrack?.album.images).asUrlString(
        index: (playlist.activeTrack?.album.images.length ?? 1) - 1,
        placeholder: ImagePlaceholder.albumArt,
      ),
      [playlist.activeTrack?.album.images],
    );
    final palette = usePaletteColor(albumArt, ref);
    final selectedIndex = useState(0);

    Widget tabbar = Padding(
      padding: const EdgeInsets.all(10),
      child: Tabs(
        index: selectedIndex.value,
        onChanged: (index) => selectedIndex.value = index,
        children: [
          TabItem(child: Text(context.l10n.synced)),
          TabItem(child: Text(context.l10n.plain)),
        ],
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

    return SafeArea(
      bottom: false,
      child: Scaffold(
        floatingHeader: true,
        headers: [
          !kIsMacOS
              ? TitleBar(
                  backgroundColor: Colors.transparent,
                  title: tabbar,
                  height: 58 * context.theme.scaling,
                  surfaceBlur: 0,
                  automaticallyImplyLeading: false,
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
          ),
          margin: const EdgeInsets.only(bottom: 10),
          child: SurfaceCard(
            surfaceBlur: context.theme.surfaceBlur,
            surfaceOpacity: context.theme.surfaceOpacity,
            padding: EdgeInsets.zero,
            borderRadius: BorderRadius.zero,
            borderWidth: 0,
            child: ColoredBox(
              color: palette.color.withValues(alpha: .7),
              child: SafeArea(
                child: IndexedStack(
                  index: selectedIndex.value,
                  children: [
                    SyncedLyrics(palette: palette, isModal: false),
                    PlainLyrics(palette: palette, isModal: false),
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
