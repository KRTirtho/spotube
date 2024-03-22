import 'package:flutter/material.dart' hide Page;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/shared/horizontal_playbutton_card_view/horizontal_playbutton_card_view.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/provider/authentication_provider.dart';
import 'package:spotube/services/queries/queries.dart';
import 'package:spotube/utils/type_conversion_utils.dart';

class HomeNewReleasesSection extends HookConsumerWidget {
  const HomeNewReleasesSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final auth = ref.watch(AuthenticationNotifier.provider);

    final newReleases = useQueries.album.newReleases(ref);
    final userArtistsQuery = useQueries.artist.followedByMeAll(ref);
    final userArtists =
        userArtistsQuery.data?.map((s) => s.id!).toList() ?? const [];

    final albums = useMemoized(
      () {
        final allReleases = newReleases.pages
            .whereType<Page<AlbumSimple>>()
            .expand((page) => page.items ?? const <AlbumSimple>[])
            .map((album) => TypeConversionUtils.simpleAlbum_X_Album(album));

        final userArtistReleases = allReleases.where((album) {
          return album.artists
                  ?.any((artist) => userArtists.contains(artist.id!)) ==
              true;
        }).toList();

        if (userArtistReleases.isEmpty) return allReleases.toList();
        return userArtistReleases;
      },
      [newReleases.pages],
    );

    final hasNewReleases = newReleases.hasPageData &&
        userArtistsQuery.hasData &&
        !newReleases.isLoadingNextPage;

    if (auth == null || !hasNewReleases) return const SizedBox.shrink();

    return HorizontalPlaybuttonCardView<Album>(
      items: albums,
      title: Text(context.l10n.new_releases),
      isLoadingNextPage: newReleases.isLoadingNextPage,
      hasNextPage: newReleases.hasNextPage,
      onFetchMore: newReleases.fetchNext,
    );
  }
}
