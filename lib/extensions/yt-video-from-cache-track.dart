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
