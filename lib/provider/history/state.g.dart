// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlaybackHistoryPlaylistImpl _$$PlaybackHistoryPlaylistImplFromJson(
        Map json) =>
    _$PlaybackHistoryPlaylistImpl(
      date: DateTime.parse(json['date'] as String),
      playlist: PlaylistSimple.fromJson(
          Map<String, dynamic>.from(json['playlist'] as Map)),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$PlaybackHistoryPlaylistImplToJson(
        _$PlaybackHistoryPlaylistImpl instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'playlist': instance.playlist.toJson(),
      'runtimeType': instance.$type,
    };

_$PlaybackHistoryAlbumImpl _$$PlaybackHistoryAlbumImplFromJson(Map json) =>
    _$PlaybackHistoryAlbumImpl(
      date: DateTime.parse(json['date'] as String),
      album:
          AlbumSimple.fromJson(Map<String, dynamic>.from(json['album'] as Map)),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$PlaybackHistoryAlbumImplToJson(
        _$PlaybackHistoryAlbumImpl instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'album': instance.album.toJson(),
      'runtimeType': instance.$type,
    };

_$PlaybackHistoryTrackImpl _$$PlaybackHistoryTrackImplFromJson(Map json) =>
    _$PlaybackHistoryTrackImpl(
      date: DateTime.parse(json['date'] as String),
      track: Track.fromJson(Map<String, dynamic>.from(json['track'] as Map)),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$PlaybackHistoryTrackImplToJson(
        _$PlaybackHistoryTrackImpl instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'track': instance.track.toJson(),
      'runtimeType': instance.$type,
    };
