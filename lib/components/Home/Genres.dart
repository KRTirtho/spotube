import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:platform_ui/platform_ui.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/Category/CategoryCard.dart';
import 'package:spotube/components/LoaderShimmers/ShimmerCategories.dart';
import 'package:spotube/components/Shared/PageWindowTitleBar.dart';
import 'package:spotube/components/Shared/Waypoint.dart';
import 'package:spotube/provider/SpotifyDI.dart';
import 'package:spotube/provider/SpotifyRequests.dart';
import 'package:spotube/provider/UserPreferences.dart';
import 'package:spotube/utils/platform.dart';

class Genres extends HookConsumerWidget {
  const Genres({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final scrollController = useScrollController();
    final spotify = ref.watch(spotifyProvider);
    final recommendationMarket = ref.watch(
      userPreferencesProvider.select((s) => s.recommendationMarket),
    );
    final categoriesQuery = useInfiniteQuery(
      job: categoriesQueryJob,
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
