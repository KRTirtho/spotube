import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/LoaderShimmers/ShimmerLyrics.dart';
import 'package:spotube/components/Lyrics/Lyrics.dart';
import 'package:spotube/components/Shared/PageWindowTitleBar.dart';
import 'package:spotube/components/Shared/SpotubeMarqueeText.dart';
import 'package:spotube/helpers/artist-to-string.dart';
import 'package:spotube/helpers/image-to-url-string.dart';
import 'package:spotube/hooks/useAutoScrollController.dart';
import 'package:spotube/hooks/useBreakpoints.dart';
import 'package:spotube/hooks/useCustomStatusBarColor.dart';
import 'package:spotube/hooks/usePaletteColor.dart';
import 'package:spotube/hooks/useSyncedLyrics.dart';
import 'package:spotube/provider/Playback.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:spotube/provider/SpotifyRequests.dart';

class SyncedLyrics extends HookConsumerWidget {
  const SyncedLyrics({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final timedLyricsSnapshot = ref.watch(rentanadviserLyricsQuery);

    Playback playback = ref.watch(playbackProvider);
    final breakpoint = useBreakpoints();
    final controller = useAutoScrollController();
    final failed = useState(false);
    final lyricValue = timedLyricsSnapshot.asData?.value;
    final lyricsMap = useMemoized(
      () =>
          lyricValue?.lyrics
              .map((lyric) => {lyric.time.inSeconds: lyric.text})
              .reduce((accumulator, lyricSlice) =>
                  {...accumulator, ...lyricSlice}) ??
          {},
      [lyricValue],
    );

    final currentTime = useSyncedLyrics(ref, lyricsMap);

    final textTheme = Theme.of(context).textTheme;

    useEffect(() {
      controller.scrollToIndex(0);
      failed.value = false;
      return null;
    }, [playback.track]);

    useEffect(() {
      if (lyricValue != null && lyricValue.rating <= 2) {
        Future.delayed(const Duration(seconds: 5), () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                actions: [
                  TextButton(
                    child: const Text("No"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  TextButton(
                    child: const Text("Yes"),
                    onPressed: () {
                      failed.value = true;
                      Navigator.pop(context);
                    },
                  ),
                ],
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      "The found lyrics might not be properly synced. Do you want to default to static (genius.com) lyrics?",
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Hint: Wait for a moment to see if the lyric actually sync. Sometimes it may sync.",
                    ),
                  ],
                ),
              );
            },
          );
        });
      }
      return null;
    }, [lyricValue]);

    // when synced lyrics not found, fallback to GeniusLyrics

    String albumArt = useMemoized(
      () => imageToUrlString(
        playback.track?.album?.images,
        index: (playback.track?.album?.images?.length ?? 1) - 1,
      ),
      [playback.track?.album?.images],
    );
    final palette = usePaletteColor(albumArt, ref);

    final headlineTextStyle = (breakpoint >= Breakpoints.md
            ? textTheme.headline3
            : textTheme.headline4?.copyWith(fontSize: 25))
        ?.copyWith(color: palette.titleTextColor);

    useCustomStatusBarColor(
      palette.color,
      true,
      noSetBGColor: true,
    );

    return Expanded(
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: CachedNetworkImageProvider(
              albumArt,
              cacheKey: albumArt,
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            color: palette.color.withOpacity(.7),
            child: SafeArea(
              child: failed.value
                  ? Lyrics(titleBarForegroundColor: palette.bodyTextColor)
                  : Column(
                      children: [
                        PageWindowTitleBar(
                          foregroundColor: palette.bodyTextColor,
                        ),
                        Center(
                            child: SizedBox(
                          height: breakpoint >= Breakpoints.md ? 50 : 30,
                          child: playback.track?.name != null &&
                                  playback.track!.name!.length > 29
                              ? SpotubeMarqueeText(
                                  text: playback.track?.name ?? "Not Playing",
                                  style: headlineTextStyle,
                                )
                              : Text(
                                  playback.track?.name ?? "Not Playing",
                                  style: headlineTextStyle,
                                ),
                        )),
                        Center(
                          child: Text(
                            artistsToString<Artist>(
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
                                final isActive =
                                    lyricSlice.time.inSeconds == currentTime;
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
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        lyricSlice.text,
                                        style: TextStyle(
                                          // indicating the active state of that lyric slice
                                          color: isActive
                                              ? Theme.of(context).primaryColor
                                              : palette.bodyTextColor,
                                          fontWeight:
                                              isActive ? FontWeight.bold : null,
                                          fontSize: 30,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        if (playback.track != null &&
                            (lyricValue == null ||
                                lyricValue.lyrics.isEmpty == true))
                          const Expanded(child: ShimmerLyrics()),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
