// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'matched_track.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MatchedTrackAdapter extends TypeAdapter<MatchedTrack> {
  @override
  final int typeId = 1;

  @override
  MatchedTrack read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MatchedTrack(
      youtubeId: fields[0] as String,
      spotifyId: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MatchedTrack obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.youtubeId)
      ..writeByte(1)
      ..write(obj.spotifyId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MatchedTrackAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
