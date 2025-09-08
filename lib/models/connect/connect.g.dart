// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connect.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WebSocketLoadEventDataPlaylistImpl
    _$$WebSocketLoadEventDataPlaylistImplFromJson(Map json) =>
        _$WebSocketLoadEventDataPlaylistImpl(
          tracks: (json['tracks'] as List<dynamic>)
              .map((e) => Track.fromJson(Map<String, dynamic>.from(e as Map)))
              .toList(),
          collection: json['collection'] == null
              ? null
              : PlaylistSimple.fromJson(
                  Map<String, dynamic>.from(json['collection'] as Map)),
          initialIndex: (json['initialIndex'] as num?)?.toInt(),
          $type: json['runtimeType'] as String?,
        );

Map<String, dynamic> _$$WebSocketLoadEventDataPlaylistImplToJson(
        _$WebSocketLoadEventDataPlaylistImpl instance) =>
    <String, dynamic>{
      'tracks': _tracksJson(instance.tracks),
      'collection': instance.collection?.toJson(),
      'initialIndex': instance.initialIndex,
      'runtimeType': instance.$type,
    };

_$WebSocketLoadEventDataAlbumImpl _$$WebSocketLoadEventDataAlbumImplFromJson(
        Map json) =>
    _$WebSocketLoadEventDataAlbumImpl(
      tracks: (json['tracks'] as List<dynamic>)
          .map((e) => Track.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      collection: json['collection'] == null
          ? null
          : AlbumSimple.fromJson(
              Map<String, dynamic>.from(json['collection'] as Map)),
      initialIndex: (json['initialIndex'] as num?)?.toInt(),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$WebSocketLoadEventDataAlbumImplToJson(
        _$WebSocketLoadEventDataAlbumImpl instance) =>
    <String, dynamic>{
      'tracks': _tracksJson(instance.tracks),
      'collection': instance.collection?.toJson(),
      'initialIndex': instance.initialIndex,
      'runtimeType': instance.$type,
    };
