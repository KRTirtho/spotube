import 'package:piped_client/piped_client.dart';
import 'package:spotube/models/track.dart';
import 'package:spotube/services/youtube.dart';

extension PipedStreamResponseExtension on PipedStreamResponse {
  static Future<PipedStreamResponse> fromBackendTrack(
      BackendTrack track) async {
    return await PipedSpotube.client.streams(track.youtubeId);
  }
}
