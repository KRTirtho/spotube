// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_feed.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SpotifySectionPlaylistImpl _$$SpotifySectionPlaylistImplFromJson(Map json) =>
    _$SpotifySectionPlaylistImpl(
      description: json['description'] as String,
      format: json['format'] as String,
      images: (json['images'] as List<dynamic>)
          .map((e) => SpotifySectionItemImage.fromJson(
              Map<String, dynamic>.from(e as Map)))
          .toList(),
      name: json['name'] as String,
      owner: json['owner'] as String,
      uri: json['uri'] as String,
    );

Map<String, dynamic> _$$SpotifySectionPlaylistImplToJson(
        _$SpotifySectionPlaylistImpl instance) =>
    <String, dynamic>{
      'description': instance.description,
      'format': instance.format,
      'images': instance.images.map((e) => e.toJson()).toList(),
      'name': instance.name,
      'owner': instance.owner,
      'uri': instance.uri,
    };

_$SpotifySectionArtistImpl _$$SpotifySectionArtistImplFromJson(Map json) =>
    _$SpotifySectionArtistImpl(
      name: json['name'] as String,
      uri: json['uri'] as String,
      images: (json['images'] as List<dynamic>)
          .map((e) => SpotifySectionItemImage.fromJson(
              Map<String, dynamic>.from(e as Map)))
          .toList(),
    );

Map<String, dynamic> _$$SpotifySectionArtistImplToJson(
        _$SpotifySectionArtistImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'uri': instance.uri,
      'images': instance.images.map((e) => e.toJson()).toList(),
    };

_$SpotifySectionAlbumImpl _$$SpotifySectionAlbumImplFromJson(Map json) =>
    _$SpotifySectionAlbumImpl(
      artists: (json['artists'] as List<dynamic>)
          .map((e) => SpotifySectionAlbumArtist.fromJson(
              Map<String, dynamic>.from(e as Map)))
          .toList(),
      images: (json['images'] as List<dynamic>)
          .map((e) => SpotifySectionItemImage.fromJson(
              Map<String, dynamic>.from(e as Map)))
          .toList(),
      name: json['name'] as String,
      uri: json['uri'] as String,
    );

Map<String, dynamic> _$$SpotifySectionAlbumImplToJson(
        _$SpotifySectionAlbumImpl instance) =>
    <String, dynamic>{
      'artists': instance.artists.map((e) => e.toJson()).toList(),
      'images': instance.images.map((e) => e.toJson()).toList(),
      'name': instance.name,
      'uri': instance.uri,
    };

_$SpotifySectionAlbumArtistImpl _$$SpotifySectionAlbumArtistImplFromJson(
        Map json) =>
    _$SpotifySectionAlbumArtistImpl(
      name: json['name'] as String,
      uri: json['uri'] as String,
    );

Map<String, dynamic> _$$SpotifySectionAlbumArtistImplToJson(
        _$SpotifySectionAlbumArtistImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'uri': instance.uri,
    };

_$SpotifySectionItemImageImpl _$$SpotifySectionItemImageImplFromJson(
        Map json) =>
    _$SpotifySectionItemImageImpl(
      height: json['height'] as num?,
      url: json['url'] as String,
      width: json['width'] as num?,
    );

Map<String, dynamic> _$$SpotifySectionItemImageImplToJson(
        _$SpotifySectionItemImageImpl instance) =>
    <String, dynamic>{
      'height': instance.height,
      'url': instance.url,
      'width': instance.width,
    };

_$SpotifyHomeFeedSectionItemImpl _$$SpotifyHomeFeedSectionItemImplFromJson(
        Map json) =>
    _$SpotifyHomeFeedSectionItemImpl(
      typename: json['typename'] as String,
      playlist: json['playlist'] == null
          ? null
          : SpotifySectionPlaylist.fromJson(
              Map<String, dynamic>.from(json['playlist'] as Map)),
      artist: json['artist'] == null
          ? null
          : SpotifySectionArtist.fromJson(
              Map<String, dynamic>.from(json['artist'] as Map)),
      album: json['album'] == null
          ? null
          : SpotifySectionAlbum.fromJson(
              Map<String, dynamic>.from(json['album'] as Map)),
    );

Map<String, dynamic> _$$SpotifyHomeFeedSectionItemImplToJson(
        _$SpotifyHomeFeedSectionItemImpl instance) =>
    <String, dynamic>{
      'typename': instance.typename,
      'playlist': instance.playlist?.toJson(),
      'artist': instance.artist?.toJson(),
      'album': instance.album?.toJson(),
    };

_$SpotifyHomeFeedSectionImpl _$$SpotifyHomeFeedSectionImplFromJson(Map json) =>
    _$SpotifyHomeFeedSectionImpl(
      typename: json['typename'] as String,
      title: json['title'] as String?,
      uri: json['uri'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => SpotifyHomeFeedSectionItem.fromJson(
              Map<String, dynamic>.from(e as Map)))
          .toList(),
    );

Map<String, dynamic> _$$SpotifyHomeFeedSectionImplToJson(
        _$SpotifyHomeFeedSectionImpl instance) =>
    <String, dynamic>{
      'typename': instance.typename,
      'title': instance.title,
      'uri': instance.uri,
      'items': instance.items.map((e) => e.toJson()).toList(),
    };

_$SpotifyHomeFeedImpl _$$SpotifyHomeFeedImplFromJson(Map json) =>
    _$SpotifyHomeFeedImpl(
      greeting: json['greeting'] as String,
      sections: (json['sections'] as List<dynamic>)
          .map((e) => SpotifyHomeFeedSection.fromJson(
              Map<String, dynamic>.from(e as Map)))
          .toList(),
    );

Map<String, dynamic> _$$SpotifyHomeFeedImplToJson(
        _$SpotifyHomeFeedImpl instance) =>
    <String, dynamic>{
      'greeting': instance.greeting,
      'sections': instance.sections.map((e) => e.toJson()).toList(),
    };
