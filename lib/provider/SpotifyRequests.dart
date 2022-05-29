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
