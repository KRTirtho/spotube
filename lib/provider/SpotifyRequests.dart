import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotube/provider/SpotifyDI.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/provider/UserPreferences.dart';

final categoriesQuery = FutureProvider.autoDispose.family<Page<Category>, int>(
  (ref, pageKey) {
    final spotify = ref.watch(spotifyProvider);
    final recommendationMarket = ref.watch(
      userPreferencesProvider.select((s) => s.recommendationMarket),
    );
    return spotify.categories
        .list(country: recommendationMarket)
        .getPage(15, pageKey);
  },
);

final categoryPlaylistsQuery =
    FutureProvider.autoDispose.family<Page<PlaylistSimple>, String>(
  (ref, value) {
    final spotify = ref.watch(spotifyProvider);
    final List data = value.split("/");
    final id = data.first;
    final pageKey = data.last;
    return (id != "user-featured-playlists"
            ? spotify.playlists.getByCategoryId(id)
            : spotify.playlists.featured)
        .getPage(3, int.parse(pageKey));
  },
);

final currentUserPlaylistsQuery = FutureProvider<Iterable<PlaylistSimple>>(
  (ref) {
    final spotify = ref.watch(spotifyProvider);
    return spotify.playlists.me.all();
  },
);

final currentUserAlbumsQuery = FutureProvider<Iterable<AlbumSimple>>(
  (ref) {
    final spotify = ref.watch(spotifyProvider);
    return spotify.me.savedAlbums().all();
  },
);

final currentUserFollowingArtistsQuery =
    FutureProvider.autoDispose.family<CursorPage<Artist>, String>(
  (ref, pageKey) {
    final spotify = ref.watch(spotifyProvider);
    return spotify.me.following(FollowingType.artist).getPage(15, pageKey);
  },
);

final artistProfileQuery = FutureProvider.autoDispose.family<Artist, String>(
  (ref, id) {
    final spotify = ref.watch(spotifyProvider);
    return spotify.artists.get(id);
  },
);

final currentUserFollowsArtistQuery =
    FutureProvider.autoDispose.family<bool, String>(
  (ref, artistId) async {
    final spotify = ref.watch(spotifyProvider);
    final result = await spotify.me.isFollowing(
      FollowingType.artist,
      [artistId],
    );
    return result.first;
  },
);

final artistTopTracksQuery =
    FutureProvider.autoDispose.family<Iterable<Track>, String>((ref, id) {
  final spotify = ref.watch(spotifyProvider);
  return spotify.artists.getTopTracks(id, "US");
});

final artistAlbumsQuery =
    FutureProvider.autoDispose.family<Page<Album>, String>(
  (ref, id) {
    final spotify = ref.watch(spotifyProvider);
    return spotify.artists.albums(id).getPage(5, 0);
  },
);

final artistRelatedArtistsQuery =
    FutureProvider.autoDispose.family<Iterable<Artist>, String>(
  (ref, id) {
    final spotify = ref.watch(spotifyProvider);
    return spotify.artists.getRelatedArtists(id);
  },
);
