import 'package:catcher_2/catcher_2.dart';
import 'package:fl_query/fl_query.dart';
import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/hooks/spotify/use_spotify_infinite_query.dart';
import 'package:spotube/hooks/spotify/use_spotify_query.dart';
import 'package:spotube/provider/spotify_provider.dart';
import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';
import 'package:spotube/utils/type_conversion_utils.dart';

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

  static final tracksOfJob = InfiniteQueryJob.withVariableKey<
      List<Track>,
      dynamic,
      int,
      ({
        SpotifyApi spotify,
        AlbumSimple album,
      })>(
    baseQueryKey: "album-tracks",
    initialPage: 0,
    task: (albumId, page, args) async {
      final res =
          await args!.spotify.albums.tracks(albumId).getPage(20, page * 20);
      return res.items
              ?.map((track) =>
                  TypeConversionUtils.simpleTrack_X_Track(track, args.album))
              .toList() ??
          <Track>[];
    },
    nextPage: (lastPage, lastPageData) {
      if (lastPageData.length < 20) {
        return null;
      }
      return lastPage + 1;
    },
  );

  InfiniteQuery<List<Track>, dynamic, int> tracksOf(
    WidgetRef ref,
    AlbumSimple album,
  ) {
    final spotify = ref.watch(spotifyProvider);

    return useInfiniteQueryJob(
      job: tracksOfJob(album.id!),
      args: (spotify: spotify, album: album),
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
          Catcher2.reportCheckedError(e, stack);
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
