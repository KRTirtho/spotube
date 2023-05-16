import "package:hive/hive.dart";

part "matched_track.g.dart";

@HiveType(typeId: 1)
class MatchedTrack {
  @HiveField(0)
  String youtubeId;
  @HiveField(1)
  String spotifyId;

  String? id;
  DateTime? createdAt;

  bool get isSynced => id != null;

  static const boxName = "oss.krtirtho.spotube.matched_tracks";

  static LazyBox<MatchedTrack> get box => Hive.lazyBox<MatchedTrack>(boxName);

  MatchedTrack({
    required this.youtubeId,
    required this.spotifyId,
    this.id,
    this.createdAt,
  });

  factory MatchedTrack.fromJson(Map<String, dynamic> json) {
    return MatchedTrack(
      youtubeId: json["youtube_id"],
      spotifyId: json["spotify_id"],
      id: json["id"],
      createdAt: DateTime.parse(json["created_at"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "youtube_id": youtubeId,
      "spotify_id": spotifyId,
      "id": id,
      "created_at": createdAt?.toString()
    }..removeWhere((key, value) => value == null);
  }
}
