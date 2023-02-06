import 'package:catcher/catcher.dart';
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

  final featured = InfiniteQueryJob<Page<PlaylistSimple>, SpotifyApi, int>(
    queryKey: "featured-playlists",
    initialParam: 0,
    getNextPageParam: (lastPage, lastParam) =>
        lastPage.items?.length == 5 ? lastPage.nextOffset : null,
    getPreviousPageParam: (firstPage, firstParam) => firstPage.nextOffset - 6,
    refetchOnExternalDataChange: true,
    task: (_, pageParam, spotify) async {
      try {
        final playlists =
            await spotify.playlists.featured.getPage(5, pageParam);
        return playlists;
      } catch (e, stack) {
        Catcher.reportCheckedError(e, stack);
        rethrow;
      }
    },
  );
}
