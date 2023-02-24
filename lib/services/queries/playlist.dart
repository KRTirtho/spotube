import 'package:catcher/catcher.dart';
import 'package:fl_query/fl_query.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/hooks/use_spotify_infinite_query.dart';
import 'package:spotube/hooks/use_spotify_query.dart';

class PlaylistQueries {
  Query<bool, dynamic> useDoesUserFollowQuery(
    WidgetRef ref,
    String playlistId,
    String userId,
  ) {
    return useSpotifyQuery<bool, dynamic>(
      "playlist-is-followed/$playlistId/$userId",
      (spotify) async {
        final result = await spotify.playlists.followedBy(playlistId, [userId]);
        return result.first;
      },
      ref: ref,
    );
  }

  Query<Iterable<PlaylistSimple>, dynamic> useOfMineQuery(WidgetRef ref) {
    return useSpotifyQuery<Iterable<PlaylistSimple>, dynamic>(
      "current-user-playlists",
      (spotify) {
        return spotify.playlists.me.all();
      },
      ref: ref,
    );
  }

  Future<List<Track>> tracksOf(String playlistId, SpotifyApi spotify) {
    if (playlistId == "user-liked-tracks") {
      return spotify.tracks.me.saved.all().then(
            (tracks) => tracks.map((e) => e.track!).toList(),
          );
    }
    return spotify.playlists.getTracksByPlaylistId(playlistId).all().then(
          (value) => value.toList(),
        );
  }

  Query<List<Track>, dynamic> useTracksOfQuery(
    WidgetRef ref,
    String playlistId,
  ) {
    return useSpotifyQuery<List<Track>, dynamic>(
      "playlist-tracks/$playlistId",
      (spotify) => tracksOf(playlistId, spotify),
      ref: ref,
    );
  }

  InfiniteQuery<Page<PlaylistSimple>, dynamic, int> useFeaturedQuery(
    WidgetRef ref,
  ) {
    return useSpotifyInfiniteQuery<Page<PlaylistSimple>, dynamic, int>(
      "featured-playlists",
      (pageParam, spotify) async {
        try {
          final playlists =
              await spotify.playlists.featured.getPage(5, pageParam);
          return playlists;
        } catch (e, stack) {
          Catcher.reportCheckedError(e, stack);
          rethrow;
        }
      },
      initialPage: 0,
      nextPage: (lastPage, pages) =>
          pages.last.isLast || (pages.last.items?.length ?? 0) < 5
              ? null
              : pages.last.nextOffset,
      ref: ref,
    );
  }
}
