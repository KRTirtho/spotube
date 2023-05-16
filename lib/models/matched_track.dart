import "package:hive/hive.dart";

part "matched_track.g.dart";

@HiveType(typeId: 1)
class MatchedTrack {
  @HiveField(0)
  String youtubeId;
  @HiveField(1)
  String spotifyId;

  static const boxName = "oss.krtirtho.spotube.matched_tracks";

  static LazyBox<MatchedTrack> get box => Hive.lazyBox<MatchedTrack>(boxName);

  MatchedTrack({required this.youtubeId, required this.spotifyId});
}
