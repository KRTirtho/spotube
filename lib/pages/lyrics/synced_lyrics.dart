import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:platform_ui/platform_ui.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/shared/shimmers/shimmer_lyrics.dart';
import 'package:spotube/components/shared/spotube_marquee_text.dart';
import 'package:spotube/components/lyrics/lyric_delay_adjust_dialog.dart';
import 'package:spotube/hooks/use_auto_scroll_controller.dart';
import 'package:spotube/hooks/use_breakpoints.dart';
import 'package:spotube/hooks/use_synced_lyrics.dart';
import 'package:spotube/provider/playback_provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:spotube/services/queries/queries.dart';

import 'package:spotube/utils/type_conversion_utils.dart';

final lyricDelayState = StateProvider<Duration>(
  (ref) {
    return Duration.zero;
  },
);

class SyncedLyrics extends HookConsumerWidget {
  final PaletteColor palette;
  final bool? isModal;

  const SyncedLyrics({
    required this.palette,
    this.isModal,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    Playback playback = ref.watch(playbackProvider);
    final timedLyricsQuery = useQuery(
      job: Queries.lyrics.synced,
      externalData: playback.track,
    );
    final lyricDelay = ref.watch(lyricDelayState);

    final breakpoint = useBreakpoints();
    final controller = useAutoScrollController();
    final lyricValue = timedLyricsQuery.data;
    final lyricsMap = useMemoized(
      () =>
          lyricValue?.lyrics
              .map((lyric) => {lyric.time.inSeconds: lyric.text})
              .reduce((accumulator, lyricSlice) =>
                  {...accumulator, ...lyricSlice}) ??
          {},
      [lyricValue],
    );

    final currentTime = useSyncedLyrics(ref, lyricsMap, lyricDelay);

    final textTheme = Theme.of(context).textTheme;

    useEffect(() {
      controller.scrollToIndex(0);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(lyricDelayState.notifier).state = Duration.zero;
      });
      return null;
    }, [playback.track]);

    final headlineTextStyle = (breakpoint >= Breakpoints.md
            ? textTheme.headline3
            : textTheme.headline4?.copyWith(fontSize: 25))
        ?.copyWith(color: palette.titleTextColor);

    return Stack(
      children: [
        Column(
          children: [
            if (isModal != true)
              Center(
                child: SpotubeMarqueeText(
                  text: playback.track?.name ?? "Not Playing",
                  style: headlineTextStyle,
                  isHovering: true,
                ),
              ),
            if (isModal != true)
              Center(
                child: Text(
                  TypeConversionUtils.artists_X_String<Artist>(
                      playback.track?.artists ?? []),
                  style: breakpoint >= Breakpoints.md
                      ? textTheme.headline5
                      : textTheme.headline6,
                ),
              ),
            if (lyricValue != null && lyricValue.lyrics.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  controller: controller,
                  itemCount: lyricValue.lyrics.length,
                  itemBuilder: (context, index) {
                    final lyricSlice = lyricValue.lyrics[index];
                    final isActive = lyricSlice.time.inSeconds == currentTime;

                    if (isActive) {
                      controller.scrollToIndex(
                        index,
                        preferPosition: AutoScrollPosition.middle,
                      );
                    }
                    return AutoScrollTag(
                      key: ValueKey(index),
                      index: index,
                      controller: controller,
                      child: lyricSlice.text.isEmpty
                          ? Container()
                          : Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: AnimatedDefaultTextStyle(
                                  duration: const Duration(milliseconds: 250),
                                  style: TextStyle(
                                    color: isActive
                                        ? Colors.white
                                        : palette.bodyTextColor,
                                    fontWeight: isActive
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    fontSize: isActive ? 30 : 26,
                                  ),
                                  child: Text(
                                    lyricSlice.text,
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                    );
                  },
                ),
              ),
            if (playback.track != null &&
                (lyricValue == null || lyricValue.lyrics.isEmpty == true))
              const Expanded(child: ShimmerLyrics()),
          ],
        ),
        Positioned(
          top: 10,
          right: 10,
          child: Align(
            alignment: Alignment.centerRight,
            child: PlatformFilledButton(
              child: const Icon(
                SpotubeIcons.clock,
                size: 16,
              ),
              onPressed: () async {
                final delay = await showPlatformAlertDialog(
                  context,
                  builder: (context) => const LyricDelayAdjustDialog(),
                );
                if (delay != null) {
                  ref.read(lyricDelayState.notifier).state = delay;
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
