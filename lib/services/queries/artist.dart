import 'package:fl_query/fl_query.dart';
import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/hooks/spotify/use_spotify_infinite_query.dart';
import 'package:spotube/hooks/spotify/use_spotify_query.dart';
import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';
import 'package:spotube/services/wikipedia/wikipedia.dart';
import 'package:wikipedia_api/wikipedia_api.dart';

class ArtistQueries {
  const ArtistQueries();

  Query<Artist, dynamic> get(
    WidgetRef ref,
    String artist,
  ) {
    return useSpotifyQuery<Artist, dynamic>(
      "artist-profile/$artist",
      (spotify) => spotify.artists.get(artist),
      ref: ref,
    );
  }

  InfiniteQuery<CursorPage<Artist>, dynamic, String> followedByMe(
      WidgetRef ref) {
    return useSpotifyInfiniteQuery<CursorPage<Artist>, dynamic, String>(
      "user-following-artists",
      (pageParam, spotify) async {
        return spotify.me
            .following(FollowingType.artist)
            .getPage(15, pageParam);
      },
      initialPage: "",
      nextPage: (lastPage, lastPageData) {
        if (lastPageData.isLast || (lastPageData.items ?? []).length < 15) {
          return null;
        }
        return lastPageData.after;
      },
      ref: ref,
    );
  }

  Query<List<Artist>, dynamic> followedByMeAll(WidgetRef ref) {
    return useSpotifyQuery(
      "user-following-artists-all",
      (spotify) async {
        CursorPage<Artist>? page =
            await spotify.me.following(FollowingType.artist).getPage(50);

        final following = <Artist>[];

        if (page.isLast == true) {
          return page.items?.toList() ?? [];
        }

        following.addAll(page.items ?? []);
        while (page?.isLast != true) {
          page = await spotify.me
              .following(FollowingType.artist)
              .getPage(50, page?.after ?? '');
          following.addAll(page.items ?? []);
        }

        return following;
      },
      ref: ref,
    );
  }

  Query<bool, dynamic> doIFollow(
    WidgetRef ref,
    String artist,
  ) {
    return useSpotifyQuery<bool, dynamic>(
      "user-follows-artists-query/$artist",
      (spotify) async {
        final result = await spotify.me.checkFollowing(
          FollowingType.artist,
          [artist],
        );
        return result[artist];
      },
      ref: ref,
    );
  }

  Query<Iterable<Track>, dynamic> topTracksOf(
    WidgetRef ref,
    String artist,
  ) {
    final preferences = ref.watch(userPreferencesProvider);
    return useSpotifyQuery<Iterable<Track>, dynamic>(
      "artist-top-track-query/$artist",
      (spotify) {
        return spotify.artists
            .topTracks(artist, preferences.recommendationMarket);
      },
      ref: ref,
    );
  }

  InfiniteQuery<Page<Album>, dynamic, int> albumsOf(
    WidgetRef ref,
    String artist,
  ) {
    return useSpotifyInfiniteQuery<Page<Album>, dynamic, int>(
      "artist-albums/$artist",
      (pageParam, spotify) async {
        return spotify.artists.albums(artist).getPage(5, pageParam);
      },
      initialPage: 0,
      nextPage: (lastPage, lastPageData) {
        if (lastPageData.isLast || (lastPageData.items ?? []).length < 5) {
          return null;
        }
        return lastPageData.nextOffset;
      },
      ref: ref,
    );
  }

  Query<Iterable<Artist>, dynamic> relatedArtistsOf(
    WidgetRef ref,
    String artist,
  ) {
    return useSpotifyQuery<Iterable<Artist>, dynamic>(
      "artist-related-artist-query/$artist",
      (spotify) {
        return spotify.artists.relatedArtists(artist);
      },
      ref: ref,
    );
  }

  Query<Summary?, dynamic> wikipediaSummary(ArtistSimple artist) {
    return useQuery<Summary?, dynamic>(
      "artist-wikipedia-query/${artist.id}",
      () async {
        final query = artist.name!.replaceAll(" ", "_");
        final res = await wikipedia.pageContent.pageSummaryTitleGet(query);
        if (res?.type != "standard") {
          return await wikipedia.pageContent
              .pageSummaryTitleGet("${query}_(singer)");
        }
        return res;
      },
    );
  }
}
