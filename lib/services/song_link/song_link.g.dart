// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'song_link.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SongLinkImpl _$$SongLinkImplFromJson(Map json) => _$SongLinkImpl(
      displayName: json['displayName'] as String,
      linkId: json['linkId'] as String,
      platform: json['platform'] as String,
      show: json['show'] as bool,
      uniqueId: json['uniqueId'] as String?,
      country: json['country'] as String?,
      url: json['url'] as String?,
      nativeAppUriMobile: json['nativeAppUriMobile'] as String?,
      nativeAppUriDesktop: json['nativeAppUriDesktop'] as String?,
    );

Map<String, dynamic> _$$SongLinkImplToJson(_$SongLinkImpl instance) =>
    <String, dynamic>{
      'displayName': instance.displayName,
      'linkId': instance.linkId,
      'platform': instance.platform,
      'show': instance.show,
      'uniqueId': instance.uniqueId,
      'country': instance.country,
      'url': instance.url,
      'nativeAppUriMobile': instance.nativeAppUriMobile,
      'nativeAppUriDesktop': instance.nativeAppUriDesktop,
    };
