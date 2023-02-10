import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:collection/collection.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:platform_ui/platform_ui.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/album/album_card.dart';
import 'package:spotube/components/shared/playbutton_card.dart';
import 'package:spotube/components/shared/shimmers/shimmer_playbutton_card.dart';
import 'package:spotube/components/shared/fallbacks/anonymous_fallback.dart';
import 'package:spotube/hooks/use_breakpoint_value.dart';
import 'package:spotube/provider/authentication_provider.dart';
import 'package:spotube/provider/spotify_provider.dart';
import 'package:spotube/services/queries/queries.dart';

import 'package:spotube/utils/type_conversion_utils.dart';
import 'package:tuple/tuple.dart';

class UserAlbums extends HookConsumerWidget {
  const UserAlbums({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final auth = ref.watch(AuthenticationNotifier.provider);
    final albumsQuery = useQuery(
      job: Queries.album.ofMine,
      externalData: ref.watch(spotifyProvider),
    );

    final spacing = useBreakpointValue<double>(
      sm: 0,
      others: 20,
    );
    final viewType = MediaQuery.of(context).size.width < 480
        ? PlaybuttonCardViewType.list
        : PlaybuttonCardViewType.square;

    final searchText = useState('');

    final albums = useMemoized(() {
      if (searchText.value.isEmpty) {
        return albumsQuery.data?.toList() ?? [];
      }
      return albumsQuery.data
              ?.map((e) => Tuple2(
                    weightedRatio(e.name!, searchText.value),
                    e,
                  ))
              .sorted((a, b) => b.item1.compareTo(a.item1))
              .where((e) => e.item1 > 50)
              .map((e) => e.item2)
              .toList() ??
          [];
    }, [albumsQuery.data, searchText.value]);

    if (auth == null) {
      return const AnonymousFallback();
    }
    if (albumsQuery.isLoading || !albumsQuery.hasData) {
      return const Center(child: ShimmerPlaybuttonCard(count: 7));
    }

    return RefreshIndicator(
      onRefresh: () async {
        await albumsQuery.refetch();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Material(
          type: MaterialType.transparency,
          textStyle: PlatformTheme.of(context).textTheme!.body!,
          color: PlatformTheme.of(context).scaffoldBackgroundColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                PlatformTextField(
                  onChanged: (value) => searchText.value = value,
                  prefixIcon: SpotubeIcons.filter,
                  placeholder: 'Filter Albums...',
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: spacing, // gap between adjacent chips
                  runSpacing: 20, // gap between lines
                  alignment: WrapAlignment.center,
                  children: albums
                      .map((album) => AlbumCard(
                            viewType: viewType,
                            TypeConversionUtils.simpleAlbum_X_Album(album),
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
