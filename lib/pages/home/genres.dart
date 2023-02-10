import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:collection/collection.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/genre/category_card.dart';
import 'package:spotube/components/shared/compact_search.dart';
import 'package:spotube/components/shared/shimmers/shimmer_categories.dart';
import 'package:spotube/components/shared/waypoint.dart';
import 'package:spotube/provider/authentication_provider.dart';
import 'package:spotube/provider/spotify_provider.dart';

import 'package:spotube/provider/user_preferences_provider.dart';
import 'package:spotube/services/queries/queries.dart';
import 'package:tuple/tuple.dart';

class GenrePage extends HookConsumerWidget {
  const GenrePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final scrollController = useScrollController();
    final spotify = ref.watch(spotifyProvider);
    final recommendationMarket = ref.watch(
      userPreferencesProvider.select((s) => s.recommendationMarket),
    );
    final categoriesQuery = useInfiniteQuery(
      job: Queries.category.list,
      externalData: {
        "spotify": spotify,
        "recommendationMarket": recommendationMarket,
      },
    );

    final isMounted = useIsMounted();

    final auth = ref.watch(AuthenticationNotifier.provider);

    /// Temporary fix before fl-query 0.4.0
    useEffect(() {
      if (auth != null && categoriesQuery.hasError) {
        categoriesQuery.setExternalData({
          "spotify": spotify,
          "recommendationMarket": recommendationMarket,
        });
        categoriesQuery.refetchPages();
      }
      return null;
    }, [auth, categoriesQuery.hasError]);

    /// ===================================

    return HookBuilder(builder: (context) {
      final searchText = useState("");
      final categories = useMemoized(
        () {
          final categories = categoriesQuery.pages
              .expand<Category>(
                (page) => page?.items ?? const Iterable.empty(),
              )
              .toList();
          if (searchText.value.isEmpty) {
            return categories;
          }
          return categories
              .map((e) => Tuple2(
                    weightedRatio(e.name!, searchText.value),
                    e,
                  ))
              .sorted((a, b) => b.item1.compareTo(a.item1))
              .where((e) => e.item1 > 50)
              .map((e) => e.item2)
              .toList();
        },
        [categoriesQuery.pages, searchText.value],
      );

      final searchbar = CompactSearch(
        onChanged: (value) {
          searchText.value = value;
        },
        placeholder: "Filter categories or genres...",
      );

      final list = RefreshIndicator(
        onRefresh: () async {
          await categoriesQuery.refetchPages();
        },
        child: Waypoint(
          onTouchEdge: () async {
            if (categoriesQuery.hasNextPage && isMounted()) {
              await categoriesQuery.fetchNextPage();
            }
          },
          controller: scrollController,
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: scrollController,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              if (searchText.value.isEmpty && index == categories.length - 1) {
                return const ShimmerCategories();
              }
              return CategoryCard(category);
            },
          ),
        ),
      );
      return Stack(
        children: [
          Positioned.fill(child: list),
          Positioned(
            top: 0,
            right: 10,
            child: searchbar,
          ),
        ],
      );
    });
  }
}
