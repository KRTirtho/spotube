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
      searchMode: fields[2] as SearchMode,
    );
  }

  @override
  void write(BinaryWriter writer, MatchedTrack obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.youtubeId)
      ..writeByte(1)
      ..write(obj.spotifyId)
      ..writeByte(2)
      ..write(obj.searchMode);
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

class SearchModeAdapter extends TypeAdapter<SearchMode> {
  @override
  final int typeId = 4;

  @override
  SearchMode read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SearchMode.youtube;
      case 1:
        return SearchMode.youtubeMusic;
      default:
        return SearchMode.youtube;
    }
  }

  @override
  void write(BinaryWriter writer, SearchMode obj) {
    switch (obj) {
      case SearchMode.youtube:
        writer.writeByte(0);
        break;
      case SearchMode.youtubeMusic:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchModeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
