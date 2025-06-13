part of '../database.dart';

class MetadataPluginsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 50)();
  TextColumn get description => text()();
  TextColumn get version => text()();
  TextColumn get author => text()();
  BoolColumn get selected => boolean().withDefault(const Constant(false))();
}
