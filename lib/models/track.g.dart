// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BackendTrack _$BackendTrackFromJson(Map<String, dynamic> json) => BackendTrack(
      spotifyId: json['spotify_id'] as String,
      youtubeId: json['youtube_id'] as String,
      votes: json['votes'] as int,
    )
      ..id = json['id'] as String
      ..created = json['created'] as String
      ..updated = json['updated'] as String
      ..collectionId = json['collectionId'] as String
      ..collectionName = json['collectionName'] as String;

Map<String, dynamic> _$BackendTrackToJson(BackendTrack instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created': instance.created,
      'updated': instance.updated,
      'collectionId': instance.collectionId,
      'collectionName': instance.collectionName,
      'spotify_id': instance.spotifyId,
      'youtube_id': instance.youtubeId,
      'votes': instance.votes,
    };
