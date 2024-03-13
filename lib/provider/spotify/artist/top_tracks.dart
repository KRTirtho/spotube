part of '../spotify.dart';

final artistTopTracksProvider = FutureProviderFamily<List<TrackSimple>, String>(
  (ref, artistId) async {
    final spotify = ref.watch(spotifyProvider);
    final market = ref
        .watch(userPreferencesProvider.select((s) => s.recommendationMarket));
    final tracks = await spotify.artists.topTracks(artistId, market);

    return tracks.toList();
  },
);
