part of '../database.dart';

class PluginsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 50)();
  TextColumn get description => text()();
  TextColumn get version => text()();
  TextColumn get author => text()();
  TextColumn get entryPoint => text()();
  TextColumn get apis => text().map(const StringListConverter())();
  TextColumn get abilities => text().map(const StringListConverter())();
  BoolColumn get selectedForMetadata =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get selectedForAudioSource =>
      boolean().withDefault(const Constant(false))();
  TextColumn get repository => text().nullable()();
  TextColumn get pluginApiVersion =>
      text().withDefault(const Constant('2.0.0'))();
}
