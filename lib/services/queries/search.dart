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
      "search-query/$query",
      (page, spotify) {
        if (query.trim().isEmpty) return [];
        final queryString = query;
        return spotify.search.get(
          queryString,
          types: [searchType],
        ).getPage(10, page);
      },
      ref: ref,
      initialPage: 0,
      nextPage: (lastPage, pages) =>
          pages.last.isNotEmpty && (pages.last.first.items?.length ?? 0) < 10
              ? null
              : pages.last.last.nextOffset,
    );
  }
}
