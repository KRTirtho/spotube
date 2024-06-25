import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/provider/audio_player/audio_player.dart';
import 'package:spotube/provider/server/sourced_track.dart';
import 'package:spotube/services/audio_player/audio_player.dart';

final queryingTrackInfoProvider = Provider<bool>((ref) {
  final media = audioPlayer.playlist.index == -1 ||
          audioPlayer.playlist.medias.isEmpty
      ? null
      : audioPlayer.playlist.medias.elementAtOrNull(audioPlayer.playlist.index);
  final audioPlayerActiveTrack =
      media == null ? null : SpotubeMedia.fromMedia(media);

  final activeMedia = ref.watch(audioPlayerProvider.select(
        (s) => s.activeMedia == null
            ? null
            : SpotubeMedia.fromMedia(s.activeMedia!),
      )) ??
      audioPlayerActiveTrack;

  if (activeMedia == null) return false;

  return ref.watch(sourcedTrackProvider(activeMedia)).isLoading;
});
