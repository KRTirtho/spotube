import 'package:flutter_new_pipe_extractor/flutter_new_pipe_extractor.dart'
    hide Engagement;
import 'package:spotube/services/youtube_engine/youtube_engine.dart';
import 'package:spotube/utils/platform.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:http_parser/http_parser.dart';

class NewPipeEngine implements YouTubeEngine {
  static bool get isAvailableForPlatform => kIsAndroid || kIsDesktop;

  AudioOnlyStreamInfo _parseAudioStream(AudioStream stream, String videoId) {
    return AudioOnlyStreamInfo(
      VideoId(videoId),
      stream.itag,
      Uri.parse(stream.content),
      StreamContainer.parse(stream.mediaFormat!.mimeType.split("/").last),
      FileSize.unknown,
      Bitrate(stream.bitrate),
      stream.codec,
      switch (stream.bitrate) {
        > 130 * 1024 => "high",
        > 64 * 1024 => "medium",
        _ => "low",
      },
      [],
      MediaType.parse(stream.mediaFormat!.mimeType),
      null,
    );
  }

  Video _parseVideo(VideoInfo info) {
    return Video(
      VideoId(info.id),
      info.name,
      info.uploaderName,
      ChannelId(info.uploaderUrl),
      info.uploadDate.offsetDateTime,
      info.uploadDate.offsetDateTime.toString(),
      info.uploadDate.offsetDateTime,
      info.description.content ?? "",
      Duration(seconds: info.duration),
      ThumbnailSet(info.id),
      info.tags,
      Engagement(
        info.viewCount,
        info.likeCount,
        info.dislikeCount,
      ),
      !info.streamType.name.toLowerCase().contains("live"),
    );
  }

  Video _parseVideoResult(VideoSearchResultItem info) {
    final id = Uri.parse(info.url).queryParameters["v"]!;
    return Video(
      VideoId(id),
      info.name,
      info.uploaderName,
      ChannelId(info.uploaderUrl),
      info.uploadDate?.offsetDateTime,
      info.uploadDate?.offsetDateTime.toString(),
      info.uploadDate?.offsetDateTime,
      info.shortDescription ?? "",
      Duration(seconds: info.duration),
      ThumbnailSet(id),
      [],
      Engagement(info.viewCount, null, null),
      !info.streamType.name.toLowerCase().contains("live"),
    );
  }

  @override
  Future<StreamManifest> getStreamManifest(String videoId) async {
    final video = await NewPipeExtractor.getVideoInfo(videoId);

    final streams =
        video.audioStreams.map((stream) => _parseAudioStream(stream, videoId));

    return StreamManifest(streams);
  }

  @override
  Future<Video> getVideo(String videoId) async {
    final video = await NewPipeExtractor.getVideoInfo(videoId);

    return _parseVideo(video);
  }

  @override
  Future<(Video, StreamManifest)> getVideoWithStreamInfo(String videoId) async {
    final video = await NewPipeExtractor.getVideoInfo(videoId);

    final streams =
        video.audioStreams.map((stream) => _parseAudioStream(stream, videoId));

    return (_parseVideo(video), StreamManifest(streams));
  }

  @override
  Future<List<Video>> searchVideos(String query) async {
    final results = await NewPipeExtractor.search(
      query,
      contentFilters: [SearchContentFilters.videos],
    );

    final resultsWithVideos = results
        .whereType<VideoSearchResultItem>()
        .map((e) => _parseVideoResult(e))
        .toList();

    return resultsWithVideos;
  }

  @override
  void dispose() {}
}
