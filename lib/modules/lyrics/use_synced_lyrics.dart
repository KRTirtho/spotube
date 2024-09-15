import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotube/services/audio_player/audio_player.dart';
import 'package:spotube/services/logger/logger.dart';

int useSyncedLyrics(
  WidgetRef ref,
  Map<int, String> lyricsMap,
  int delay,
) {
  final stream = audioPlayer.positionStream;

  final currentTime = useState(0);

  useEffect(() {
    return stream.listen((pos) {
      try {
        if (lyricsMap.containsKey(pos.inSeconds + delay)) {
          currentTime.value = pos.inSeconds + delay;
        }
      } catch (e, stack) {
        AppLogger.reportError(e, stack);
      }
    }).cancel;
  }, [lyricsMap, delay]);

  return (Duration(seconds: currentTime.value)).inSeconds;
}
