import 'package:spotube/services/logger/logger.dart';

/// Parses duration string formatted by Duration.toString() to [Duration].
/// The string should be of form hours:minutes:seconds.microseconds
///
/// Example:
///     parseTime('245:09:08.007006');
Duration parseDuration(String input) {
  final parts = input.split(':');

  if (parts.length != 3) throw const FormatException('Invalid time format');

  int days;
  int hours;
  int minutes;
  int seconds;
  int milliseconds;
  int microseconds;

  {
    final p = parts[2].split('.');

    if (p.length != 2) throw const FormatException('Invalid time format');

    final p2 = int.parse(p[1]);
    microseconds = p2 % 1000;
    milliseconds = p2 ~/ 1000;

    seconds = int.parse(p[0]);
  }

  minutes = int.parse(parts[1]);

  {
    int p = int.parse(parts[0]);
    hours = p % 24;
    days = p ~/ 24;
  }

  return Duration(
    days: days,
    hours: hours,
    minutes: minutes,
    seconds: seconds,
    milliseconds: milliseconds,
    microseconds: microseconds,
  );
}

Duration? tryParseDuration(String input) {
  try {
    return parseDuration(input);
  } catch (e, stack) {
    AppLogger.reportError(e, stack);
    return null;
  }
}
