import 'package:freezed_annotation/freezed_annotation.dart';

part 'recommendation_seeds.freezed.dart';
part 'recommendation_seeds.g.dart';

@freezed
class GeneratePlaylistProviderInput with _$GeneratePlaylistProviderInput {
  factory GeneratePlaylistProviderInput({
    Iterable<String>? seedArtists,
    Iterable<String>? seedGenres,
    Iterable<String>? seedTracks,
    required int limit,
    RecommendationSeeds? max,
    RecommendationSeeds? min,
    RecommendationSeeds? target,
  }) = _GeneratePlaylistProviderInput;
}

@freezed
class RecommendationSeeds with _$RecommendationSeeds {
  factory RecommendationSeeds({
    num? not_acoustic,
    num? dance_ability,
    @JsonKey(name: "duration_ms") num? durationMs,
    num? energy,
    num? not_instrumental,
    num? key,
    num? liveness,
    num? loudness,
    num? mode,
    num? popularity,
    num? talkative,
    num? tempo,
    @JsonKey(name: "time_signature") num? timeSignature,
    num? valence,
  }) = _RecommendationSeeds;

  factory RecommendationSeeds.fromJson(Map<String, dynamic> json) =>
      _$RecommendationSeedsFromJson(json);
}
