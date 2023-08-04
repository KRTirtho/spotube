import 'package:hive/hive.dart';

part 'skip_segment.g.dart';

@HiveType(typeId: 2)
class SkipSegment {
  @HiveField(0)
  final int start;
  @HiveField(1)
  final int end;
  SkipSegment(this.start, this.end);

  static String version = 'v1';
  static final boxName = "oss.krtirtho.spotube.skip_segments.$version";
  static LazyBox get box => Hive.lazyBox(boxName);

  SkipSegment.fromJson(Map<String, dynamic> json)
      : start = json['start'],
        end = json['end'];

  Map<String, dynamic> toJson() => {
        'start': start,
        'end': end,
      };
}
