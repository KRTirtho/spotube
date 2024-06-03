// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommendation_seeds.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RecommendationSeedsImpl _$$RecommendationSeedsImplFromJson(Map json) =>
    _$RecommendationSeedsImpl(
      acousticness: json['acousticness'] as num?,
      danceability: json['danceability'] as num?,
      durationMs: json['duration_ms'] as num?,
      energy: json['energy'] as num?,
      instrumentalness: json['instrumentalness'] as num?,
      key: json['key'] as num?,
      liveness: json['liveness'] as num?,
      loudness: json['loudness'] as num?,
      mode: json['mode'] as num?,
      popularity: json['popularity'] as num?,
      speechiness: json['speechiness'] as num?,
      tempo: json['tempo'] as num?,
      timeSignature: json['time_signature'] as num?,
      valence: json['valence'] as num?,
    );

Map<String, dynamic> _$$RecommendationSeedsImplToJson(
        _$RecommendationSeedsImpl instance) =>
    <String, dynamic>{
      'acousticness': instance.acousticness,
      'danceability': instance.danceability,
      'duration_ms': instance.durationMs,
      'energy': instance.energy,
      'instrumentalness': instance.instrumentalness,
      'key': instance.key,
      'liveness': instance.liveness,
      'loudness': instance.loudness,
      'mode': instance.mode,
      'popularity': instance.popularity,
      'speechiness': instance.speechiness,
      'tempo': instance.tempo,
      'time_signature': instance.timeSignature,
      'valence': instance.valence,
    };
