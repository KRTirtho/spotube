// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'metadata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SpotubeAlbumObjectImpl _$$SpotubeAlbumObjectImplFromJson(Map json) =>
    _$SpotubeAlbumObjectImpl(
      uid: json['uid'] as String,
      title: json['title'] as String,
      artist: SpotubeArtistObject.fromJson(
          Map<String, dynamic>.from(json['artist'] as Map)),
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => SpotubeImageObject.fromJson(
                  Map<String, dynamic>.from(e as Map)))
              .toList() ??
          const [],
      releaseDate: json['releaseDate'] as String,
      externalUrl: json['externalUrl'] as String,
      type: $enumDecode(_$SpotubeAlbumTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$$SpotubeAlbumObjectImplToJson(
        _$SpotubeAlbumObjectImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'title': instance.title,
      'artist': instance.artist.toJson(),
      'images': instance.images.map((e) => e.toJson()).toList(),
      'releaseDate': instance.releaseDate,
      'externalUrl': instance.externalUrl,
      'type': _$SpotubeAlbumTypeEnumMap[instance.type]!,
    };

const _$SpotubeAlbumTypeEnumMap = {
  SpotubeAlbumType.album: 'album',
  SpotubeAlbumType.single: 'single',
};

_$SpotubeArtistObjectImpl _$$SpotubeArtistObjectImplFromJson(Map json) =>
    _$SpotubeArtistObjectImpl(
      uid: json['uid'] as String,
      name: json['name'] as String,
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => SpotubeImageObject.fromJson(
                  Map<String, dynamic>.from(e as Map)))
              .toList() ??
          const [],
      externalUrl: json['externalUrl'] as String,
    );

Map<String, dynamic> _$$SpotubeArtistObjectImplToJson(
        _$SpotubeArtistObjectImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'images': instance.images.map((e) => e.toJson()).toList(),
      'externalUrl': instance.externalUrl,
    };

_$SpotubeImageObjectImpl _$$SpotubeImageObjectImplFromJson(Map json) =>
    _$SpotubeImageObjectImpl(
      url: json['url'] as String,
      width: (json['width'] as num).toInt(),
      height: (json['height'] as num).toInt(),
    );

Map<String, dynamic> _$$SpotubeImageObjectImplToJson(
        _$SpotubeImageObjectImpl instance) =>
    <String, dynamic>{
      'url': instance.url,
      'width': instance.width,
      'height': instance.height,
    };

_$SpotubePlaylistObjectImpl _$$SpotubePlaylistObjectImplFromJson(Map json) =>
    _$SpotubePlaylistObjectImpl(
      uid: json['uid'] as String,
      name: json['name'] as String,
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => SpotubeImageObject.fromJson(
                  Map<String, dynamic>.from(e as Map)))
              .toList() ??
          const [],
      description: json['description'] as String,
      externalUrl: json['externalUrl'] as String,
      owner: SpotubeUserObject.fromJson(
          Map<String, dynamic>.from(json['owner'] as Map)),
      collaborators: (json['collaborators'] as List<dynamic>?)
              ?.map((e) => SpotubeUserObject.fromJson(
                  Map<String, dynamic>.from(e as Map)))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$SpotubePlaylistObjectImplToJson(
        _$SpotubePlaylistObjectImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'images': instance.images.map((e) => e.toJson()).toList(),
      'description': instance.description,
      'externalUrl': instance.externalUrl,
      'owner': instance.owner.toJson(),
      'collaborators': instance.collaborators.map((e) => e.toJson()).toList(),
    };

_$SpotubeSearchResponseObjectImpl _$$SpotubeSearchResponseObjectImplFromJson(
        Map json) =>
    _$SpotubeSearchResponseObjectImpl(
      tracks: (json['tracks'] as List<dynamic>?)
              ?.map((e) => SpotubeTrackObject.fromJson(
                  Map<String, dynamic>.from(e as Map)))
              .toList() ??
          const [],
      albums: (json['albums'] as List<dynamic>?)
              ?.map((e) => SpotubeAlbumObject.fromJson(
                  Map<String, dynamic>.from(e as Map)))
              .toList() ??
          const [],
      artists: (json['artists'] as List<dynamic>?)
              ?.map((e) => SpotubeArtistObject.fromJson(
                  Map<String, dynamic>.from(e as Map)))
              .toList() ??
          const [],
      playlists: (json['playlists'] as List<dynamic>?)
              ?.map((e) => SpotubePlaylistObject.fromJson(
                  Map<String, dynamic>.from(e as Map)))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$SpotubeSearchResponseObjectImplToJson(
        _$SpotubeSearchResponseObjectImpl instance) =>
    <String, dynamic>{
      'tracks': instance.tracks.map((e) => e.toJson()).toList(),
      'albums': instance.albums.map((e) => e.toJson()).toList(),
      'artists': instance.artists.map((e) => e.toJson()).toList(),
      'playlists': instance.playlists.map((e) => e.toJson()).toList(),
    };

_$SpotubeTrackObjectImpl _$$SpotubeTrackObjectImplFromJson(Map json) =>
    _$SpotubeTrackObjectImpl(
      uid: json['uid'] as String,
      title: json['title'] as String,
      artists: (json['artists'] as List<dynamic>?)
              ?.map((e) => SpotubeArtistObject.fromJson(
                  Map<String, dynamic>.from(e as Map)))
              .toList() ??
          const [],
      album: SpotubeAlbumObject.fromJson(
          Map<String, dynamic>.from(json['album'] as Map)),
      durationMs: (json['durationMs'] as num).toInt(),
      isrc: json['isrc'] as String,
      externalUrl: json['externalUrl'] as String,
    );

Map<String, dynamic> _$$SpotubeTrackObjectImplToJson(
        _$SpotubeTrackObjectImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'title': instance.title,
      'artists': instance.artists.map((e) => e.toJson()).toList(),
      'album': instance.album.toJson(),
      'durationMs': instance.durationMs,
      'isrc': instance.isrc,
      'externalUrl': instance.externalUrl,
    };

_$SpotubeUserObjectImpl _$$SpotubeUserObjectImplFromJson(Map json) =>
    _$SpotubeUserObjectImpl(
      uid: json['uid'] as String,
      name: json['name'] as String,
      avatars: (json['avatars'] as List<dynamic>?)
              ?.map((e) => SpotubeImageObject.fromJson(
                  Map<String, dynamic>.from(e as Map)))
              .toList() ??
          const [],
      externalUrl: json['externalUrl'] as String,
      displayName: json['displayName'] as String,
    );

Map<String, dynamic> _$$SpotubeUserObjectImplToJson(
        _$SpotubeUserObjectImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'avatars': instance.avatars.map((e) => e.toJson()).toList(),
      'externalUrl': instance.externalUrl,
      'displayName': instance.displayName,
    };
