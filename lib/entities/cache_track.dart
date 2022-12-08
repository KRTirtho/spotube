import 'package:hive/hive.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

part 'cache_track.g.dart';

@HiveType(typeId: 2)
class CacheTrackEngagement {
  @HiveField(0)
  late int viewCount;

  @HiveField(1)
  late int? likeCount;

  @HiveField(2)
  late int? dislikeCount;

  CacheTrackEngagement();

  CacheTrackEngagement.fromEngagement(Engagement engagement)
      : viewCount = engagement.viewCount,
        likeCount = engagement.likeCount,
        dislikeCount = engagement.dislikeCount;
}

@HiveType(typeId: 3)
class CacheTrackSkipSegment {
  @HiveField(0)
  late int start;
  @HiveField(1)
  late int end;

  CacheTrackSkipSegment();

  CacheTrackSkipSegment.fromJson(Map map)
      : start = map["start"].toInt(),
        end = map["end"].toInt();

  Map<String, int> toJson() {
    return Map.castFrom<String, dynamic, String, int>(
        {"start": start, "end": end});
  }
}

@HiveType(typeId: 1)
class CacheTrack extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String title;

  @HiveField(2)
  late String channelId;

  @HiveField(3)
  late String? uploadDate;

  @HiveField(4)
  late String? publishDate;

  @HiveField(5)
  late String description;

  @HiveField(6)
  late String? duration;

  @HiveField(7)
  late List<String>? keywords;

  @HiveField(8)
  late CacheTrackEngagement engagement;

  @HiveField(9)
  late String mode;

  @HiveField(10)
  late String author;

  @HiveField(11)
  late List<CacheTrackSkipSegment>? skipSegments;

  CacheTrack();

  CacheTrack.fromVideo(
    Video video,
    this.mode, {
    required List<Map<String, int>> skipSegments,
  })  : id = video.id.value,
        title = video.title,
        author = video.author,
        channelId = video.channelId.value,
        uploadDate = video.uploadDate.toString(),
        publishDate = video.publishDate.toString(),
        description = video.description,
        duration = video.duration.toString(),
        keywords = video.keywords,
        engagement = CacheTrackEngagement.fromEngagement(video.engagement),
        skipSegments = skipSegments
            .map((segment) => CacheTrackSkipSegment.fromJson(segment))
            .toList();
}
