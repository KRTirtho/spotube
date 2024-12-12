import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/models/local_track.dart';
import 'package:spotube/provider/audio_player/audio_player.dart';
import 'package:spotube/services/audio_player/audio_player.dart';
import 'package:spotube/services/sourced_track/sourced_track.dart';

class SourcedTrackNotifier
    extends FamilyAsyncNotifier<SourcedTrack?, SpotubeMedia?> {
  @override
  build(media) async {
    final track = media?.track;
    if (track == null || track is LocalTrack) {
      return null;
    }

    ref.listen(
      audioPlayerProvider.select((value) => value.tracks),
      (old, next) {
        if (next.isEmpty || next.none((element) => element.id == track.id)) {
          ref.invalidateSelf();
        }
      },
    );

    final sourcedTrack =
        await SourcedTrack.fetchFromTrack(track: track, ref: ref);

    return sourcedTrack;
  }

  Future<SourcedTrack?> switchToAlternativeSources() async {
    if (arg == null) {
      return null;
    }
    return await update((prev) async {
      return await SourcedTrack.fetchFromTrackAltSource(
        track: arg!.track,
        ref: ref,
      );
    });
  }
}

final sourcedTrackProvider = AsyncNotifierProviderFamily<SourcedTrackNotifier,
    SourcedTrack?, SpotubeMedia?>(
  () => SourcedTrackNotifier(),
);
