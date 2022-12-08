import 'package:fl_query/fl_query.dart';
import 'package:spotify/spotify.dart';

class ArtistQueries {
  final get = QueryJob.withVariableKey<Artist, SpotifyApi>(
    preQueryKey: "artist-profile",
    task: (queryKey, externalData) =>
        externalData.artists.get(getVariable(queryKey)),
  );

  final followedByMe = InfiniteQueryJob<CursorPage<Artist>, SpotifyApi, String>(
    queryKey: "user-following-artists",
    initialParam: "",
    getNextPageParam: (lastPage, lastParam) => lastPage.after,
    getPreviousPageParam: (lastPage, lastParam) =>
        lastPage.metadata.previous ?? "",
    task: (queryKey, pageKey, spotify) {
      return spotify.me.following(FollowingType.artist).getPage(15, pageKey);
    },
  );

  final doIFollow = QueryJob.withVariableKey<bool, SpotifyApi>(
    preQueryKey: "user-follows-artists-query",
    task: (artistId, spotify) async {
      final result = await spotify.me.isFollowing(
        FollowingType.artist,
        [getVariable(artistId)],
      );
      return result.first;
    },
  );

  final topTracksOf = QueryJob.withVariableKey<Iterable<Track>, SpotifyApi>(
    preQueryKey: "artist-top-track-query",
    task: (queryKey, spotify) {
      return spotify.artists.getTopTracks(getVariable(queryKey), "US");
    },
  );

  final albumsOf =
      InfiniteQueryJob.withVariableKey<Page<Album>, SpotifyApi, int>(
    preQueryKey: "artist-albums",
    initialParam: 0,
    getNextPageParam: (lastPage, lastParam) => lastPage.nextOffset,
    getPreviousPageParam: (lastPage, lastParam) => lastPage.nextOffset - 6,
    task: (queryKey, pageKey, spotify) {
      final id = getVariable(queryKey);
      return spotify.artists.albums(id).getPage(5, pageKey);
    },
  );

  final relatedArtistsOf =
      QueryJob.withVariableKey<Iterable<Artist>, SpotifyApi>(
    preQueryKey: "artist-related-artist-query",
    task: (queryKey, spotify) {
      return spotify.artists.getRelatedArtists(getVariable(queryKey));
    },
  );
}
