import 'package:spotube/models/playback/track_sources.dart';

class TrackNotFoundError extends Error {
  final TrackSourceQuery track;

  TrackNotFoundError(this.track);

  @override
  String toString() {
    return '[TrackNotFoundError] ${track.title} - ${track.artists.join(", ")}';
  }
}
