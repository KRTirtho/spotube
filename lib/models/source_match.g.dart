// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'source_match.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SourceMatchAdapter extends TypeAdapter<SourceMatch> {
  @override
  final int typeId = 6;

  @override
  SourceMatch read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SourceMatch(
      id: fields[0] as String,
      sourceId: fields[1] as String,
      sourceType: fields[2] as SourceType,
      createdAt: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, SourceMatch obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.sourceId)
      ..writeByte(2)
      ..write(obj.sourceType)
      ..writeByte(3)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SourceMatchAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SourceTypeAdapter extends TypeAdapter<SourceType> {
  @override
  final int typeId = 5;

  @override
  SourceType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SourceType.youtube;
      case 1:
        return SourceType.youtubeMusic;
      case 2:
        return SourceType.jiosaavn;
      default:
        return SourceType.youtube;
    }
  }

  @override
  void write(BinaryWriter writer, SourceType obj) {
    switch (obj) {
      case SourceType.youtube:
        writer.writeByte(0);
        break;
      case SourceType.youtubeMusic:
        writer.writeByte(1);
        break;
      case SourceType.jiosaavn:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SourceTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SourceMatch _$SourceMatchFromJson(Map json) => SourceMatch(
      id: json['id'] as String,
      sourceId: json['sourceId'] as String,
      sourceType: $enumDecode(_$SourceTypeEnumMap, json['sourceType']),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$SourceMatchToJson(SourceMatch instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sourceId': instance.sourceId,
      'sourceType': _$SourceTypeEnumMap[instance.sourceType]!,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$SourceTypeEnumMap = {
  SourceType.youtube: 'youtube',
  SourceType.youtubeMusic: 'youtubeMusic',
  SourceType.jiosaavn: 'jiosaavn',
};
