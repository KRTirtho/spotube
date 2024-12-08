import 'package:flutter/material.dart' hide Image;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:collection/collection.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spotube/collections/fake.dart';

import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/modules/album/album_card.dart';
import 'package:spotube/components/inter_scrollbar/inter_scrollbar.dart';
import 'package:spotube/components/fallbacks/anonymous_fallback.dart';
import 'package:spotube/components/waypoint.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/provider/authentication/authentication.dart';
import 'package:spotube/provider/spotify/spotify.dart';

class UserAlbums extends HookConsumerWidget {
  const UserAlbums({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final auth = ref.watch(authenticationProvider);
    final albumsQuery = ref.watch(favoriteAlbumsProvider);
    final albumsQueryNotifier = ref.watch(favoriteAlbumsProvider.notifier);

    final controller = useScrollController();

    final searchText = useState('');

    final albums = useMemoized(() {
      if (searchText.value.isEmpty) {
        return albumsQuery.asData?.value.items ?? [];
      }
      return albumsQuery.asData?.value.items
              .map((e) => (
                    weightedRatio(e.name!, searchText.value),
                    e,
                  ))
              .sorted((a, b) => b.$1.compareTo(a.$1))
              .where((e) => e.$1 > 50)
              .map((e) => e.$2)
              .toList() ??
          [];
    }, [albumsQuery.asData?.value, searchText.value]);

    if (auth.asData?.value == null) {
      return const AnonymousFallback();
    }

    return SafeArea(
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(favoriteAlbumsProvider);
          },
          child: InterScrollbar(
            controller: controller,
            child: CustomScrollView(
              controller: controller,
              slivers: [
                SliverAppBar(
                  floating: true,
                  flexibleSpace: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: SearchBar(
                      onChanged: (value) => searchText.value = value,
                      leading: const Icon(SpotubeIcons.filter),
                      hintText: context.l10n.filter_albums,
                    ),
                  ),
                ),
                const SliverGap(10),
                SliverLayoutBuilder(builder: (context, constrains) {
                  return SliverGrid.builder(
                    itemCount: albums.isEmpty ? 6 : albums.length + 1,
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      mainAxisExtent: constrains.smAndDown ? 225 : 250,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemBuilder: (context, index) {
                      if (albums.isNotEmpty && index == albums.length) {
                        if (albumsQuery.asData?.value.hasMore != true) {
                          return const SizedBox.shrink();
                        }

                        return Waypoint(
                          controller: controller,
                          isGrid: true,
                          onTouchEdge: albumsQueryNotifier.fetchMore,
                          child: Skeletonizer(
                            enabled: true,
                            child: AlbumCard(FakeData.albumSimple),
                          ),
                        );
                      }

                      return Skeletonizer(
                        enabled: albumsQuery.isLoading,
                        child: AlbumCard(
                          albums.elementAtOrNull(index) ?? FakeData.albumSimple,
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
    );
  }
}
