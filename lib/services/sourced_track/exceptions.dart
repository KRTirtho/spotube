import 'package:spotube/models/metadata/metadata.dart';

class TrackNotFoundError extends Error {
  final SpotubeTrackObject track;

  TrackNotFoundError(this.track);

  @override
  String toString() {
    return '[TrackNotFoundError] ${track.name} - ${track.artists.join(", ")}';
  }
}
