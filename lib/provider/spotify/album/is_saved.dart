import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/provider/spotify_provider.dart';

final albumsIsSavedProvider = FutureProvider.autoDispose.family<bool, String>(
  (ref, albumId) async {
    final spotify = ref.watch(spotifyProvider);
    return spotify.me.containsSavedAlbums([albumId]).then(
      (value) => value[albumId] ?? false,
    );
  },
);
