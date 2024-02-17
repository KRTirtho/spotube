import 'package:duration/locale.dart';
import 'package:duration/duration.dart';

extension DurationToHumanReadableString on Duration {
  String toHumanReadableString({padZero = true}) {
    final mm = inMinutes
        .remainder(60)
        .toString()
        .padLeft(2, !padZero && inHours == 0 ? '' : "0");
    final ss = inSeconds.remainder(60).toString().padLeft(2, "0");

    if (inHours > 0) {
      final hh = inHours.toString().padLeft(2, !padZero ? '' : "0");
      return "$hh:$mm:$ss";
    }

    return "$mm:$ss";
  }

  String format({
    DurationTersity tersity = DurationTersity.second,
    DurationTersity upperTersity = DurationTersity.week,
    DurationLocale locale = const EnglishDurationLocale(),
    String? spacer,
    String? delimiter,
    String? conjugation,
    bool abbreviated = false,
  }) =>
      printDuration(
        this,
        tersity: tersity,
        upperTersity: upperTersity,
        locale: locale,
        spacer: spacer,
        delimiter: delimiter,
        conjugation: conjugation,
        abbreviated: abbreviated,
      );
}

extension ParseDuration on Duration {
  static Duration fromString(String duration) {
    final parts = duration.split(':').reversed.toList();
    final seconds = int.parse(parts[0]);
    final minutes = parts.length > 1 ? int.parse(parts[1]) : 0;
    final hours = parts.length > 2 ? int.parse(parts[2]) : 0;
    return Duration(hours: hours, minutes: minutes, seconds: seconds);
  }
}
