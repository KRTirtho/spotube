import 'package:invidious/invidious.dart';
import 'package:piped_client/piped_client.dart';
import 'package:spotube/models/database/database.dart';

import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class YoutubeVideoInfo {
  final SearchMode searchMode;
  final String title;
  final Duration duration;
  final String thumbnailUrl;
  final String id;
  final int likes;
  final int dislikes;
  final int views;
  final String channelName;
  final String channelId;
  final DateTime publishedAt;

  YoutubeVideoInfo({
    required this.searchMode,
    required this.title,
    required this.duration,
    required this.thumbnailUrl,
    required this.id,
    required this.likes,
    required this.dislikes,
    required this.views,
    required this.channelName,
    required this.publishedAt,
    required this.channelId,
  });

  YoutubeVideoInfo.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        searchMode = SearchMode.fromString(json['searchMode']),
        duration = Duration(seconds: json['duration']),
        thumbnailUrl = json['thumbnailUrl'],
        id = json['id'],
        likes = json['likes'],
        dislikes = json['dislikes'],
        views = json['views'],
        channelName = json['channelName'],
        channelId = json['channelId'],
        publishedAt = DateTime.tryParse(json['publishedAt']) ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'title': title,
        'duration': duration.inSeconds,
        'thumbnailUrl': thumbnailUrl,
        'id': id,
        'likes': likes,
        'dislikes': dislikes,
        'views': views,
        'channelName': channelName,
        'channelId': channelId,
        'publishedAt': publishedAt.toIso8601String(),
        'searchMode': searchMode.name,
      };

  factory YoutubeVideoInfo.fromVideo(Video video) {
    return YoutubeVideoInfo(
      searchMode: SearchMode.youtube,
      title: video.title,
      duration: video.duration ?? Duration.zero,
      thumbnailUrl: video.thumbnails.mediumResUrl,
      id: video.id.value,
      likes: video.engagement.likeCount ?? 0,
      dislikes: video.engagement.dislikeCount ?? 0,
      views: video.engagement.viewCount,
      channelName: video.author,
      channelId: '/c/${video.channelId.value}',
      publishedAt: video.uploadDate ?? DateTime(2003, 9, 9),
    );
  }

  factory YoutubeVideoInfo.fromSearchItemStream(
    PipedSearchItemStream searchItem,
    SearchMode searchMode,
  ) {
    return YoutubeVideoInfo(
      searchMode: searchMode,
      title: searchItem.title,
      duration: searchItem.duration,
      thumbnailUrl: searchItem.thumbnail,
      id: searchItem.id,
      likes: 0,
      dislikes: 0,
      views: searchItem.views,
      channelName: searchItem.uploaderName,
      channelId: searchItem.uploaderUrl ?? "",
      publishedAt: searchItem.uploadedDate != null
          ? DateTime.tryParse(searchItem.uploadedDate!) ?? DateTime(2003, 9, 9)
          : DateTime(2003, 9, 9),
    );
  }

  factory YoutubeVideoInfo.fromStreamResponse(
      PipedStreamResponse stream, SearchMode searchMode) {
    return YoutubeVideoInfo(
      searchMode: searchMode,
      title: stream.title,
      duration: stream.duration,
      thumbnailUrl: stream.thumbnailUrl,
      id: stream.id,
      likes: stream.likes,
      dislikes: stream.dislikes,
      views: stream.views,
      channelName: stream.uploader,
      publishedAt: stream.uploadedDate != null
          ? DateTime.tryParse(stream.uploadedDate!) ?? DateTime(2003, 9, 9)
          : DateTime(2003, 9, 9),
      channelId: stream.uploaderUrl,
    );
  }

  factory YoutubeVideoInfo.fromSearchResponse(
    InvidiousSearchResponseVideo searchResponse,
    SearchMode searchMode,
  ) {
    return YoutubeVideoInfo(
      searchMode: searchMode,
      title: searchResponse.title,
      duration: Duration(seconds: searchResponse.lengthSeconds),
      thumbnailUrl: searchResponse.videoThumbnails.first.url,
      id: searchResponse.videoId,
      likes: 0,
      dislikes: 0,
      views: searchResponse.viewCount,
      channelName: searchResponse.author,
      channelId: searchResponse.authorId,
      publishedAt:
          DateTime.fromMillisecondsSinceEpoch(searchResponse.published * 1000),
    );
  }
}
