import 'package:spotube/services/youtube_engine/youtube_engine.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class YouTubeExplodeEngine implements YouTubeEngine {
  static final YoutubeExplode _youtubeExplode = YoutubeExplode();

  static bool get isAvailableForPlatform => true;

  static Future<bool> isInstalled() async {
    return true;
  }

  @override
  Future<StreamManifest> getStreamManifest(String videoId) async {
    final streamManifest =
        await _youtubeExplode.videos.streamsClient.getManifest(
      videoId,
      requireWatchPage: false,
      ytClients: [
        YoutubeApiClient.ios,
        YoutubeApiClient.android,
        YoutubeApiClient.mweb,
      ],
    );

    return StreamManifest(
      streamManifest.audioOnly.map((stream) {
        return AudioOnlyStreamInfo(
          stream.videoId,
          stream.tag,
          stream.url,
          stream.container,
          stream.size,
          stream.bitrate,
          stream.audioCodec,
          switch (stream.bitrate.bitsPerSecond) {
            > 130 * 1024 => "high",
            > 64 * 1024 => "medium",
            _ => "low",
          },
          stream.fragments,
          stream.codec,
          stream.audioTrack,
        );
      }),
    );
  }

  @override
  Future<Video> getVideo(String videoId) {
    return _youtubeExplode.videos.get(videoId);
  }

  @override
  Future<(Video, StreamManifest)> getVideoWithStreamInfo(String videoId) async {
    final video = await getVideo(videoId);
    final streamManifest = await getStreamManifest(videoId);

    return (video, streamManifest);
  }

  @override
  Future<List<Video>> searchVideos(String query) {
    return _youtubeExplode.search
        .search(
          query,
          filter: TypeFilters.video,
        )
        .then((searchList) => searchList.toList());
  }
}
