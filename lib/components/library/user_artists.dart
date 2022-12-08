import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:platform_ui/platform_ui.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/shared/fallbacks/anonymous_fallback.dart';
import 'package:spotube/components/shared/waypoint.dart';
import 'package:spotube/components/artist/artist_card.dart';
import 'package:spotube/provider/auth_provider.dart';
import 'package:spotube/provider/spotify_provider.dart';
import 'package:spotube/provider/SpotifyRequests.dart';

class UserArtists extends HookConsumerWidget {
  const UserArtists({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final auth = ref.watch(authProvider);
    if (auth.isAnonymous) {
      return const AnonymousFallback();
    }
    final artistQuery = useInfiniteQuery(
      job: currentUserFollowingArtistsQueryJob,
      externalData: ref.watch(spotifyProvider),
    );

    final artists = useMemoized(
        () => artistQuery.pages
            .expand<Artist>((page) => page?.items ?? const Iterable.empty())
            .toList(),
        [artistQuery.pages]);

    final hasNextPage = artistQuery.pages.isEmpty
        ? false
        : (artistQuery.pages.last?.items?.length ?? 0) == 15;

    return Material(
      type: MaterialType.transparency,
      textStyle: PlatformTheme.of(context).textTheme!.body!,
      color: PlatformTheme.of(context).scaffoldBackgroundColor,
      child: GridView.builder(
        itemCount: artists.length,
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          mainAxisExtent: 250,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        padding: const EdgeInsets.all(10),
        itemBuilder: (context, index) {
          return HookBuilder(builder: (context) {
            if (index == artists.length - 1 && hasNextPage) {
              return Waypoint(
                controller: useScrollController(),
                isGrid: true,
                onTouchEdge: () {
                  artistQuery.fetchNextPage();
                },
                child: ArtistCard(artists[index]),
              );
            }
            return ArtistCard(artists[index]);
          });
        },
      ),
    );
  }
}
