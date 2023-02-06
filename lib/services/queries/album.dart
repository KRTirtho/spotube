import 'package:catcher/catcher.dart';
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

  final newReleases = InfiniteQueryJob<Page<AlbumSimple>, SpotifyApi, int>(
    queryKey: "new-releases",
    initialParam: 0,
    getNextPageParam: (lastPage, lastParam) =>
        lastPage.items?.length == 5 ? lastPage.nextOffset : null,
    getPreviousPageParam: (firstPage, firstParam) => firstPage.nextOffset - 6,
    refetchOnExternalDataChange: true,
    task: (_, pageParam, spotify) async {
      try {
        final albums = await Pages(
          spotify,
          'v1/browse/new-releases',
          (json) => AlbumSimple.fromJson(json),
          'albums',
          (json) => AlbumSimple.fromJson(json),
        ).getPage(5, pageParam);
        return albums;
      } catch (e, stack) {
        Catcher.reportCheckedError(e, stack);
        rethrow;
      }
    },
  );
}
