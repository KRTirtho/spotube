import 'package:fl_query/fl_query.dart';
import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/hooks/use_spotify_infinite_query.dart';
import 'package:spotube/provider/custom_spotify_endpoint_provider.dart';
import 'package:spotube/provider/user_preferences_provider.dart';

class CategoryQueries {
  const CategoryQueries();

  InfiniteQuery<Page<Category>, dynamic, int> list(
    WidgetRef ref,
    Market recommendationMarket,
  ) {
    ref.watch(userPreferencesProvider.select((s) => s.locale));
    final locale = useContext().l10n.localeName;
    return useSpotifyInfiniteQuery<Page<Category>, dynamic, int>(
      "category-playlists",
      (pageParam, spotify) async {
        final categories = await spotify.categories
            .list(
              country: recommendationMarket,
              locale: locale,
            )
            .getPage(8, pageParam);

        return categories;
      },
      initialPage: 0,
      nextPage: (lastPage, lastPageData) {
        if (lastPageData.isLast || (lastPageData.items ?? []).length < 8) {
          return null;
        }
        return lastPageData.nextOffset;
      },
      ref: ref,
    );
  }

  InfiniteQuery<Page<PlaylistSimple?>, dynamic, int> playlistsOf(
    WidgetRef ref,
    String category,
  ) {
    ref.watch(userPreferencesProvider.select((s) => s.locale));
    final market = ref
        .watch(userPreferencesProvider.select((s) => s.recommendationMarket));
    final locale = useContext().l10n.localeName;
    return useSpotifyInfiniteQuery<Page<PlaylistSimple?>, dynamic, int>(
      "category-playlists/$category",
      (pageParam, spotify) async {
        final playlists = await Pages<PlaylistSimple?>(
          spotify,
          "v1/browse/categories/$category/playlists?country=$market&locale=$locale",
          (json) => json == null ? null : PlaylistSimple.fromJson(json),
          'playlists',
          (json) => PlaylistsFeatured.fromJson(json),
        ).getPage(5, pageParam);

        return playlists;
      },
      initialPage: 0,
      nextPage: (lastPage, lastPageData) {
        if (lastPageData.isLast || (lastPageData.items ?? []).length < 5) {
          return null;
        }
        return lastPageData.nextOffset;
      },
      ref: ref,
    );
  }

  Query<List<String>, dynamic> genreSeeds(WidgetRef ref) {
    final customSpotify = ref.watch(customSpotifyEndpointProvider);
    final query = useQuery<List<String>, dynamic>(
      "genre-seeds",
      customSpotify.listGenreSeeds,
    );

    useEffect(() {
      return ref.listenManual(
        customSpotifyEndpointProvider,
        (previous, next) {
          if (previous != next) {
            query.refresh();
          }
        },
      ).close;
    }, [query]);

    return query;
  }
}
