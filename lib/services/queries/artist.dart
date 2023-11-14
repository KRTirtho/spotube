import 'package:fl_query/fl_query.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/hooks/spotify/use_spotify_infinite_query.dart';
import 'package:spotube/hooks/spotify/use_spotify_query.dart';

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
        final result = await spotify.me.isFollowing(
          FollowingType.artist,
          [artist],
        );
        return result.first;
      },
      ref: ref,
    );
  }

  Query<Iterable<Track>, dynamic> topTracksOf(
    WidgetRef ref,
    String artist,
  ) {
    return useSpotifyQuery<Iterable<Track>, dynamic>(
      "artist-top-track-query/$artist",
      (spotify) {
        return spotify.artists.getTopTracks(artist, "US");
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
        return spotify.artists.getRelatedArtists(artist);
      },
      ref: ref,
    );
  }
}
