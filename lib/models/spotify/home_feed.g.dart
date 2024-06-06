// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_feed.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SpotifySectionPlaylistImpl _$$SpotifySectionPlaylistImplFromJson(
        Map<String, dynamic> json) =>
    _$SpotifySectionPlaylistImpl(
      description: json['description'] as String,
      format: json['format'] as String,
      images: (json['images'] as List<dynamic>)
          .map((e) =>
              SpotifySectionItemImage.fromJson(e as Map<String, dynamic>))
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
      'images': instance.images,
      'name': instance.name,
      'owner': instance.owner,
      'uri': instance.uri,
    };

_$SpotifySectionArtistImpl _$$SpotifySectionArtistImplFromJson(
        Map<String, dynamic> json) =>
    _$SpotifySectionArtistImpl(
      name: json['name'] as String,
      uri: json['uri'] as String,
      images: (json['images'] as List<dynamic>)
          .map((e) =>
              SpotifySectionItemImage.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$SpotifySectionArtistImplToJson(
        _$SpotifySectionArtistImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'uri': instance.uri,
      'images': instance.images,
    };

_$SpotifySectionAlbumImpl _$$SpotifySectionAlbumImplFromJson(
        Map<String, dynamic> json) =>
    _$SpotifySectionAlbumImpl(
      artists: (json['artists'] as List<dynamic>)
          .map((e) =>
              SpotifySectionAlbumArtist.fromJson(e as Map<String, dynamic>))
          .toList(),
      images: (json['images'] as List<dynamic>)
          .map((e) =>
              SpotifySectionItemImage.fromJson(e as Map<String, dynamic>))
          .toList(),
      name: json['name'] as String,
      uri: json['uri'] as String,
    );

Map<String, dynamic> _$$SpotifySectionAlbumImplToJson(
        _$SpotifySectionAlbumImpl instance) =>
    <String, dynamic>{
      'artists': instance.artists,
      'images': instance.images,
      'name': instance.name,
      'uri': instance.uri,
    };

_$SpotifySectionAlbumArtistImpl _$$SpotifySectionAlbumArtistImplFromJson(
        Map<String, dynamic> json) =>
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
        Map<String, dynamic> json) =>
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
        Map<String, dynamic> json) =>
    _$SpotifyHomeFeedSectionItemImpl(
      typename: json['typename'] as String,
      playlist: json['playlist'] == null
          ? null
          : SpotifySectionPlaylist.fromJson(
              json['playlist'] as Map<String, dynamic>),
      artist: json['artist'] == null
          ? null
          : SpotifySectionArtist.fromJson(
              json['artist'] as Map<String, dynamic>),
      album: json['album'] == null
          ? null
          : SpotifySectionAlbum.fromJson(json['album'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$SpotifyHomeFeedSectionItemImplToJson(
        _$SpotifyHomeFeedSectionItemImpl instance) =>
    <String, dynamic>{
      'typename': instance.typename,
      'playlist': instance.playlist,
      'artist': instance.artist,
      'album': instance.album,
    };

_$SpotifyHomeFeedSectionImpl _$$SpotifyHomeFeedSectionImplFromJson(
        Map<String, dynamic> json) =>
    _$SpotifyHomeFeedSectionImpl(
      typename: json['typename'] as String,
      title: json['title'] as String?,
      uri: json['uri'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) =>
              SpotifyHomeFeedSectionItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$SpotifyHomeFeedSectionImplToJson(
        _$SpotifyHomeFeedSectionImpl instance) =>
    <String, dynamic>{
      'typename': instance.typename,
      'title': instance.title,
      'uri': instance.uri,
      'items': instance.items,
    };

_$SpotifyHomeFeedImpl _$$SpotifyHomeFeedImplFromJson(
        Map<String, dynamic> json) =>
    _$SpotifyHomeFeedImpl(
      greeting: json['greeting'] as String,
      sections: (json['sections'] as List<dynamic>)
          .map(
              (e) => SpotifyHomeFeedSection.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$SpotifyHomeFeedImplToJson(
        _$SpotifyHomeFeedImpl instance) =>
    <String, dynamic>{
      'greeting': instance.greeting,
      'sections': instance.sections,
    };
