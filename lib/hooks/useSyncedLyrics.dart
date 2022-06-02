import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotube/provider/Playback.dart';

useSyncedLyrics(WidgetRef ref, Map<int, String> lyricsMap) {
  final player = ref.watch(playbackProvider.select(
    (value) => (value.player),
  ));
  final stream = player.core.positionStream;

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
