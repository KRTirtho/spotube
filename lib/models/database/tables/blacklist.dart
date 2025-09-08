part of '../database.dart';

enum BlacklistedType {
  artist,
  track;
}

@TableIndex(
  name: "unique_blacklist",
  unique: true,
  columns: {#elementType, #elementId},
)
class BlacklistTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get elementType => textEnum<BlacklistedType>()();
  TextColumn get elementId => text()();
}
