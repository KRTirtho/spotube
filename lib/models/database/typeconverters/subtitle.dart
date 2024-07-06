part of '../database.dart';

class SubtitleTypeConverter extends TypeConverter<SubtitleSimple, String> {
  @override
  SubtitleSimple fromSql(String fromDb) {
    return SubtitleSimple.fromJson(jsonDecode(fromDb));
  }

  @override
  String toSql(SubtitleSimple value) {
    return jsonEncode(value.toJson());
  }
}
