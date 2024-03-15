// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommendation_seeds.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RecommendationSeedsImpl _$$RecommendationSeedsImplFromJson(
        Map<String, dynamic> json) =>
    _$RecommendationSeedsImpl(
      json['acousticness'] as num?,
      json['danceability'] as num?,
      json['duration_ms'] as num?,
      json['energy'] as num?,
      json['instrumentalness'] as num?,
      json['key'] as num?,
      json['liveness'] as num?,
      json['loudness'] as num?,
      json['mode'] as num?,
      json['popularity'] as num?,
      json['speechiness'] as num?,
      json['tempo'] as num?,
      json['time_signature'] as num?,
      json['valence'] as num?,
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
