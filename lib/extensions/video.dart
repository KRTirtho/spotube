import 'dart:convert';

import 'package:catcher/catcher.dart';
import 'package:http/http.dart';
import 'package:spotube/entities/cache_track.dart';
import 'package:spotube/models/logger.dart';
import 'package:spotube/models/track.dart';
import 'package:spotube/provider/user_preferences_provider.dart';
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
      cacheTrack.uploadDate,
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

  static Future<Video> fromBackendTrack(
      BackendTrack track, YoutubeExplode youtube) {
    return youtube.videos.get(VideoId.fromString(track.youtubeId));
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
      map["uploadDate"],
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

extension GetSkipSegments on Video {
  Future<List<Map<String, int>>> getSkipSegments(
      UserPreferences preferences) async {
    if (!preferences.skipSponsorSegments) return [];
    try {
      final res = await get(Uri(
        scheme: "https",
        host: "sponsor.ajay.app",
        path: "/api/skipSegments",
        queryParameters: {
          "videoID": id.value,
          "category": [
            'sponsor',
            'selfpromo',
            'interaction',
            'intro',
            'outro',
            'music_offtopic'
          ],
          "actionType": 'skip'
        },
      ));

      if (res.body == "Not Found") {
        return List.castFrom<dynamic, Map<String, int>>([]);
      }

      final data = jsonDecode(res.body);
      final segments = data.map((obj) {
        return Map.castFrom<String, dynamic, String, int>({
          "start": obj["segment"].first.toInt(),
          "end": obj["segment"].last.toInt(),
        });
      }).toList();
      getLogger(Video).v(
        "[SponsorBlock] successfully fetched skip segments for $title | ${id.value}",
      );
      return List.castFrom<dynamic, Map<String, int>>(segments);
    } catch (e, stack) {
      Catcher.reportCheckedError(e, stack);
      return List.castFrom<dynamic, Map<String, int>>([]);
    }
  }
}
