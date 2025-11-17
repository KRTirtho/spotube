// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'metadata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SpotubeAudioSourceContainerPresetLossyImpl
    _$$SpotubeAudioSourceContainerPresetLossyImplFromJson(Map json) =>
        _$SpotubeAudioSourceContainerPresetLossyImpl(
          type: $enumDecode(_$SpotubeMediaCompressionTypeEnumMap, json['type']),
          name: json['name'] as String,
          qualities: (json['qualities'] as List<dynamic>)
              .map((e) => SpotubeAudioLossyContainerQuality.fromJson(
                  Map<String, dynamic>.from(e as Map)))
              .toList(),
        );

Map<String, dynamic> _$$SpotubeAudioSourceContainerPresetLossyImplToJson(
        _$SpotubeAudioSourceContainerPresetLossyImpl instance) =>
    <String, dynamic>{
      'type': _$SpotubeMediaCompressionTypeEnumMap[instance.type]!,
      'name': instance.name,
      'qualities': instance.qualities.map((e) => e.toJson()).toList(),
    };

const _$SpotubeMediaCompressionTypeEnumMap = {
  SpotubeMediaCompressionType.lossy: 'lossy',
  SpotubeMediaCompressionType.lossless: 'lossless',
};

_$SpotubeAudioSourceContainerPresetLosslessImpl
    _$$SpotubeAudioSourceContainerPresetLosslessImplFromJson(Map json) =>
        _$SpotubeAudioSourceContainerPresetLosslessImpl(
          type: $enumDecode(_$SpotubeMediaCompressionTypeEnumMap, json['type']),
          name: json['name'] as String,
          qualities: (json['qualities'] as List<dynamic>)
              .map((e) => SpotubeAudioLosslessContainerQuality.fromJson(
                  Map<String, dynamic>.from(e as Map)))
              .toList(),
        );

Map<String, dynamic> _$$SpotubeAudioSourceContainerPresetLosslessImplToJson(
        _$SpotubeAudioSourceContainerPresetLosslessImpl instance) =>
    <String, dynamic>{
      'type': _$SpotubeMediaCompressionTypeEnumMap[instance.type]!,
      'name': instance.name,
      'qualities': instance.qualities.map((e) => e.toJson()).toList(),
    };

_$SpotubeAudioLossyContainerQualityImpl
    _$$SpotubeAudioLossyContainerQualityImplFromJson(Map json) =>
        _$SpotubeAudioLossyContainerQualityImpl(
          bitrate: (json['bitrate'] as num).toInt(),
        );

Map<String, dynamic> _$$SpotubeAudioLossyContainerQualityImplToJson(
        _$SpotubeAudioLossyContainerQualityImpl instance) =>
    <String, dynamic>{
      'bitrate': instance.bitrate,
    };

_$SpotubeAudioLosslessContainerQualityImpl
    _$$SpotubeAudioLosslessContainerQualityImplFromJson(Map json) =>
        _$SpotubeAudioLosslessContainerQualityImpl(
          bitDepth: (json['bitDepth'] as num).toInt(),
          sampleRate: (json['sampleRate'] as num).toInt(),
        );

Map<String, dynamic> _$$SpotubeAudioLosslessContainerQualityImplToJson(
        _$SpotubeAudioLosslessContainerQualityImpl instance) =>
    <String, dynamic>{
      'bitDepth': instance.bitDepth,
      'sampleRate': instance.sampleRate,
    };

_$SpotubeAudioSourceMatchObjectImpl
    _$$SpotubeAudioSourceMatchObjectImplFromJson(Map json) =>
        _$SpotubeAudioSourceMatchObjectImpl(
          id: json['id'] as String,
          title: json['title'] as String,
          artists: (json['artists'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
          duration: Duration(microseconds: (json['duration'] as num).toInt()),
          thumbnail: json['thumbnail'] as String?,
          externalUri: json['externalUri'] as String,
        );

Map<String, dynamic> _$$SpotubeAudioSourceMatchObjectImplToJson(
        _$SpotubeAudioSourceMatchObjectImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'artists': instance.artists,
      'duration': instance.duration.inMicroseconds,
      'thumbnail': instance.thumbnail,
      'externalUri': instance.externalUri,
    };

_$SpotubeAudioSourceStreamObjectImpl
    _$$SpotubeAudioSourceStreamObjectImplFromJson(Map json) =>
        _$SpotubeAudioSourceStreamObjectImpl(
          url: json['url'] as String,
          container: json['container'] as String,
          type: $enumDecode(_$SpotubeMediaCompressionTypeEnumMap, json['type']),
          codec: json['codec'] as String?,
          bitrate: (json['bitrate'] as num?)?.toDouble(),
          bitDepth: (json['bitDepth'] as num?)?.toInt(),
          sampleRate: (json['sampleRate'] as num?)?.toDouble(),
        );

Map<String, dynamic> _$$SpotubeAudioSourceStreamObjectImplToJson(
        _$SpotubeAudioSourceStreamObjectImpl instance) =>
    <String, dynamic>{
      'url': instance.url,
      'container': instance.container,
      'type': _$SpotubeMediaCompressionTypeEnumMap[instance.type]!,
      'codec': instance.codec,
      'bitrate': instance.bitrate,
      'bitDepth': instance.bitDepth,
      'sampleRate': instance.sampleRate,
    };

_$SpotubeFullAlbumObjectImpl _$$SpotubeFullAlbumObjectImplFromJson(Map json) =>
    _$SpotubeFullAlbumObjectImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      artists: (json['artists'] as List<dynamic>)
          .map((e) => SpotubeSimpleArtistObject.fromJson(
              Map<String, dynamic>.from(e as Map)))
          .toList(),
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => SpotubeImageObject.fromJson(
                  Map<String, dynamic>.from(e as Map)))
              .toList() ??
          const [],
      releaseDate: json['releaseDate'] as String,
      externalUri: json['externalUri'] as String,
      totalTracks: (json['totalTracks'] as num).toInt(),
      albumType: $enumDecode(_$SpotubeAlbumTypeEnumMap, json['albumType']),
      recordLabel: json['recordLabel'] as String?,
      genres:
          (json['genres'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$SpotubeFullAlbumObjectImplToJson(
        _$SpotubeFullAlbumObjectImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'artists': instance.artists.map((e) => e.toJson()).toList(),
      'images': instance.images.map((e) => e.toJson()).toList(),
      'releaseDate': instance.releaseDate,
      'externalUri': instance.externalUri,
      'totalTracks': instance.totalTracks,
      'albumType': _$SpotubeAlbumTypeEnumMap[instance.albumType]!,
      'recordLabel': instance.recordLabel,
      'genres': instance.genres,
    };

const _$SpotubeAlbumTypeEnumMap = {
  SpotubeAlbumType.album: 'album',
  SpotubeAlbumType.single: 'single',
  SpotubeAlbumType.compilation: 'compilation',
};

_$SpotubeSimpleAlbumObjectImpl _$$SpotubeSimpleAlbumObjectImplFromJson(
        Map json) =>
    _$SpotubeSimpleAlbumObjectImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      externalUri: json['externalUri'] as String,
      artists: (json['artists'] as List<dynamic>)
          .map((e) => SpotubeSimpleArtistObject.fromJson(
              Map<String, dynamic>.from(e as Map)))
          .toList(),
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => SpotubeImageObject.fromJson(
                  Map<String, dynamic>.from(e as Map)))
              .toList() ??
          const [],
      albumType: $enumDecode(_$SpotubeAlbumTypeEnumMap, json['albumType']),
      releaseDate: json['releaseDate'] as String?,
    );

Map<String, dynamic> _$$SpotubeSimpleAlbumObjectImplToJson(
        _$SpotubeSimpleAlbumObjectImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'externalUri': instance.externalUri,
      'artists': instance.artists.map((e) => e.toJson()).toList(),
      'images': instance.images.map((e) => e.toJson()).toList(),
      'albumType': _$SpotubeAlbumTypeEnumMap[instance.albumType]!,
      'releaseDate': instance.releaseDate,
    };

_$SpotubeFullArtistObjectImpl _$$SpotubeFullArtistObjectImplFromJson(
        Map json) =>
    _$SpotubeFullArtistObjectImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      externalUri: json['externalUri'] as String,
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => SpotubeImageObject.fromJson(
                  Map<String, dynamic>.from(e as Map)))
              .toList() ??
          const [],
      genres:
          (json['genres'] as List<dynamic>?)?.map((e) => e as String).toList(),
      followers: (json['followers'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$SpotubeFullArtistObjectImplToJson(
        _$SpotubeFullArtistObjectImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'externalUri': instance.externalUri,
      'images': instance.images.map((e) => e.toJson()).toList(),
      'genres': instance.genres,
      'followers': instance.followers,
    };

_$SpotubeSimpleArtistObjectImpl _$$SpotubeSimpleArtistObjectImplFromJson(
        Map json) =>
    _$SpotubeSimpleArtistObjectImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      externalUri: json['externalUri'] as String,
      images: (json['images'] as List<dynamic>?)
          ?.map((e) =>
              SpotubeImageObject.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
    );

Map<String, dynamic> _$$SpotubeSimpleArtistObjectImplToJson(
        _$SpotubeSimpleArtistObjectImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'externalUri': instance.externalUri,
      'images': instance.images?.map((e) => e.toJson()).toList(),
    };

_$SpotubeBrowseSectionObjectImpl<T>
    _$$SpotubeBrowseSectionObjectImplFromJson<T>(
  Map json,
  T Function(Object? json) fromJsonT,
) =>
        _$SpotubeBrowseSectionObjectImpl<T>(
          id: json['id'] as String,
          title: json['title'] as String,
          externalUri: json['externalUri'] as String,
          browseMore: json['browseMore'] as bool,
          items: (json['items'] as List<dynamic>).map(fromJsonT).toList(),
        );

Map<String, dynamic> _$$SpotubeBrowseSectionObjectImplToJson<T>(
  _$SpotubeBrowseSectionObjectImpl<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'externalUri': instance.externalUri,
      'browseMore': instance.browseMore,
      'items': instance.items.map(toJsonT).toList(),
    };

_$MetadataFormFieldInputObjectImpl _$$MetadataFormFieldInputObjectImplFromJson(
        Map json) =>
    _$MetadataFormFieldInputObjectImpl(
      objectType: json['objectType'] as String,
      id: json['id'] as String,
      variant:
          $enumDecodeNullable(_$FormFieldVariantEnumMap, json['variant']) ??
              FormFieldVariant.text,
      placeholder: json['placeholder'] as String?,
      defaultValue: json['defaultValue'] as String?,
      required: json['required'] as bool?,
      regex: json['regex'] as String?,
    );

Map<String, dynamic> _$$MetadataFormFieldInputObjectImplToJson(
        _$MetadataFormFieldInputObjectImpl instance) =>
    <String, dynamic>{
      'objectType': instance.objectType,
      'id': instance.id,
      'variant': _$FormFieldVariantEnumMap[instance.variant]!,
      'placeholder': instance.placeholder,
      'defaultValue': instance.defaultValue,
      'required': instance.required,
      'regex': instance.regex,
    };

const _$FormFieldVariantEnumMap = {
  FormFieldVariant.text: 'text',
  FormFieldVariant.password: 'password',
  FormFieldVariant.number: 'number',
};

_$MetadataFormFieldTextObjectImpl _$$MetadataFormFieldTextObjectImplFromJson(
        Map json) =>
    _$MetadataFormFieldTextObjectImpl(
      objectType: json['objectType'] as String,
      text: json['text'] as String,
    );

Map<String, dynamic> _$$MetadataFormFieldTextObjectImplToJson(
        _$MetadataFormFieldTextObjectImpl instance) =>
    <String, dynamic>{
      'objectType': instance.objectType,
      'text': instance.text,
    };

_$SpotubeImageObjectImpl _$$SpotubeImageObjectImplFromJson(Map json) =>
    _$SpotubeImageObjectImpl(
      url: json['url'] as String,
      width: (json['width'] as num?)?.toInt(),
      height: (json['height'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$SpotubeImageObjectImplToJson(
        _$SpotubeImageObjectImpl instance) =>
    <String, dynamic>{
      'url': instance.url,
      'width': instance.width,
      'height': instance.height,
    };

_$SpotubePaginationResponseObjectImpl<T>
    _$$SpotubePaginationResponseObjectImplFromJson<T>(
  Map json,
  T Function(Object? json) fromJsonT,
) =>
        _$SpotubePaginationResponseObjectImpl<T>(
          limit: (json['limit'] as num).toInt(),
          nextOffset: (json['nextOffset'] as num?)?.toInt(),
          total: (json['total'] as num).toInt(),
          hasMore: json['hasMore'] as bool,
          items: (json['items'] as List<dynamic>).map(fromJsonT).toList(),
        );

Map<String, dynamic> _$$SpotubePaginationResponseObjectImplToJson<T>(
  _$SpotubePaginationResponseObjectImpl<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'limit': instance.limit,
      'nextOffset': instance.nextOffset,
      'total': instance.total,
      'hasMore': instance.hasMore,
      'items': instance.items.map(toJsonT).toList(),
    };

_$SpotubeFullPlaylistObjectImpl _$$SpotubeFullPlaylistObjectImplFromJson(
        Map json) =>
    _$SpotubeFullPlaylistObjectImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      externalUri: json['externalUri'] as String,
      owner: SpotubeUserObject.fromJson(
          Map<String, dynamic>.from(json['owner'] as Map)),
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => SpotubeImageObject.fromJson(
                  Map<String, dynamic>.from(e as Map)))
              .toList() ??
          const [],
      collaborators: (json['collaborators'] as List<dynamic>?)
              ?.map((e) => SpotubeUserObject.fromJson(
                  Map<String, dynamic>.from(e as Map)))
              .toList() ??
          const [],
      collaborative: json['collaborative'] as bool? ?? false,
      public: json['public'] as bool? ?? false,
    );

Map<String, dynamic> _$$SpotubeFullPlaylistObjectImplToJson(
        _$SpotubeFullPlaylistObjectImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'externalUri': instance.externalUri,
      'owner': instance.owner.toJson(),
      'images': instance.images.map((e) => e.toJson()).toList(),
      'collaborators': instance.collaborators.map((e) => e.toJson()).toList(),
      'collaborative': instance.collaborative,
      'public': instance.public,
    };

_$SpotubeSimplePlaylistObjectImpl _$$SpotubeSimplePlaylistObjectImplFromJson(
        Map json) =>
    _$SpotubeSimplePlaylistObjectImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      externalUri: json['externalUri'] as String,
      owner: SpotubeUserObject.fromJson(
          Map<String, dynamic>.from(json['owner'] as Map)),
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => SpotubeImageObject.fromJson(
                  Map<String, dynamic>.from(e as Map)))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$SpotubeSimplePlaylistObjectImplToJson(
        _$SpotubeSimplePlaylistObjectImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'externalUri': instance.externalUri,
      'owner': instance.owner.toJson(),
      'images': instance.images.map((e) => e.toJson()).toList(),
    };

_$SpotubeSearchResponseObjectImpl _$$SpotubeSearchResponseObjectImplFromJson(
        Map json) =>
    _$SpotubeSearchResponseObjectImpl(
      albums: (json['albums'] as List<dynamic>)
          .map((e) => SpotubeSimpleAlbumObject.fromJson(
              Map<String, dynamic>.from(e as Map)))
          .toList(),
      artists: (json['artists'] as List<dynamic>)
          .map((e) => SpotubeFullArtistObject.fromJson(
              Map<String, dynamic>.from(e as Map)))
          .toList(),
      playlists: (json['playlists'] as List<dynamic>)
          .map((e) => SpotubeSimplePlaylistObject.fromJson(
              Map<String, dynamic>.from(e as Map)))
          .toList(),
      tracks: (json['tracks'] as List<dynamic>)
          .map((e) => SpotubeFullTrackObject.fromJson(
              Map<String, dynamic>.from(e as Map)))
          .toList(),
    );

Map<String, dynamic> _$$SpotubeSearchResponseObjectImplToJson(
        _$SpotubeSearchResponseObjectImpl instance) =>
    <String, dynamic>{
      'albums': instance.albums.map((e) => e.toJson()).toList(),
      'artists': instance.artists.map((e) => e.toJson()).toList(),
      'playlists': instance.playlists.map((e) => e.toJson()).toList(),
      'tracks': instance.tracks.map((e) => e.toJson()).toList(),
    };

_$SpotubeLocalTrackObjectImpl _$$SpotubeLocalTrackObjectImplFromJson(
        Map json) =>
    _$SpotubeLocalTrackObjectImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      externalUri: json['externalUri'] as String,
      artists: (json['artists'] as List<dynamic>?)
              ?.map((e) => SpotubeSimpleArtistObject.fromJson(
                  Map<String, dynamic>.from(e as Map)))
              .toList() ??
          const [],
      album: SpotubeSimpleAlbumObject.fromJson(
          Map<String, dynamic>.from(json['album'] as Map)),
      durationMs: (json['durationMs'] as num).toInt(),
      path: json['path'] as String,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$SpotubeLocalTrackObjectImplToJson(
        _$SpotubeLocalTrackObjectImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'externalUri': instance.externalUri,
      'artists': instance.artists.map((e) => e.toJson()).toList(),
      'album': instance.album.toJson(),
      'durationMs': instance.durationMs,
      'path': instance.path,
      'runtimeType': instance.$type,
    };

_$SpotubeFullTrackObjectImpl _$$SpotubeFullTrackObjectImplFromJson(Map json) =>
    _$SpotubeFullTrackObjectImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      externalUri: json['externalUri'] as String,
      artists: (json['artists'] as List<dynamic>?)
              ?.map((e) => SpotubeSimpleArtistObject.fromJson(
                  Map<String, dynamic>.from(e as Map)))
              .toList() ??
          const [],
      album: SpotubeSimpleAlbumObject.fromJson(
          Map<String, dynamic>.from(json['album'] as Map)),
      durationMs: (json['durationMs'] as num).toInt(),
      isrc: json['isrc'] as String,
      explicit: json['explicit'] as bool,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$SpotubeFullTrackObjectImplToJson(
        _$SpotubeFullTrackObjectImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'externalUri': instance.externalUri,
      'artists': instance.artists.map((e) => e.toJson()).toList(),
      'album': instance.album.toJson(),
      'durationMs': instance.durationMs,
      'isrc': instance.isrc,
      'explicit': instance.explicit,
      'runtimeType': instance.$type,
    };

_$SpotubeUserObjectImpl _$$SpotubeUserObjectImplFromJson(Map json) =>
    _$SpotubeUserObjectImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => SpotubeImageObject.fromJson(
                  Map<String, dynamic>.from(e as Map)))
              .toList() ??
          const [],
      externalUri: json['externalUri'] as String,
    );

Map<String, dynamic> _$$SpotubeUserObjectImplToJson(
        _$SpotubeUserObjectImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'images': instance.images.map((e) => e.toJson()).toList(),
      'externalUri': instance.externalUri,
    };

_$PluginConfigurationImpl _$$PluginConfigurationImplFromJson(Map json) =>
    _$PluginConfigurationImpl(
      name: json['name'] as String,
      description: json['description'] as String,
      version: json['version'] as String,
      author: json['author'] as String,
      entryPoint: json['entryPoint'] as String,
      pluginApiVersion: json['pluginApiVersion'] as String,
      apis: (json['apis'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$PluginApisEnumMap, e))
              .toList() ??
          const [],
      abilities: (json['abilities'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$PluginAbilitiesEnumMap, e))
              .toList() ??
          const [],
      repository: json['repository'] as String?,
    );

Map<String, dynamic> _$$PluginConfigurationImplToJson(
        _$PluginConfigurationImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'version': instance.version,
      'author': instance.author,
      'entryPoint': instance.entryPoint,
      'pluginApiVersion': instance.pluginApiVersion,
      'apis': instance.apis.map((e) => _$PluginApisEnumMap[e]!).toList(),
      'abilities':
          instance.abilities.map((e) => _$PluginAbilitiesEnumMap[e]!).toList(),
      'repository': instance.repository,
    };

const _$PluginApisEnumMap = {
  PluginApis.webview: 'webview',
  PluginApis.localstorage: 'localstorage',
  PluginApis.timezone: 'timezone',
};

const _$PluginAbilitiesEnumMap = {
  PluginAbilities.authentication: 'authentication',
  PluginAbilities.scrobbling: 'scrobbling',
  PluginAbilities.metadata: 'metadata',
  PluginAbilities.audioSource: 'audio-source',
};

_$PluginUpdateAvailableImpl _$$PluginUpdateAvailableImplFromJson(Map json) =>
    _$PluginUpdateAvailableImpl(
      downloadUrl: json['downloadUrl'] as String,
      version: json['version'] as String,
      changelog: json['changelog'] as String?,
    );

Map<String, dynamic> _$$PluginUpdateAvailableImplToJson(
        _$PluginUpdateAvailableImpl instance) =>
    <String, dynamic>{
      'downloadUrl': instance.downloadUrl,
      'version': instance.version,
      'changelog': instance.changelog,
    };

_$MetadataPluginRepositoryImpl _$$MetadataPluginRepositoryImplFromJson(
        Map json) =>
    _$MetadataPluginRepositoryImpl(
      name: json['name'] as String,
      owner: json['owner'] as String,
      description: json['description'] as String,
      repoUrl: json['repoUrl'] as String,
      topics:
          (json['topics'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$MetadataPluginRepositoryImplToJson(
        _$MetadataPluginRepositoryImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'owner': instance.owner,
      'description': instance.description,
      'repoUrl': instance.repoUrl,
      'topics': instance.topics,
    };
