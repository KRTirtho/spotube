import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/provider/audio_player/audio_player.dart';
import 'package:spotube/provider/server/sourced_track.dart';

final queryingTrackInfoProvider = Provider<bool>((ref) {
  final activeTrack =
      ref.watch(audioPlayerProvider.select((s) => s.activeTrack));

  if (activeTrack == null) return false;

  return ref.read(sourcedTrackProvider(activeTrack)).isLoading;
});
