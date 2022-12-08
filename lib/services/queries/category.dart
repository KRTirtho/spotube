import 'package:fl_query/fl_query.dart';
import 'package:spotify/spotify.dart';

class CategoryQueries {
  final list = InfiniteQueryJob<Page<Category>, Map<String, dynamic>, int>(
    queryKey: "categories-query",
    initialParam: 0,
    getNextPageParam: (lastPage, lastParam) => lastPage.nextOffset,
    getPreviousPageParam: (lastPage, lastParam) => lastPage.nextOffset - 16,
    refetchOnExternalDataChange: true,
    task: (queryKey, pageParam, data) async {
      final SpotifyApi spotify = data["spotify"] as SpotifyApi;
      final String recommendationMarket = data["recommendationMarket"];
      final categories = await spotify.categories
          .list(country: recommendationMarket)
          .getPage(15, pageParam);

      return categories;
    },
  );

  final playlistsOf =
      InfiniteQueryJob.withVariableKey<Page<PlaylistSimple>, SpotifyApi, int>(
    preQueryKey: "category-playlists",
    initialParam: 0,
    getNextPageParam: (lastPage, lastParam) => lastPage.nextOffset,
    getPreviousPageParam: (lastPage, lastParam) => lastPage.nextOffset - 6,
    task: (queryKey, pageKey, spotify) {
      final id = getVariable(queryKey);
      return (id != "user-featured-playlists"
              ? spotify.playlists.getByCategoryId(id)
              : spotify.playlists.featured)
          .getPage(5, pageKey);
    },
  );
}
