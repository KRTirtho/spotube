import 'package:fl_query/fl_query.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/hooks/use_spotify_infinite_query.dart';

class SearchQueries {
  const SearchQueries();
  InfiniteQuery<List<Page>, dynamic, int> query(
    WidgetRef ref,
    String query,
    SearchType searchType,
  ) {
    return useSpotifyInfiniteQuery<List<Page>, dynamic, int>(
      "search-query/${searchType.name}",
      (page, spotify) {
        if (query.trim().isEmpty) return [];
        final queryString = query;
        return spotify.search.get(
          queryString,
          types: [searchType],
        ).getPage(10, page);
      },
      enabled: false,
      ref: ref,
      initialPage: 0,
      nextPage: (lastPage, lastPageData) {
        if (lastPageData.isEmpty) return null;
        if ((lastPageData.first.isLast ||
            (lastPageData.first.items ?? []).length < 10)) {
          return null;
        }
        return lastPageData.first.nextOffset;
      },
    );
  }
}
