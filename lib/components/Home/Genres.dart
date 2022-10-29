import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:platform_ui/platform_ui.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/Category/CategoryCard.dart';
import 'package:spotube/components/LoaderShimmers/ShimmerCategories.dart';
import 'package:spotube/components/Shared/Waypoint.dart';
import 'package:spotube/provider/SpotifyDI.dart';
import 'package:spotube/provider/SpotifyRequests.dart';
import 'package:spotube/provider/UserPreferences.dart';

class Genres extends HookConsumerWidget {
  const Genres({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
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

    return PlatformScaffold(
      backgroundColor: PlatformProperty.all(Colors.transparent),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          if (category == null) return Container();
          if (index == categories.length - 1) {
            return Waypoint(
              onEnter: () {
                if (categoriesQuery.hasNextPage) {
                  categoriesQuery.fetchNextPage();
                }
              },
              child: const ShimmerCategories(),
            );
          }
          return CategoryCard(category);
        },
      ),
    );
  }
}
