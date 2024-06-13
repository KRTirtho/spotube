part of '../database.dart';

class StringListConverter extends TypeConverter<List<String>, String> {
  const StringListConverter();

  @override
  List<String> fromSql(String fromDb) {
    return fromDb.split(",");
  }

  @override
  String toSql(List<String> value) {
    return value.join(",");
  }
}
