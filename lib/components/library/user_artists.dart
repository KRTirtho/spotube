import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:collection/collection.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:platform_ui/platform_ui.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/shared/fallbacks/anonymous_fallback.dart';
import 'package:spotube/components/shared/waypoint.dart';
import 'package:spotube/components/artist/artist_card.dart';
import 'package:spotube/provider/auth_provider.dart';
import 'package:spotube/provider/spotify_provider.dart';
import 'package:spotube/services/queries/queries.dart';
import 'package:tuple/tuple.dart';

class UserArtists extends HookConsumerWidget {
  const UserArtists({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final auth = ref.watch(authProvider);

    final artistQuery = useInfiniteQuery(
      job: Queries.artist.followedByMe,
      externalData: ref.watch(spotifyProvider),
    );

    final hasNextPage = artistQuery.pages.isEmpty
        ? false
        : (artistQuery.pages.last?.items?.length ?? 0) == 15;

    final searchText = useState('');

    final filteredArtists = useMemoized(() {
      final artists = artistQuery.pages
          .expand<Artist>((page) => page?.items ?? const Iterable.empty());

      if (searchText.value.isEmpty) {
        return artists.toList();
      }
      return artists
          .map((e) => Tuple2(
                weightedRatio(e.name!, searchText.value),
                e,
              ))
          .sorted((a, b) => b.item1.compareTo(a.item1))
          .where((e) => e.item1 > 50)
          .map((e) => e.item2)
          .toList();
    }, [artistQuery.pages, searchText.value]);

    if (auth.isAnonymous) {
      return const AnonymousFallback();
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ColoredBox(
            color: PlatformTheme.of(context).scaffoldBackgroundColor!,
            child: PlatformTextField(
              onChanged: (value) => searchText.value = value,
              prefixIcon: SpotubeIcons.filter,
              placeholder: 'Filter artists...',
            ),
          ),
        ),
      ),
      backgroundColor: PlatformTheme.of(context).scaffoldBackgroundColor,
      body: artistQuery.pages.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  PlatformCircularProgressIndicator(),
                  SizedBox(width: 10),
                  PlatformText("Loading..."),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: () async {
                await artistQuery.refetchPages();
              },
              child: GridView.builder(
                itemCount: filteredArtists.length,
                physics: const AlwaysScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  mainAxisExtent: 250,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                padding: const EdgeInsets.all(10),
                itemBuilder: (context, index) {
                  return HookBuilder(builder: (context) {
                    if (index == artistQuery.pages.length - 1 && hasNextPage) {
                      return Waypoint(
                        controller: useScrollController(),
                        isGrid: true,
                        onTouchEdge: () {
                          artistQuery.fetchNextPage();
                        },
                        child: ArtistCard(filteredArtists[index]),
                      );
                    }
                    return ArtistCard(filteredArtists[index]);
                  });
                },
              ),
            ),
    );
  }
}
