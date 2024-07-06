part of '../database.dart';

class LyricsTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get trackId => text()();
  TextColumn get data => text().map(SubtitleTypeConverter())();
}
