import 'package:spotify/spotify.dart';

class TrackNotFoundError extends Error {
  final Track track;

  TrackNotFoundError(this.track);

  @override
  String toString() {
    return '[TrackNotFoundError] ${track.name} - ${track.artists?.map((e) => e.name).join(", ")}';
  }
}
