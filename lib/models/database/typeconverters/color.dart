part of '../database.dart';

class ColorConverter extends TypeConverter<Color, int> {
  const ColorConverter();

  @override
  Color fromSql(int fromDb) {
    return Color(fromDb);
  }

  @override
  int toSql(Color value) {
    return value.toARGB32();
  }
}

class SpotubeColorConverter extends TypeConverter<SpotubeColor, String> {
  const SpotubeColorConverter();

  @override
  SpotubeColor fromSql(String fromDb) {
    return SpotubeColor.fromString(fromDb);
  }

  @override
  String toSql(SpotubeColor value) {
    return value.toString();
  }
}
