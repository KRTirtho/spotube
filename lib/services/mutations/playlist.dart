import 'package:fl_query/fl_query.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/hooks/use_spotify_mutation.dart';

class PlaylistMutations {
  Mutation<bool, dynamic, bool> useToggleFavorite(
    WidgetRef ref,
    String playlistId, {
    List<String>? refreshQueries,
  }) {
    return useSpotifyMutation<bool, dynamic, bool, dynamic>(
      "toggle-playlist-like/$playlistId",
      (isLiked, spotify) async {
        if (isLiked) {
          await spotify.playlists.unfollowPlaylist(playlistId);
        } else {
          await spotify.playlists.followPlaylist(playlistId);
        }
        return !isLiked;
      },
      ref: ref,
      refreshQueries: refreshQueries,
    );
  }

  Mutation<bool, dynamic, String> useRemoveTrackOf(
    WidgetRef ref,
    String playlistId,
  ) {
    return useSpotifyMutation<bool, dynamic, String, dynamic>(
      "remove-track-from-playlist/$playlistId",
      (trackId, spotify) async {
        await spotify.playlists.removeTracks([trackId], playlistId);
        return true;
      },
      ref: ref,
      refreshQueries: ["playlist-tracks/$playlistId"],
    );
  }
}
