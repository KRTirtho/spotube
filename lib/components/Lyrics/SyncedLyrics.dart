import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/Lyrics.dart';
import 'package:spotube/components/Shared/SpotubeMarqueeText.dart';
import 'package:spotube/helpers/artist-to-string.dart';
import 'package:spotube/helpers/timed-lyrics.dart';
import 'package:spotube/hooks/useAutoScrollController.dart';
import 'package:spotube/hooks/useBreakpoints.dart';
import 'package:spotube/hooks/useSyncedLyrics.dart';
import 'package:spotube/models/SpotubeTrack.dart';
import 'package:spotube/provider/Playback.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class SyncedLyrics extends HookConsumerWidget {
  const SyncedLyrics({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    Playback playback = ref.watch(playbackProvider);
    final breakpoint = useBreakpoints();
    final controller = useAutoScrollController();
    final failed = useState(false);
    final timedLyrics = useMemoized(() async {
      if (playback.currentTrack == null ||
          playback.currentTrack is! SpotubeTrack) return null;
      try {
        final lyrics =
            await getTimedLyrics(playback.currentTrack as SpotubeTrack);
        if (failed.value) failed.value = false;
        return lyrics;
      } catch (e) {
        if (e == "Subtitle lookup failed") {
          failed.value = true;
        }
      }
    }, [playback.currentTrack]);
    final lyricsSnapshot = useFuture(timedLyrics);
    final lyricsMap = useMemoized(
      () =>
          lyricsSnapshot.data?.lyrics
              .map((lyric) => {lyric.time.inSeconds: lyric.text})
              .reduce((accumulator, lyricSlice) =>
                  {...accumulator, ...lyricSlice}) ??
          {},
      [lyricsSnapshot.data],
    );

    final currentTime = useSyncedLyrics(ref, lyricsMap);

    final textTheme = Theme.of(context).textTheme;

    useEffect(() {
      controller.scrollToIndex(
        0,
        preferPosition: AutoScrollPosition.middle,
      );
      return null;
    }, [playback.currentTrack]);

    // when synced lyrics not found, fallback to GeniusLyrics
    if (failed.value) return const Lyrics();

    final headlineTextStyle = breakpoint >= Breakpoints.md
        ? textTheme.headline3
        : textTheme.headline4?.copyWith(fontSize: 25);
    return Expanded(
      child: Column(
        children: [
          Center(
              child: SizedBox(
            height: breakpoint >= Breakpoints.md ? 50 : 30,
            child: playback.currentTrack?.name != null &&
                    playback.currentTrack!.name!.length > 29
                ? SpotubeMarqueeText(
                    text: playback.currentTrack?.name ?? "Not Playing",
                    style: headlineTextStyle,
                  )
                : Text(
                    playback.currentTrack?.name ?? "Not Playing",
                    style: headlineTextStyle,
                  ),
          )),
          Center(
            child: Text(
              artistsToString<Artist>(playback.currentTrack?.artists ?? []),
              style: breakpoint >= Breakpoints.md
                  ? textTheme.headline5
                  : textTheme.headline6,
            ),
          ),
          if (lyricsSnapshot.hasData)
            Expanded(
              child: ListView.builder(
                controller: controller,
                itemBuilder: (context, index) {
                  final lyricSlice = lyricsSnapshot.data!.lyrics[index];
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
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          lyricSlice.text,
                          style: TextStyle(
                            // indicating the active state of that lyric slice
                            color: isActive ? Colors.green : null,
                            fontWeight: isActive ? FontWeight.bold : null,
                            fontSize: 30,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                },
                itemCount: lyricsSnapshot.data!.lyrics.length,
              ),
            ),
        ],
      ),
    );
  }
}
