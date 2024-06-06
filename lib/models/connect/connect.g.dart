// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connect.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WebSocketLoadEventDataImpl _$$WebSocketLoadEventDataImplFromJson(
        Map<String, dynamic> json) =>
    _$WebSocketLoadEventDataImpl(
      tracks: (json['tracks'] as List<dynamic>)
          .map((e) => Track.fromJson(e as Map<String, dynamic>))
          .toList(),
      collectionId: json['collectionId'] as String?,
      initialIndex: json['initialIndex'] as int?,
    );

Map<String, dynamic> _$$WebSocketLoadEventDataImplToJson(
        _$WebSocketLoadEventDataImpl instance) =>
    <String, dynamic>{
      'tracks': _tracksJson(instance.tracks),
      'collectionId': instance.collectionId,
      'initialIndex': instance.initialIndex,
    };
