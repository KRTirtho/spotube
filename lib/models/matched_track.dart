import "package:hive/hive.dart";
part "matched_track.g.dart";

@HiveType(typeId: 1)
class MatchedTrack {
  @HiveField(0)
  String youtubeId;
  @HiveField(1)
  String spotifyId;
  @HiveField(2)
  SearchMode searchMode;

  String? id;
  DateTime? createdAt;

  bool get isSynced => id != null;

  static const boxName = "oss.krtirtho.spotube.matched_tracks";

  static LazyBox<MatchedTrack> get box => Hive.lazyBox<MatchedTrack>(boxName);

  MatchedTrack({
    required this.youtubeId,
    required this.spotifyId,
    required this.searchMode,
    this.id,
    this.createdAt,
  });

  factory MatchedTrack.fromJson(Map<String, dynamic> json) {
    return MatchedTrack(
      searchMode: SearchMode.fromString(json["searchMode"]),
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
      "searchMode": searchMode.name,
      "created_at": createdAt?.toString()
    }..removeWhere((key, value) => value == null);
  }
}

@HiveType(typeId: 4)
enum SearchMode {
  @HiveField(0)
  youtube._internal('YouTube'),
  @HiveField(1)
  youtubeMusic._internal('YouTube Music');

  final String label;

  const SearchMode._internal(this.label);

  factory SearchMode.fromString(String value) {
    return SearchMode.values.firstWhere(
      (element) => element.name == value,
      orElse: () => SearchMode.youtube,
    );
  }
}
