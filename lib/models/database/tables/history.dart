part of '../database.dart';

enum HistoryEntryType {
  playlist,
  album,
  track,
}

class HistoryTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get type => textEnum<HistoryEntryType>()();
  TextColumn get itemId => text()();
  TextColumn get data =>
      text().map(const MapTypeConverter<String, dynamic>())();
}

extension HistoryItemParseExtension on HistoryTableData {
  PlaylistSimple? get playlist =>
      type == HistoryEntryType.playlist ? PlaylistSimple.fromJson(data) : null;
  AlbumSimple? get album =>
      type == HistoryEntryType.album ? AlbumSimple.fromJson(data) : null;
  Track? get track =>
      type == HistoryEntryType.track ? Track.fromJson(data) : null;
}
