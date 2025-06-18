// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track_sources.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BasicSourcedTrack _$BasicSourcedTrackFromJson(Map json) => BasicSourcedTrack(
      query: TrackSourceQuery.fromJson(
          Map<String, dynamic>.from(json['query'] as Map)),
      source: $enumDecode(_$AudioSourceEnumMap, json['source']),
      info: TrackSourceInfo.fromJson(
          Map<String, dynamic>.from(json['info'] as Map)),
      sources: (json['sources'] as List<dynamic>)
          .map((e) => TrackSource.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      siblings: (json['siblings'] as List<dynamic>?)
              ?.map((e) =>
                  TrackSourceInfo.fromJson(Map<String, dynamic>.from(e as Map)))
              .toList() ??
          [],
    );

Map<String, dynamic> _$BasicSourcedTrackToJson(BasicSourcedTrack instance) =>
    <String, dynamic>{
      'query': instance.query.toJson(),
      'source': _$AudioSourceEnumMap[instance.source]!,
      'info': instance.info.toJson(),
      'sources': instance.sources.map((e) => e.toJson()).toList(),
      'siblings': instance.siblings.map((e) => e.toJson()).toList(),
    };

const _$AudioSourceEnumMap = {
  AudioSource.youtube: 'youtube',
  AudioSource.piped: 'piped',
  AudioSource.jiosaavn: 'jiosaavn',
  AudioSource.invidious: 'invidious',
};

_$TrackSourceQueryImpl _$$TrackSourceQueryImplFromJson(Map json) =>
    _$TrackSourceQueryImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      artists:
          (json['artists'] as List<dynamic>).map((e) => e as String).toList(),
      album: json['album'] as String,
      durationMs: (json['durationMs'] as num).toInt(),
      isrc: json['isrc'] as String,
      explicit: json['explicit'] as bool,
    );

Map<String, dynamic> _$$TrackSourceQueryImplToJson(
        _$TrackSourceQueryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'artists': instance.artists,
      'album': instance.album,
      'durationMs': instance.durationMs,
      'isrc': instance.isrc,
      'explicit': instance.explicit,
    };

_$TrackSourceInfoImpl _$$TrackSourceInfoImplFromJson(Map json) =>
    _$TrackSourceInfoImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      artists: json['artists'] as String,
      thumbnail: json['thumbnail'] as String,
      pageUrl: json['pageUrl'] as String,
      durationMs: (json['durationMs'] as num).toInt(),
    );

Map<String, dynamic> _$$TrackSourceInfoImplToJson(
        _$TrackSourceInfoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'artists': instance.artists,
      'thumbnail': instance.thumbnail,
      'pageUrl': instance.pageUrl,
      'durationMs': instance.durationMs,
    };

_$TrackSourceImpl _$$TrackSourceImplFromJson(Map json) => _$TrackSourceImpl(
      url: json['url'] as String,
      quality: $enumDecode(_$SourceQualitiesEnumMap, json['quality']),
      codec: $enumDecode(_$SourceCodecsEnumMap, json['codec']),
      bitrate: json['bitrate'] as String,
    );

Map<String, dynamic> _$$TrackSourceImplToJson(_$TrackSourceImpl instance) =>
    <String, dynamic>{
      'url': instance.url,
      'quality': _$SourceQualitiesEnumMap[instance.quality]!,
      'codec': _$SourceCodecsEnumMap[instance.codec]!,
      'bitrate': instance.bitrate,
    };

const _$SourceQualitiesEnumMap = {
  SourceQualities.high: 'high',
  SourceQualities.medium: 'medium',
  SourceQualities.low: 'low',
};

const _$SourceCodecsEnumMap = {
  SourceCodecs.m4a: 'm4a',
  SourceCodecs.weba: 'weba',
};
