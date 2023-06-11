import 'package:spotube/utils/primitive_utils.dart';

extension DurationToHumanReadableString on Duration {
  toHumanReadableString() =>
      "${inMinutes.remainder(60)}:${PrimitiveUtils.zeroPadNumStr(inSeconds.remainder(60))}";
}
