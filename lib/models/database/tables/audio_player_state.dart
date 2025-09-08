part of '../database.dart';

class AudioPlayerStateTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  BoolColumn get playing => boolean()();
  TextColumn get loopMode => textEnum<PlaylistMode>()();
  BoolColumn get shuffled => boolean()();
  TextColumn get collections => text().map(const StringListConverter())();
}

class PlaylistTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get audioPlayerStateId =>
      integer().references(AudioPlayerStateTable, #id)();
  IntColumn get index => integer()();
}

class PlaylistMediaTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get playlistId => integer().references(PlaylistTable, #id)();

  TextColumn get uri => text()();
  TextColumn get extras =>
      text().nullable().map(const MapTypeConverter<String, dynamic>())();
  TextColumn get httpHeaders =>
      text().nullable().map(const MapTypeConverter<String, String>())();
}
