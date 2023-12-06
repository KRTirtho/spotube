import 'package:json_annotation/json_annotation.dart';

part 'source_info.g.dart';

@JsonSerializable()
class SourceInfo {
  final String id;
  final String title;
  final String artist;
  final String artistUrl;
  final String? album;

  final String thumbnail;
  final String pageUrl;

  final Duration duration;

  SourceInfo({
    required this.id,
    required this.title,
    required this.artist,
    required this.thumbnail,
    required this.pageUrl,
    required this.duration,
    required this.artistUrl,
    this.album,
  });

  factory SourceInfo.fromJson(Map<String, dynamic> json) =>
      _$SourceInfoFromJson(json);

  Map<String, dynamic> toJson() => _$SourceInfoToJson(this);
}
