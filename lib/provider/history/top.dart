import 'package:hooks_riverpod/hooks_riverpod.dart';

enum HistoryDuration {
  allTime(Duration(days: 365 * 2003)),
  days7(Duration(days: 7)),
  days30(Duration(days: 30)),
  months6(Duration(days: 30 * 6)),
  year(Duration(days: 365)),
  years2(Duration(days: 365 * 2));

  final Duration duration;

  const HistoryDuration(this.duration);
}

final playbackHistoryTopDurationProvider =
    StateProvider((ref) => HistoryDuration.days30);
