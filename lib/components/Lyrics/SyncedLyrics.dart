import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:platform_ui/platform_ui.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/LoaderShimmers/ShimmerLyrics.dart';
import 'package:spotube/components/Lyrics/LyricDelayAdjustDialog.dart';
import 'package:spotube/components/Shared/SpotubeMarqueeText.dart';
import 'package:spotube/hooks/useAutoScrollController.dart';
import 'package:spotube/hooks/useBreakpoints.dart';
import 'package:spotube/hooks/useSyncedLyrics.dart';
import 'package:spotube/provider/Playback.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:spotube/provider/SpotifyRequests.dart';
import 'package:spotube/utils/type_conversion_utils.dart';

final lyricDelayState = StateProvider<Duration>(
  (ref) {
    return Duration.zero;
  },
);

class SyncedLyrics extends HookConsumerWidget {
  final PaletteColor palette;
  const SyncedLyrics({
    required this.palette,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    Playback playback = ref.watch(playbackProvider);
    final timedLyricsQuery = useQuery(
      job: rentanadviserLyricsQueryJob,
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

    return Column(
      children: [
        SizedBox(
          height: breakpoint >= Breakpoints.md ? 50 : 30,
          child: Material(
            type: MaterialType.transparency,
            textStyle: PlatformTheme.of(context).textTheme!.body!,
            child: Stack(
              children: [
                Center(
                  child: SpotubeMarqueeText(
                    text: playback.track?.name ?? "Not Playing",
                    style: headlineTextStyle,
                    isHovering: true,
                  ),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: PlatformIconButton(
                      tooltip: "Lyrics Delay",
                      icon: const Icon(Icons.av_timer_rounded),
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
            ),
          ),
        ),
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
    );
  }
}
