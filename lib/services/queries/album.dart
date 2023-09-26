import 'package:catcher/catcher.dart';
import 'package:fl_query/fl_query.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/hooks/use_spotify_infinite_query.dart';
import 'package:spotube/hooks/use_spotify_query.dart';
import 'package:spotube/provider/user_preferences_provider.dart';

class AlbumQueries {
  const AlbumQueries();

  InfiniteQuery<Page<AlbumSimple>, dynamic, int> ofMine(WidgetRef ref) {
    return useSpotifyInfiniteQuery<Page<AlbumSimple>, dynamic, int>(
      "current-user-albums",
      (page, spotify) {
        return spotify.me.savedAlbums().getPage(
              20,
              page * 20,
            );
      },
      initialPage: 0,
      nextPage: (lastPage, lastPageData) =>
          (lastPageData.items?.length ?? 0) < 20 || lastPageData.isLast
              ? null
              : lastPage + 1,
      ref: ref,
    );
  }

  Query<List<TrackSimple>, dynamic> tracksOf(
    WidgetRef ref,
    String albumId,
  ) {
    return useSpotifyQuery<List<TrackSimple>, dynamic>(
      "album-tracks/$albumId",
      (spotify) {
        return spotify.albums
            .getTracks(albumId)
            .all()
            .then((value) => value.toList());
      },
      ref: ref,
    );
  }

  Query<bool, dynamic> isSavedForMe(
    WidgetRef ref,
    String album,
  ) {
    return useSpotifyQuery<bool, dynamic>(
      "is-saved-for-me/$album",
      (spotify) {
        return spotify.me
            .containsSavedAlbums([album]).then((value) => value[album]);
      },
      ref: ref,
    );
  }

  InfiniteQuery<Page<AlbumSimple>, dynamic, int> newReleases(WidgetRef ref) {
    final market = ref
        .watch(userPreferencesProvider.select((s) => s.recommendationMarket));

    return useSpotifyInfiniteQuery<Page<AlbumSimple>, dynamic, int>(
      "new-releases",
      (pageParam, spotify) async {
        try {
          final albums = await spotify.browse
              .newReleases(country: market)
              .getPage(50, pageParam);

          return albums;
        } catch (e, stack) {
          Catcher.reportCheckedError(e, stack);
          rethrow;
        }
      },
      ref: ref,
      initialPage: 0,
      nextPage: (lastPage, lastPageData) {
        if (lastPageData.isLast) {
          return null;
        }
        return lastPageData.nextOffset;
      },
    );
  }
}
