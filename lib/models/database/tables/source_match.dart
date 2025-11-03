part of '../database.dart';

@TableIndex(
  name: "uniq_track_match",
  columns: {#trackId, #sourceInfo, #sourceType},
  unique: true,
)
class SourceMatchTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get trackId => text()();
  TextColumn get sourceInfo => text()();
  TextColumn get sourceType => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
