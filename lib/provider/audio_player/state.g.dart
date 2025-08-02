// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AudioPlayerStateImpl _$$AudioPlayerStateImplFromJson(Map json) =>
    _$AudioPlayerStateImpl(
      playing: json['playing'] as bool,
      loopMode: $enumDecode(_$PlaylistModeEnumMap, json['loopMode']),
      shuffled: json['shuffled'] as bool,
      collections: (json['collections'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      currentIndex: (json['currentIndex'] as num?)?.toInt() ?? 0,
      tracks: (json['tracks'] as List<dynamic>?)
              ?.map((e) => SpotubeTrackObject.fromJson(
                  Map<String, dynamic>.from(e as Map)))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$AudioPlayerStateImplToJson(
        _$AudioPlayerStateImpl instance) =>
    <String, dynamic>{
      'playing': instance.playing,
      'loopMode': _$PlaylistModeEnumMap[instance.loopMode]!,
      'shuffled': instance.shuffled,
      'collections': instance.collections,
      'currentIndex': instance.currentIndex,
      'tracks': instance.tracks.map((e) => e.toJson()).toList(),
    };

const _$PlaylistModeEnumMap = {
  PlaylistMode.none: 'none',
  PlaylistMode.single: 'single',
  PlaylistMode.loop: 'loop',
};
