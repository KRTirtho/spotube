import 'package:fl_query/fl_query.dart';
import 'package:spotify/spotify.dart';
import 'package:tuple/tuple.dart';

class PlaylistMutations {
  final toggleFavorite =
      MutationJob.withVariableKey<bool, Tuple2<SpotifyApi, bool>>(
    preMutationKey: "toggle-playlist-like",
    task: (queryKey, externalData) async {
      final playlistId = getVariable(queryKey);
      final spotify = externalData.item1;
      final isLiked = externalData.item2;

      if (isLiked) {
        await spotify.playlists.unfollowPlaylist(playlistId);
      } else {
        await spotify.playlists.followPlaylist(playlistId);
      }
      return !isLiked;
    },
  );

  final removeTrackOf =
      MutationJob.withVariableKey<bool, Tuple2<SpotifyApi, String>>(
    preMutationKey: "remove-track-from-playlist",
    task: (queryKey, externalData) async {
      final spotify = externalData.item1;
      final playlistId = getVariable(queryKey);
      final trackId = externalData.item2;

      await spotify.playlists.removeTracks([trackId], playlistId);
      return true;
    },
  );
}
