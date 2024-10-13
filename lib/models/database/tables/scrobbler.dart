part of '../database.dart';

class ScrobblerTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get username => text()();
  TextColumn get passwordHash => text().map(EncryptedTextConverter())();
}
