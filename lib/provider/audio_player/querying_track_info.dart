import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/models/playback/track_sources.dart';
import 'package:spotube/provider/audio_player/audio_player.dart';
import 'package:spotube/provider/server/track_sources.dart';

final queryingTrackInfoProvider = Provider<bool>((ref) {
  final audioPlayer = ref.watch(audioPlayerProvider);

  if (audioPlayer.activeTrack == null) {
    return false;
  }

  return ref
      .watch(trackSourcesProvider(
        TrackSourceQuery.fromTrack(
            audioPlayer.activeTrack! as SpotubeFullTrackObject),
      ))
      .isLoading;
});
