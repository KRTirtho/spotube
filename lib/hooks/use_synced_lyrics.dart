import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotube/services/audio_player/audio_player.dart';

int useSyncedLyrics(
  WidgetRef ref,
  Map<int, String> lyricsMap,
  int delay,
) {
  final stream = audioPlayer.positionStream;

  final currentTime = useState(0);

  useEffect(() {
    return stream.listen((pos) {
      if (lyricsMap.containsKey(pos.inSeconds + delay)) {
        currentTime.value = pos.inSeconds + delay;
      }
    }).cancel;
  }, [lyricsMap, delay]);

  return (Duration(seconds: currentTime.value)).inSeconds;
}
