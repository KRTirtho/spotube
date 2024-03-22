import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'source_match.g.dart';

@JsonEnum()
@HiveType(typeId: 5)
enum SourceType {
  @HiveField(0)
  youtube._("YouTube"),

  @HiveField(1)
  youtubeMusic._("YouTube Music"),

  @HiveField(2)
  jiosaavn._("JioSaavn");

  final String label;

  const SourceType._(this.label);
}

@JsonSerializable()
@HiveType(typeId: 6)
class SourceMatch {
  @HiveField(0)
  String id;

  @HiveField(1)
  String sourceId;

  @HiveField(2)
  SourceType sourceType;

  @HiveField(3)
  DateTime createdAt;

  SourceMatch({
    required this.id,
    required this.sourceId,
    required this.sourceType,
    required this.createdAt,
  });

  factory SourceMatch.fromJson(Map<String, dynamic> json) =>
      _$SourceMatchFromJson(json);

  Map<String, dynamic> toJson() => _$SourceMatchToJson(this);

  static String version = 'v1';
  static final boxName = "oss.krtirtho.spotube.source_matches.$version";

  static LazyBox<SourceMatch> get box => Hive.lazyBox<SourceMatch>(boxName);
}
