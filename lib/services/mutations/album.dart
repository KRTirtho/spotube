import 'package:fl_query/fl_query.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/hooks/use_spotify_mutation.dart';

class AlbumMutations {
  const AlbumMutations();

  Mutation<bool, dynamic, bool> toggleFavorite(
    WidgetRef ref,
    String albumId, {
    List<String>? refreshQueries,
  }) {
    return useSpotifyMutation<bool, dynamic, bool, dynamic>(
      "toggle-album-like/$albumId",
      (isLiked, spotify) async {
        if (isLiked) {
          await spotify.me.removeAlbums([albumId]);
        } else {
          await spotify.me.saveAlbums([albumId]);
        }
        return !isLiked;
      },
      ref: ref,
      refreshQueries: refreshQueries,
    );
  }
}
