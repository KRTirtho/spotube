import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/helpers/artist-to-string.dart';
import 'package:spotube/helpers/timed-lyrics.dart';
import 'package:spotube/hooks/useAutoScrollController.dart';
import 'package:spotube/hooks/useBreakpoints.dart';
import 'package:spotube/hooks/useSyncedLyrics.dart';
import 'package:spotube/provider/Playback.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class SyncedLyrics extends HookConsumerWidget {
  const SyncedLyrics({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    Playback playback = ref.watch(playbackProvider);
    final breakpoint = useBreakpoints();
    final controller = useAutoScrollController();
    final timedLyrics = useMemoized(() {
      if (playback.currentTrack == null) return null;
      return getTimedLyrics(playback.currentTrack!);
    }, [playback.currentTrack]);
    final lyricsSnapshot = useFuture(timedLyrics);
    final lyricsMap = useMemoized(
      () =>
          lyricsSnapshot.data?.lyrics
              .map((lyric) => {lyric.time.inSeconds: lyric.text})
              .reduce((a, b) => {...a, ...b}) ??
          {},
      [lyricsSnapshot.data],
    );

    final currentTime = useSyncedLyrics(ref, lyricsMap);

    final textTheme = Theme.of(context).textTheme;

    return Expanded(
      child: Column(
        children: [
          Center(
            child: Text(
              playback.currentTrack?.name ?? "",
              style: breakpoint >= Breakpoints.md
                  ? textTheme.headline3
                  : textTheme.headline4?.copyWith(fontSize: 25),
            ),
          ),
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
