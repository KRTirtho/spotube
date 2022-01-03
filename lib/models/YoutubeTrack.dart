import 'package:spotify/spotify.dart';

class YoutubeRelevantTrack {
  String url;
  double matchPercentage;
  bool sameChannel;
  String id;
  YoutubeRelevantTrack({
    required this.url,
    required this.matchPercentage,
    required this.sameChannel,
    required this.id,
  });
}
