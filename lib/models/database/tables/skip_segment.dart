part of '../database.dart';

class SkipSegmentTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get start => integer()();
  IntColumn get end => integer()();
  TextColumn get trackId => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
