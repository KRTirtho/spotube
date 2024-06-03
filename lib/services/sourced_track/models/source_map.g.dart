// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'source_map.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SourceQualityMap _$SourceQualityMapFromJson(Map json) => SourceQualityMap(
      high: json['high'] as String,
      medium: json['medium'] as String,
      low: json['low'] as String,
    );

Map<String, dynamic> _$SourceQualityMapToJson(SourceQualityMap instance) =>
    <String, dynamic>{
      'high': instance.high,
      'medium': instance.medium,
      'low': instance.low,
    };

SourceMap _$SourceMapFromJson(Map json) => SourceMap(
      weba: json['weba'] == null
          ? null
          : SourceQualityMap.fromJson(
              Map<String, dynamic>.from(json['weba'] as Map)),
      m4a: json['m4a'] == null
          ? null
          : SourceQualityMap.fromJson(
              Map<String, dynamic>.from(json['m4a'] as Map)),
    );

Map<String, dynamic> _$SourceMapToJson(SourceMap instance) => <String, dynamic>{
      'weba': instance.weba?.toJson(),
      'm4a': instance.m4a?.toJson(),
    };
