import 'package:flutter/material.dart' hide Image;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:collection/collection.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';

import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/album/album_card.dart';
import 'package:spotube/components/shared/inter_scrollbar/inter_scrollbar.dart';
import 'package:spotube/components/shared/shimmers/shimmer_playbutton_card.dart';
import 'package:spotube/components/shared/fallbacks/anonymous_fallback.dart';
import 'package:spotube/components/shared/waypoint.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/provider/authentication_provider.dart';
import 'package:spotube/services/queries/queries.dart';

import 'package:spotube/utils/type_conversion_utils.dart';

class UserAlbums extends HookConsumerWidget {
  const UserAlbums({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final auth = ref.watch(AuthenticationNotifier.provider);
    final albumsQuery = useQueries.album.ofMine(ref);

    final controller = useScrollController();

    final searchText = useState('');

    final allAlbums = useMemoized(
      () => albumsQuery.pages
          .expand((element) => element.items ?? <AlbumSimple>[]),
      [albumsQuery.pages],
    );

    final albums = useMemoized(() {
      if (searchText.value.isEmpty) {
        return allAlbums;
      }
      return allAlbums
          .map((e) => (
                weightedRatio(e.name!, searchText.value),
                e,
              ))
          .sorted((a, b) => b.$1.compareTo(a.$1))
          .where((e) => e.$1 > 50)
          .map((e) => e.$2)
          .toList();
    }, [allAlbums, searchText.value]);

    if (auth == null) {
      return const AnonymousFallback();
    }

    final theme = Theme.of(context);

    return RefreshIndicator(
      onRefresh: () async {
        await albumsQuery.refresh();
      },
      child: SafeArea(
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ColoredBox(
                color: theme.scaffoldBackgroundColor,
                child: SearchBar(
                  onChanged: (value) => searchText.value = value,
                  leading: const Icon(SpotubeIcons.filter),
                  hintText: context.l10n.filter_albums,
                ),
              ),
            ),
          ),
          body: SizedBox.expand(
            child: InterScrollbar(
              controller: controller,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(8.0),
                controller: controller,
                child: Wrap(
                  runSpacing: 20,
                  alignment: WrapAlignment.center,
                  runAlignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    if (albums.isEmpty)
                      Container(
                        alignment: Alignment.topLeft,
                        padding: const EdgeInsets.all(16.0),
                        child: const ShimmerPlaybuttonCard(count: 4),
                      ),
                    for (final album in albums)
                      AlbumCard(
                        TypeConversionUtils.simpleAlbum_X_Album(album),
                      ),
                    if (albumsQuery.hasNextPage)
                      Waypoint(
                        controller: controller,
                        isGrid: true,
                        onTouchEdge: albumsQuery.fetchNext,
                        child: const ShimmerPlaybuttonCard(count: 1),
                      )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
