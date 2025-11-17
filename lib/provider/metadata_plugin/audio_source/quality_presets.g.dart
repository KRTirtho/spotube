// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quality_presets.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AudioSourcePresetsStateImpl _$$AudioSourcePresetsStateImplFromJson(
        Map json) =>
    _$AudioSourcePresetsStateImpl(
      presets: (json['presets'] as List<dynamic>?)
              ?.map((e) => SpotubeAudioSourceContainerPreset.fromJson(
                  Map<String, dynamic>.from(e as Map)))
              .toList() ??
          const [],
      selectedStreamingQualityIndex:
          (json['selectedStreamingQualityIndex'] as num?)?.toInt() ?? 0,
      selectedStreamingContainerIndex:
          (json['selectedStreamingContainerIndex'] as num?)?.toInt() ?? 0,
      selectedDownloadingQualityIndex:
          (json['selectedDownloadingQualityIndex'] as num?)?.toInt() ?? 0,
      selectedDownloadingContainerIndex:
          (json['selectedDownloadingContainerIndex'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$AudioSourcePresetsStateImplToJson(
        _$AudioSourcePresetsStateImpl instance) =>
    <String, dynamic>{
      'presets': instance.presets.map((e) => e.toJson()).toList(),
      'selectedStreamingQualityIndex': instance.selectedStreamingQualityIndex,
      'selectedStreamingContainerIndex':
          instance.selectedStreamingContainerIndex,
      'selectedDownloadingQualityIndex':
          instance.selectedDownloadingQualityIndex,
      'selectedDownloadingContainerIndex':
          instance.selectedDownloadingContainerIndex,
    };
