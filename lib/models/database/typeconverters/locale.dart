part of '../database.dart';

class LocaleConverter extends TypeConverter<Locale, String> {
  const LocaleConverter();

  @override
  Locale fromSql(String fromDb) {
    final rawMap = jsonDecode(fromDb) as Map<String, dynamic>;
    return Locale(rawMap["languageCode"], rawMap["countryCode"]);
  }

  @override
  String toSql(Locale value) {
    return jsonEncode({
      "languageCode": value.languageCode,
      "countryCode": value.countryCode,
    });
  }
}
