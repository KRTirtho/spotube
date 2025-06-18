// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'source_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SourceInfo _$SourceInfoFromJson(Map json) => SourceInfo(
      id: json['id'] as String,
      title: json['title'] as String,
      artist: json['artist'] as String,
      thumbnail: json['thumbnail'] as String,
      pageUrl: json['pageUrl'] as String,
      duration: Duration(microseconds: (json['duration'] as num).toInt()),
      artistUrl: json['artistUrl'] as String,
      album: json['album'] as String?,
    );

Map<String, dynamic> _$SourceInfoToJson(SourceInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'artist': instance.artist,
      'artistUrl': instance.artistUrl,
      'album': instance.album,
      'thumbnail': instance.thumbnail,
      'pageUrl': instance.pageUrl,
      'duration': instance.duration.inMicroseconds,
    };
