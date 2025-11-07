part of '../database.dart';

class SourceMatchTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get trackId => text()();
  TextColumn get sourceInfo => text().withDefault(const Constant("{}"))();
  TextColumn get sourceType => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
