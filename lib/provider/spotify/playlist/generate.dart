part of '../spotify.dart';

final generatePlaylistProvider = FutureProvider.autoDispose
    .family<List<Track>, GeneratePlaylistProviderInput>(
  (ref, input) async {
    final spotify = ref.watch(spotifyProvider);
    final market = ref.watch(
      userPreferencesProvider.select((s) => s.market),
    );

    final recommendation = await spotify.recommendations
        .get(
      limit: input.limit,
      seedArtists: input.seedArtists?.toList(),
      seedGenres: input.seedGenres?.toList(),
      seedTracks: input.seedTracks?.toList(),
      market: market,
      max: (input.max?.toJson()?..removeWhere((key, value) => value == null))
          ?.cast<String, num>(),
      min: (input.min?.toJson()?..removeWhere((key, value) => value == null))
          ?.cast<String, num>(),
      target: (input.target?.toJson()
            ?..removeWhere((key, value) => value == null))
          ?.cast<String, num>(),
    )
        .catchError((e, stackTrace) {
      AppLogger.reportError(e, stackTrace);
      return Recommendations();
    });

    if (recommendation.tracks?.isEmpty ?? true) {
      return [];
    }

    final tracks = await spotify.tracks
        .list(recommendation.tracks!.map((e) => e.id!).toList());

    return tracks.toList();
  },
);
