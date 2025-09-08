part of '../database.dart';

class MapTypeConverter<K, V> extends TypeConverter<Map<K, V>, String> {
  const MapTypeConverter();

  @override
  fromSql(String fromDb) {
    return json.decode(fromDb) as Map<K, V>;
  }

  @override
  toSql(value) {
    return json.encode(value);
  }
}
