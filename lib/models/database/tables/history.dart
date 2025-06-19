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
  SpotubeSimplePlaylistObject? get playlist => type == HistoryEntryType.playlist
      ? SpotubeSimplePlaylistObject.fromJson(data)
      : null;
  SpotubeSimpleAlbumObject? get album => type == HistoryEntryType.album
      ? SpotubeSimpleAlbumObject.fromJson(data)
      : null;
  SpotubeTrackObject? get track =>
      type == HistoryEntryType.track ? SpotubeTrackObject.fromJson(data) : null;
}
