import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotube/provider/SpotifyDI.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/provider/UserPreferences.dart';

final categoriesQuery = FutureProvider.family<Page<Category>, int>(
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
