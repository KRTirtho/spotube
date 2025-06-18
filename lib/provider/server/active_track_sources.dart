import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/models/playback/track_sources.dart';
import 'package:spotube/provider/audio_player/audio_player.dart';
import 'package:spotube/provider/server/track_sources.dart';
import 'package:spotube/services/sourced_track/sourced_track.dart';

final activeTrackSourcesProvider = FutureProvider<
    ({
      SourcedTrack? source,
      TrackSourcesNotifier? notifier,
      SpotubeTrackObject track,
    })?>((ref) async {
  final audioPlayerState = ref.watch(audioPlayerProvider);

  if (audioPlayerState.activeTrack == null) {
    return null;
  }

  if (audioPlayerState.activeTrack is SpotubeLocalTrackObject) {
    return (
      source: null,
      notifier: null,
      track: audioPlayerState.activeTrack!,
    );
  }

  final trackQuery = TrackSourceQuery.fromTrack(
    audioPlayerState.activeTrack! as SpotubeFullTrackObject,
  );

  final sourcedTrack = await ref.watch(trackSourcesProvider(trackQuery).future);
  final sourcedTrackNotifier = ref.watch(
    trackSourcesProvider(trackQuery).notifier,
  );

  return (
    source: sourcedTrack,
    track: audioPlayerState.activeTrack!,
    notifier: sourcedTrackNotifier,
  );
});
