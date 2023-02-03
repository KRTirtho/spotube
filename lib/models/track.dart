import 'package:json_annotation/json_annotation.dart';
import 'package:pocketbase/pocketbase.dart';
part 'track.g.dart';

@JsonSerializable()
class BackendTrack extends RecordModel {
  @JsonKey(name: "spotify_id")
  final String spotifyId;
  @JsonKey(name: "youtube_id")
  final String youtubeId;
  final int votes;

  BackendTrack({
    required this.spotifyId,
    required this.youtubeId,
    required this.votes,
  });

  factory BackendTrack.fromRecord(RecordModel record) =>
      BackendTrack.fromJson(record.toJson());

  factory BackendTrack.fromJson(Map<String, dynamic> json) =>
      _$BackendTrackFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$BackendTrackToJson(this);

  static String collection = "tracks";
}
