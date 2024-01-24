import 'package:json_annotation/json_annotation.dart';
import 'package:spotube/services/sourced_track/enums.dart';

part 'source_map.g.dart';

@JsonSerializable()
class SourceQualityMap {
  final String high;
  final String medium;
  final String low;

  const SourceQualityMap({
    required this.high,
    required this.medium,
    required this.low,
  });

  factory SourceQualityMap.fromJson(Map<String, dynamic> json) =>
      _$SourceQualityMapFromJson(json);

  Map<String, dynamic> toJson() => _$SourceQualityMapToJson(this);

  operator [](SourceQualities key) {
    switch (key) {
      case SourceQualities.high:
        return high;
      case SourceQualities.medium:
        return medium;
      case SourceQualities.low:
        return low;
    }
  }
}

@JsonSerializable()
class SourceMap {
  final SourceQualityMap? weba;
  final SourceQualityMap? m4a;

  const SourceMap({
    this.weba,
    this.m4a,
  });

  factory SourceMap.fromJson(Map<String, dynamic> json) =>
      _$SourceMapFromJson(json);

  Map<String, dynamic> toJson() => _$SourceMapToJson(this);

  operator [](SourceCodecs key) {
    switch (key) {
      case SourceCodecs.weba:
        return weba;
      case SourceCodecs.m4a:
        return m4a;
    }
  }
}
