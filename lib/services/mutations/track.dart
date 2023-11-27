import 'package:fl_query/fl_query.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/hooks/spotify/use_spotify_mutation.dart';

class TrackMutations {
  const TrackMutations();

  Mutation<bool, dynamic, bool> toggleFavorite(
    WidgetRef ref,
    String trackId, {
    MutationOnMutationFn<bool, bool>? onMutate,
    MutationOnDataFn<bool, bool>? onData,
    MutationOnErrorFn<dynamic, bool>? onError,
  }) {
    return useSpotifyMutation<bool, dynamic, bool, bool>(
      'toggle-track-like/$trackId',
      (isLiked, spotify) async {
        if (isLiked) {
          await spotify.tracks.me.removeOne(trackId);
        } else {
          await spotify.tracks.me.saveOne(trackId);
        }
        return !isLiked;
      },
      ref: ref,
      onData: onData,
      onMutate: onMutate,
      refreshQueries: ["playlist-tracks/user-liked-tracks"],
      onError: onError,
    );
  }
}
