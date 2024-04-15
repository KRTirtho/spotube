// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlaybackHistoryBase _$PlaybackHistoryBaseFromJson(Map<String, dynamic> json) =>
    PlaybackHistoryBase(
      date: DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$PlaybackHistoryBaseToJson(
        PlaybackHistoryBase instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
    };

PlaybackHistoryPlaylist _$PlaybackHistoryPlaylistFromJson(
        Map<String, dynamic> json) =>
    PlaybackHistoryPlaylist(
      date: DateTime.parse(json['date'] as String),
      playlist:
          PlaylistSimple.fromJson(json['playlist'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PlaybackHistoryPlaylistToJson(
        PlaybackHistoryPlaylist instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'playlist': instance.playlist,
    };

PlaybackHistoryAlbum _$PlaybackHistoryAlbumFromJson(
        Map<String, dynamic> json) =>
    PlaybackHistoryAlbum(
      date: DateTime.parse(json['date'] as String),
      album: AlbumSimple.fromJson(json['album'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PlaybackHistoryAlbumToJson(
        PlaybackHistoryAlbum instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'album': instance.album,
    };

PlaybackHistoryTrack _$PlaybackHistoryTrackFromJson(
        Map<String, dynamic> json) =>
    PlaybackHistoryTrack(
      date: DateTime.parse(json['date'] as String),
      track: TrackSimple.fromJson(json['track'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PlaybackHistoryTrackToJson(
        PlaybackHistoryTrack instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'track': instance.track,
    };
