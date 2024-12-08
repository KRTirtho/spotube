import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:collection/collection.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spotube/collections/fake.dart';

import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/fallbacks/anonymous_fallback.dart';
import 'package:spotube/modules/artist/artist_card.dart';
import 'package:spotube/components/inter_scrollbar/inter_scrollbar.dart';
import 'package:spotube/components/waypoint.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/provider/authentication/authentication.dart';
import 'package:spotube/provider/spotify/spotify.dart';

class UserArtists extends HookConsumerWidget {
  const UserArtists({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final auth = ref.watch(authenticationProvider);

    final artistQuery = ref.watch(followedArtistsProvider);
    final artistQueryNotifier = ref.watch(followedArtistsProvider.notifier);

    final searchText = useState('');

    final filteredArtists = useMemoized(() {
      final artists = artistQuery.asData?.value.items ?? [];

      if (searchText.value.isEmpty) {
        return artists.toList();
      }
      return artists
          .map((e) => (
                weightedRatio(e.name!, searchText.value),
                e,
              ))
          .sorted((a, b) => b.$1.compareTo(a.$1))
          .where((e) => e.$1 > 50)
          .map((e) => e.$2)
          .toList();
    }, [artistQuery.asData?.value.items, searchText.value]);

    final controller = useScrollController();

    if (auth.asData?.value == null) {
      return const AnonymousFallback();
    }

    return SafeArea(
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(followedArtistsProvider);
          },
          child: InterScrollbar(
            controller: controller,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: CustomScrollView(
                controller: controller,
                slivers: [
                  SliverAppBar(
                    floating: true,
                    flexibleSpace: SearchBar(
                      onChanged: (value) => searchText.value = value,
                      leading: const Icon(SpotubeIcons.filter),
                      hintText: context.l10n.filter_artist,
                    ),
                  ),
                  const SliverGap(10),
                  SliverLayoutBuilder(builder: (context, constrains) {
                    return SliverGrid.builder(
                      itemCount: filteredArtists.isEmpty
                          ? 6
                          : filteredArtists.length + 1,
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200,
                        mainAxisExtent: constrains.smAndDown ? 225 : 250,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemBuilder: (context, index) {
                        if (filteredArtists.isNotEmpty &&
                            index == filteredArtists.length) {
                          if (artistQuery.asData?.value.hasMore != true) {
                            return const SizedBox.shrink();
                          }

                          return Waypoint(
                            controller: controller,
                            isGrid: true,
                            onTouchEdge: artistQueryNotifier.fetchMore,
                            child: Skeletonizer(
                              enabled: true,
                              child: ArtistCard(FakeData.artist),
                            ),
                          );
                        }

                        return Skeletonizer(
                          enabled: artistQuery.isLoading,
                          child: ArtistCard(
                            filteredArtists.elementAtOrNull(index) ??
                                FakeData.artist,
                          ),
                        );
                      },
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
