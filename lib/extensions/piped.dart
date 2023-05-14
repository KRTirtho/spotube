import 'dart:convert';

import 'package:catcher/catcher.dart';
import 'package:http/http.dart';
import 'package:piped_client/piped_client.dart';
import 'package:spotube/entities/cache_track.dart';
import 'package:spotube/models/logger.dart';
import 'package:spotube/models/track.dart';
import 'package:spotube/provider/user_preferences_provider.dart';
import 'package:spotube/services/youtube.dart';
import 'package:spotube/utils/duration.dart';

extension PipedSearchItemExtension on PipedSearchItem {
  static PipedSearchItemStream fromCacheTrack(CacheTrack cacheTrack) {
    return PipedSearchItemStream(
      type: PipedSearchItemType.stream,
      url: "watch?v=${cacheTrack.id}",
      title: cacheTrack.title,
      uploaderName: cacheTrack.author,
      uploaderUrl: "/channel/${cacheTrack.channelId}",
      uploaded: -1,
      uploadedDate: cacheTrack.uploadDate ?? "",
      shortDescription: cacheTrack.description,
      isShort: false,
      thumbnail: "",
      duration: cacheTrack.duration != null
          ? tryParseDuration(cacheTrack.duration!) ?? Duration.zero
          : Duration.zero,
      uploaderAvatar: "",
      uploaderVerified: false,
      views: cacheTrack.engagement.viewCount,
    );
  }
}

extension PipedStreamResponseExtension on PipedStreamResponse {
  static Future<PipedStreamResponse> fromBackendTrack(
      BackendTrack track) async {
    return await PipedSpotube.client.streams(track.youtubeId);
  }
}
