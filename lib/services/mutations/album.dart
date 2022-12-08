import 'package:fl_query/fl_query.dart';
import 'package:spotify/spotify.dart';
import 'package:tuple/tuple.dart';

class AlbumMutations {
  final toggleFavorite =
      MutationJob.withVariableKey<bool, Tuple2<SpotifyApi, bool>>(
    preMutationKey: "toggle-album-like",
    task: (queryKey, externalData) async {
      final albumId = getVariable(queryKey);
      final spotify = externalData.item1;
      final isLiked = externalData.item2;

      if (isLiked) {
        await spotify.me.removeAlbums([albumId]);
      } else {
        await spotify.me.saveAlbums([albumId]);
      }
      return !isLiked;
    },
  );
}
