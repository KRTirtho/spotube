part of '../database.dart';

class MapListConverter
    extends TypeConverter<List<Map<String, dynamic>>, String> {
  const MapListConverter();

  @override
  List<Map<String, dynamic>> fromSql(String fromDb) {
    return fromDb
        .split(",")
        .where((e) => e.isNotEmpty)
        .map((e) => json.decode(e) as Map<String, dynamic>)
        .toList();
  }

  @override
  String toSql(List<Map<String, dynamic>> value) {
    return value.map((e) => json.encode(e)).join(",");
  }
}
