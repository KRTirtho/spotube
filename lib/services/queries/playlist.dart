import 'package:fl_query/fl_query.dart';
import 'package:spotify/spotify.dart';

class PlaylistQueries {
  final doesUserFollow = QueryJob.withVariableKey<bool, SpotifyApi>(
    preQueryKey: "playlist-is-followed",
    task: (queryKey, spotify) {
      final idMap = getVariable(queryKey).split(":");

      return spotify.playlists.followedBy(idMap.first, [idMap.last]).then(
        (value) => value.first,
      );
    },
  );

  final ofMine = QueryJob<Iterable<PlaylistSimple>, SpotifyApi>(
    queryKey: "current-user-playlists",
    task: (_, spotify) {
      return spotify.playlists.me.all();
    },
  );

  final tracksOf = QueryJob.withVariableKey<List<Track>, SpotifyApi>(
    preQueryKey: "playlist-tracks",
    task: (queryKey, spotify) {
      final id = getVariable(queryKey);
      return id != "user-liked-tracks"
          ? spotify.playlists.getTracksByPlaylistId(id).all().then(
                (value) => value.toList(),
              )
          : spotify.tracks.me.saved.all().then(
                (tracks) => tracks.map((e) => e.track!).toList(),
              );
    },
  );
}
