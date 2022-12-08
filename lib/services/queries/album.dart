import 'package:fl_query/fl_query.dart';
import 'package:spotify/spotify.dart';

class AlbumQueries {
  final ofMine = QueryJob<Iterable<AlbumSimple>, SpotifyApi>(
    queryKey: "current-user-albums",
    task: (_, spotify) {
      return spotify.me.savedAlbums().all();
    },
  );

  final tracksOf = QueryJob.withVariableKey<List<TrackSimple>, SpotifyApi>(
    preQueryKey: "album-tracks",
    task: (queryKey, spotify) {
      final id = getVariable(queryKey);
      return spotify.albums.getTracks(id).all().then((value) => value.toList());
    },
  );

  final isSavedForMe =
      QueryJob.withVariableKey<bool, SpotifyApi>(task: (queryKey, spotify) {
    return spotify.me
        .isSavedAlbums([getVariable(queryKey)]).then((value) => value.first);
  });
}
