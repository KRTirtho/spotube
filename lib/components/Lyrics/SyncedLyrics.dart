import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/Lyrics/Lyrics.dart';
import 'package:spotube/components/Shared/SpotubeMarqueeText.dart';
import 'package:spotube/helpers/artist-to-string.dart';
import 'package:spotube/hooks/useAutoScrollController.dart';
import 'package:spotube/hooks/useBreakpoints.dart';
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
    }, [playback.currentTrack]);

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
          if (lyricValue != null)
            Expanded(
              child: ListView.builder(
                controller: controller,
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
                itemCount: lyricValue.lyrics.length,
              ),
            ),
        ],
      ),
    );
  }
}
