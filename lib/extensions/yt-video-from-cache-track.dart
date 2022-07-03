import 'package:spotube/entities/CacheTrack.dart';
import 'package:spotube/utils/duration.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

extension VideoFromCacheTrackExtension on Video {
  static Video fromCacheTrack(CacheTrack cacheTrack) {
    return Video(
      VideoId.fromString(cacheTrack.id),
      cacheTrack.title,
      cacheTrack.author,
      ChannelId.fromString(cacheTrack.channelId),
      cacheTrack.uploadDate != null
          ? DateTime.tryParse(cacheTrack.uploadDate!)
          : null,
      cacheTrack.publishDate != null
          ? DateTime.tryParse(cacheTrack.publishDate!)
          : null,
      cacheTrack.description,
      cacheTrack.duration != null
          ? tryParseDuration(cacheTrack.duration!)
          : null,
      ThumbnailSet(cacheTrack.id),
      cacheTrack.keywords,
      Engagement(
        cacheTrack.engagement.viewCount,
        cacheTrack.engagement.likeCount,
        cacheTrack.engagement.dislikeCount,
      ),
      false,
    );
  }
}

extension ThumbnailSetJson on ThumbnailSet {
  static ThumbnailSet fromJson(Map<String, dynamic> map) {
    return ThumbnailSet(map["videoId"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "videoId": videoId,
    };
  }
}

extension EngagementJson on Engagement {
  static Engagement fromJson(Map<String, dynamic> map) {
    return Engagement(
      map["viewCount"],
      map["likeCount"],
      map["dislikeCount"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "dislikeCount": dislikeCount,
      "likeCount": likeCount,
      "viewCount": viewCount,
    };
  }
}

extension VideoToJson on Video {
  static Video fromJson(Map<String, dynamic> map) {
    return Video(
      VideoId(map["id"]),
      map["title"],
      map["author"],
      ChannelId(map["channelId"]),
      DateTime.tryParse(map["uploadDate"]),
      DateTime.tryParse(map["publishDate"]),
      map["description"],
      parseDuration(map["duration"]),
      ThumbnailSetJson.fromJson(map["thumbnails"]),
      List.castFrom<dynamic, String>(map["keywords"]),
      EngagementJson.fromJson(map["engagement"]),
      map["isLive"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "hasWatchPage": hasWatchPage,
      "url": url,
      "author": author,
      "channelId": channelId.value,
      "description": description,
      "duration": duration.toString(),
      "engagement": engagement.toJson(),
      "id": id.value,
      "isLive": isLive,
      "keywords": keywords.toList(),
      "publishDate": publishDate.toString(),
      "thumbnails": thumbnails.toJson(),
      "title": title,
      "uploadDate": uploadDate.toString(),
    };
  }
}
