part of '../spotify.dart';

typedef GeneratePlaylistProviderInput = ({
  Iterable<String>? seedArtists,
  Iterable<String>? seedGenres,
  Iterable<String>? seedTracks,
  int limit,
  RecommendationSeeds? max,
  RecommendationSeeds? min,
  RecommendationSeeds? target,
});

final generatePlaylistProvider =
    FutureProvider.family<List<TrackSimple>, GeneratePlaylistProviderInput>(
  (ref, input) async {
    final spotify = ref.watch(spotifyProvider);
    final market = ref.watch(
      userPreferencesProvider.select((s) => s.recommendationMarket),
    );

    final recommendation = await spotify.recommendations.get(
      limit: input.limit,
      seedArtists: input.seedArtists?.toList(),
      seedGenres: input.seedGenres?.toList(),
      seedTracks: input.seedTracks?.toList(),
      market: market,
      max: input.max?.toJson().cast<String, num>(),
      min: input.min?.toJson().cast<String, num>(),
      target: input.target?.toJson().cast<String, num>(),
    );

    return recommendation.tracks?.toList() ?? [];
  },
);
