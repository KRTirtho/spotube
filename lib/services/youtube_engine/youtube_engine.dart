import 'package:youtube_explode_dart/youtube_explode_dart.dart';

abstract interface class YouTubeEngine {
  static bool get isAvailableForPlatform => false;

  static Future<bool> isInstalled() async {
    return false;
  }

  Future<Video> getVideo(String videoId);
  Future<StreamManifest> getStreamManifest(String videoId);
  Future<(Video, StreamManifest)> getVideoWithStreamInfo(String videoId);
  Future<List<Video>> searchVideos(String query);

  void dispose();
}
