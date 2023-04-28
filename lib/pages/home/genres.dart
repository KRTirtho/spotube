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
import 'package:spotube/extensions/context.dart';

import 'package:spotube/provider/user_preferences_provider.dart';
import 'package:spotube/services/queries/queries.dart';
import 'package:tuple/tuple.dart';

class GenrePage extends HookConsumerWidget {
  const GenrePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final scrollController = useScrollController();
    final recommendationMarket = ref.watch(
      userPreferencesProvider.select((s) => s.recommendationMarket),
    );
    final categoriesQuery = useQueries.category.list(ref, recommendationMarket);

    final isMounted = useIsMounted();

    final searchText = useState("");
    final categories = useMemoized(
      () {
        final categories = categoriesQuery.pages
            .expand<Category>(
              (page) => page.items ?? const Iterable.empty(),
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
      placeholder: context.l10n.genre_categories_filter,
    );

    final list = RefreshIndicator(
      onRefresh: () async {
        await categoriesQuery.refreshAll();
      },
      child: Waypoint(
        onTouchEdge: () async {
          if (categoriesQuery.hasNextPage && isMounted()) {
            await categoriesQuery.fetchNext();
          }
        },
        controller: scrollController,
        child: ListView.builder(
          controller: scrollController,
          itemCount: categories.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            if (searchText.value.isEmpty && index == categories.length - 1) {
              return const ShimmerCategories();
            }
            return CategoryCard(categories[index]);
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
  }
}
