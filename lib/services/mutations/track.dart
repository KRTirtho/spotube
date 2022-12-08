import 'package:fl_query/fl_query.dart';
import 'package:spotify/spotify.dart';
import 'package:tuple/tuple.dart';

class TrackMutations {
  final toggleFavorite =
      MutationJob.withVariableKey<bool, Tuple2<SpotifyApi, bool>>(
    preMutationKey: "toggle-track-like",
    task: (queryKey, externalData) async {
      final trackId = getVariable(queryKey);
      final spotify = externalData.item1;
      final isLiked = externalData.item2;

      if (isLiked) {
        await spotify.tracks.me.removeOne(trackId);
      } else {
        await spotify.tracks.me.saveOne(trackId);
      }
      return !isLiked;
    },
  );
}
