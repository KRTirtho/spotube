part of '../database.dart';

enum SourceType {
  youtube._("YouTube"),
  youtubeMusic._("YouTube Music"),
  jiosaavn._("JioSaavn");

  final String label;

  const SourceType._(this.label);
}

@TableIndex(
  name: "uniq_track_match",
  columns: {#trackId, #sourceId, #sourceType},
  unique: true,
)
class SourceMatchTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get trackId => text()();
  TextColumn get sourceId => text()();
  TextColumn get sourceType =>
      textEnum<SourceType>().withDefault(Constant(SourceType.youtube.name))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
