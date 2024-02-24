import 'package:fl_query/fl_query.dart';
import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/provider/spotify_provider.dart';

typedef SearchParams = ({
  SpotifyApi spotify,
  SearchType searchType,
  String query
});

class SearchQueries {
  const SearchQueries();

  static final queryJob =
      InfiniteQueryJob.withVariableKey<List<Page>, dynamic, int, SearchParams>(
    baseQueryKey: "search-query",
    task: (variableKey, page, args) => args!.spotify.search.get(
      args.query,
      types: [args.searchType],
    ).getPage(10, page),
    initialPage: 0,
    nextPage: (lastPage, lastPageData) {
      if (lastPageData.isEmpty) return null;
      if ((lastPageData.first.isLast ||
          (lastPageData.first.items ?? []).length < 10)) {
        return null;
      }
      return lastPageData.first.nextOffset;
    },
    enabled: false,
  );

  InfiniteQuery<List<Page>, dynamic, int> query(
    WidgetRef ref,
    String queryStr,
    SearchType searchType,
  ) {
    final spotify = ref.watch(spotifyProvider);
    final query = useInfiniteQueryJob<List<Page>, dynamic, int, SearchParams>(
      job: queryJob(searchType.name),
      args: (spotify: spotify, searchType: searchType, query: queryStr),
    );

    useEffect(() {
      return ref.listenManual(
        spotifyProvider,
        (previous, next) {
          if (previous != next) {
            query.refreshAll();
          }
        },
      ).close;
    }, [query]);

    return query;
  }
}
