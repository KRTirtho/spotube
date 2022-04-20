import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotube/provider/AudioPlayer.dart';

useSyncedLyrics(WidgetRef ref, Map<int, String> lyricsMap) {
  final player = ref.watch(audioPlayerProvider);
  final stream = player.positionStream.isBroadcast
      ? player.positionStream
      : player.positionStream.asBroadcastStream();

  final currentTime = useState(0);

  useEffect(() {
    final lol = stream.listen((pos) {
      if (lyricsMap.containsKey(pos.inSeconds)) {
        currentTime.value = pos.inSeconds;
      }
    });
    return () => lol.cancel();
  }, [lyricsMap]);

  return currentTime.value;
}
