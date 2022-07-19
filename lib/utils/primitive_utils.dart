import 'dart:math';
import 'package:uuid/uuid.dart';

abstract class PrimitiveUtils {
  static bool containsTextInBracket(String matcher, String text) {
    final allMatches = RegExp(r"(?<=\().+?(?=\))").allMatches(matcher);
    if (allMatches.isEmpty) return false;
    return allMatches
        .map((e) => e.group(0))
        .every((match) => match?.contains(text) ?? false);
  }

  static final Random _random = Random();
  static T getRandomElement<T>(List<T> list) {
    return list[_random.nextInt(list.length)];
  }

  static const uuid = Uuid();

  static String toReadableNumber(double num) {
    if (num > 999 && num < 99999) {
      return "${(num / 1000).toStringAsFixed(0)}K";
    } else if (num > 99999 && num < 999999) {
      return "${(num / 1000).toStringAsFixed(0)}K";
    } else if (num > 999999 && num < 999999999) {
      return "${(num / 1000000).toStringAsFixed(0)}M";
    } else if (num > 999999999) {
      return "${(num / 1000000000).toStringAsFixed(0)}B";
    } else {
      return num.toString();
    }
  }

  static String zeroPadNumStr(int input) {
    return input < 10 ? "0$input" : input.toString();
  }
}
