import 'package:spotify/spotify.dart';

class TrackNotFoundException implements Exception {
  factory TrackNotFoundException(Track track) {
    throw Exception("Failed to find any results for ${track.name}");
  }
}
