import 'package:hive/hive.dart';

part 'skip_segment.g.dart';

@HiveType(typeId: 2)
class SkipSegment {
  @HiveField(0)
  final int start;
  @HiveField(1)
  final int end;
  SkipSegment(this.start, this.end);

  static const boxName = "oss.krtirtho.spotube.skip_segments";
  static LazyBox<SkipSegment> get box => Hive.lazyBox<SkipSegment>(boxName);

  SkipSegment.fromJson(Map<String, dynamic> json)
      : start = json['start'],
        end = json['end'];

  Map<String, dynamic> toJson() => {
        'start': start,
        'end': end,
      };
}
