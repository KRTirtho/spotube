// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CacheTrack.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CacheTrackEngagementAdapter extends TypeAdapter<CacheTrackEngagement> {
  @override
  final int typeId = 2;

  @override
  CacheTrackEngagement read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CacheTrackEngagement()
      ..viewCount = fields[0] as int
      ..likeCount = fields[1] as int?
      ..dislikeCount = fields[2] as int?;
  }

  @override
  void write(BinaryWriter writer, CacheTrackEngagement obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.viewCount)
      ..writeByte(1)
      ..write(obj.likeCount)
      ..writeByte(2)
      ..write(obj.dislikeCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CacheTrackEngagementAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CacheTrackAdapter extends TypeAdapter<CacheTrack> {
  @override
  final int typeId = 1;

  @override
  CacheTrack read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CacheTrack()
      ..id = fields[0] as String
      ..title = fields[1] as String
      ..channelId = fields[2] as String
      ..uploadDate = fields[3] as String?
      ..publishDate = fields[4] as String?
      ..description = fields[5] as String
      ..duration = fields[6] as String?
      ..keywords = (fields[7] as List?)?.cast<String>()
      ..engagement = fields[8] as CacheTrackEngagement
      ..mode = fields[9] as String
      ..author = fields[10] as String;
  }

  @override
  void write(BinaryWriter writer, CacheTrack obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.channelId)
      ..writeByte(3)
      ..write(obj.uploadDate)
      ..writeByte(4)
      ..write(obj.publishDate)
      ..writeByte(5)
      ..write(obj.description)
      ..writeByte(6)
      ..write(obj.duration)
      ..writeByte(7)
      ..write(obj.keywords)
      ..writeByte(8)
      ..write(obj.engagement)
      ..writeByte(9)
      ..write(obj.mode)
      ..writeByte(10)
      ..write(obj.author);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CacheTrackAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
