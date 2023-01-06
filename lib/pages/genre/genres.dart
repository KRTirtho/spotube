import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:platform_ui/platform_ui.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/genre/category_card.dart';
import 'package:spotube/components/shared/shimmers/shimmer_categories.dart';
import 'package:spotube/components/shared/page_window_title_bar.dart';
import 'package:spotube/components/shared/waypoint.dart';
import 'package:spotube/provider/auth_provider.dart';
import 'package:spotube/provider/spotify_provider.dart';

import 'package:spotube/provider/user_preferences_provider.dart';
import 'package:spotube/services/queries/queries.dart';
import 'package:spotube/utils/platform.dart';

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
    final categories = [
      useMemoized(
        () => Category()
          ..id = "user-featured-playlists"
          ..name = "Featured",
        [],
      ),
      ...categoriesQuery.pages
          .expand<Category?>(
            (page) => page?.items ?? const Iterable.empty(),
          )
          .toList()
    ];

    final isMounted = useIsMounted();

    /// Temporary fix before fl-query 0.4.0
    final auth = ref.watch(authProvider);

    useEffect(() {
      if (auth.isLoggedIn && categoriesQuery.hasError) {
        categoriesQuery.setExternalData({
          "spotify": spotify,
          "recommendationMarket": recommendationMarket,
        });
        categoriesQuery.refetchPages();
      }
      return null;
    }, [auth, categoriesQuery.hasError]);

    /// ===================================

    return PlatformScaffold(
      appBar: kIsDesktop ? PageWindowTitleBar() : null,
      body: Waypoint(
        onTouchEdge: () async {
          if (categoriesQuery.hasNextPage && isMounted()) {
            await categoriesQuery.fetchNextPage();
          }
        },
        controller: scrollController,
        child: ListView.builder(
          controller: scrollController,
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            if (category == null) return Container();
            if (index == categories.length - 1) {
              return const ShimmerCategories();
            }
            return CategoryCard(category);
          },
        ),
      ),
    );
  }
}
