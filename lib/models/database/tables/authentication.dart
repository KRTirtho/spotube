part of '../database.dart';

class AuthenticationTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get cookie => text().map(EncryptedTextConverter())();
  TextColumn get accessToken => text().map(EncryptedTextConverter())();
  DateTimeColumn get expiration => dateTime()();
}
