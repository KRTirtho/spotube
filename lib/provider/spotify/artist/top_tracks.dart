part of '../spotify.dart';

final artistTopTracksProvider =
    FutureProvider.autoDispose.family<List<Track>, String>(
  (ref, artistId) async {
    ref.cacheFor();

    final spotify = ref.watch(spotifyProvider);
    final market = ref.watch(userPreferencesProvider.select((s) => s.market));
    final tracks = await spotify.artists.topTracks(artistId, market);

    return tracks.toList();
  },
);
