// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'skip_segment.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SkipSegmentAdapter extends TypeAdapter<SkipSegment> {
  @override
  final int typeId = 2;

  @override
  SkipSegment read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SkipSegment(
      fields[0] as int,
      fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, SkipSegment obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.start)
      ..writeByte(1)
      ..write(obj.end);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SkipSegmentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
