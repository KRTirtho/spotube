import 'package:duration/locale.dart';
import 'package:spotube/utils/primitive_utils.dart';
import 'package:duration/duration.dart';

extension DurationToHumanReadableString on Duration {
  String toHumanReadableString() =>
      "${inMinutes.remainder(60)}:${PrimitiveUtils.zeroPadNumStr(inSeconds.remainder(60))}";

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
