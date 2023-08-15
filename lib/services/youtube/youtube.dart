import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:piped_client/piped_client.dart';
import 'package:spotube/collections/routes.dart';
import 'package:spotube/components/shared/dialogs/piped_down_dialog.dart';
import 'package:spotube/models/matched_track.dart';
import 'package:spotube/provider/user_preferences_provider.dart';
import 'package:spotube/utils/primitive_utils.dart';
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
}

class YoutubeEndpoints {
  PipedClient? piped;
  YoutubeExplode? youtube;

  final UserPreferences preferences;

  YoutubeEndpoints(this.preferences) {
    switch (preferences.youtubeApiType) {
      case YoutubeApiType.youtube:
        youtube = YoutubeExplode();
        break;
      case YoutubeApiType.piped:
        piped = PipedClient(instance: preferences.pipedInstance);
        break;
    }
  }

  Future<void> showPipedErrorDialog(Exception e) async {
    if (e is DioException && (e.response?.statusCode ?? 0) >= 500) {
      final context = rootNavigatorKey?.currentContext;
      if (context != null) {
        await showDialog(
          context: context,
          builder: (context) => const PipedDownDialog(),
        );
      }
    }
  }

  Future<List<YoutubeVideoInfo>> search(String query) async {
    if (youtube != null) {
      final res = await youtube!.search(
        query,
        filter: TypeFilters.video,
      );

      return res.map(YoutubeVideoInfo.fromVideo).toList();
    } else {
      try {
        final res = await piped!.search(
          query,
          switch (preferences.searchMode) {
            SearchMode.youtube => PipedFilter.video,
            SearchMode.youtubeMusic => PipedFilter.musicSongs,
          },
        );
        return res.items
            .whereType<PipedSearchItemStream>()
            .map(
              (e) => YoutubeVideoInfo.fromSearchItemStream(
                e,
                preferences.searchMode,
              ),
            )
            .toList();
      } on Exception catch (e) {
        await showPipedErrorDialog(e);
        rethrow;
      }
    }
  }

  String _pipedStreamResponseToStreamUrl(PipedStreamResponse stream) {
    return switch (preferences.audioQuality) {
      AudioQuality.high => stream
          .highestBitrateAudioStreamOfFormat(PipedAudioStreamFormat.m4a)!
          .url,
      AudioQuality.low => stream
          .lowestBitrateAudioStreamOfFormat(PipedAudioStreamFormat.m4a)!
          .url,
    };
  }

  Future<String> streamingUrl(String id) async {
    if (youtube != null) {
      final res = await PrimitiveUtils.raceMultiple(
        () => youtube!.videos.streams.getManifest(id),
      );
      final audioOnlyManifests = res.audioOnly.where((info) {
        return info.codec.mimeType == "audio/mp4";
      });

      return switch (preferences.audioQuality) {
        AudioQuality.high =>
          audioOnlyManifests.withHighestBitrate().url.toString(),
        AudioQuality.low =>
          audioOnlyManifests.sortByBitrate().last.url.toString(),
      };
    } else {
      return _pipedStreamResponseToStreamUrl(await piped!.streams(id));
    }
  }

  Future<(YoutubeVideoInfo info, String streamingUrl)> video(
    String id,
    SearchMode searchMode,
  ) async {
    if (youtube != null) {
      final res = await youtube!.videos.get(id);
      return (
        YoutubeVideoInfo.fromVideo(res),
        await streamingUrl(id),
      );
    } else {
      try {
        final res = await piped!.streams(id);
        return (
          YoutubeVideoInfo.fromStreamResponse(res, searchMode),
          _pipedStreamResponseToStreamUrl(res),
        );
      } on Exception catch (e) {
        await showPipedErrorDialog(e);
        rethrow;
      }
    }
  }
}
