import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:spotube/helpers/timed-lyrics.dart';
import 'package:spotube/provider/AudioPlayer.dart';
import 'package:spotube/provider/Playback.dart';

class SyncedLyrics extends HookConsumerWidget {
  const SyncedLyrics({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    Playback playback = ref.watch(playbackProvider);
    AudioPlayer player = ref.watch(audioPlayerProvider);
    final timedLyrics = useMemoized(() {
      if (playback.currentTrack == null) return null;
      return getTimedLyrics(playback.currentTrack!);
    }, [playback.currentTrack]);
    final lyricsSnapshot = useFuture(timedLyrics);
    final stream = useStream(
      player.positionStream.isBroadcast
          ? player.positionStream
          : player.positionStream.asBroadcastStream(),
    );

    final lyricsMap = useMemoized(
      () =>
          lyricsSnapshot.data?.lyrics
              .map((lyric) => {lyric.time.inSeconds: lyric.text})
              .reduce((a, b) => {...a, ...b}) ??
          {},
      [lyricsSnapshot.data],
    );

    print(lyricsSnapshot.data?.name);

    final currentLyric = useState("");

    useEffect(() {
      if (stream.hasData && lyricsMap.containsKey(stream.data!.inSeconds)) {
        currentLyric.value = lyricsMap[stream.data!.inSeconds]!;
      }
      return null;
    }, [stream.data, stream.hasData]);

    return Expanded(
      child: Column(
        children: [
          const Text("Lyrics"),
          Text(currentLyric.value),
        ],
      ),
    );
  }
}
