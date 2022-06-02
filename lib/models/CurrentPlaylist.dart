import 'package:spotify/spotify.dart';

class CurrentPlaylist {
  List<Track>? _tempTrack;
  List<Track> tracks;
  String id;
  String name;
  String thumbnail;

  CurrentPlaylist({
    required this.tracks,
    required this.id,
    required this.name,
    required this.thumbnail,
  });

  List<String> get trackIds => tracks.map((e) => e.id!).toList();

  bool shuffle() {
    // won't shuffle if already shuffled
    if (_tempTrack == null) {
      _tempTrack = [...tracks];
      tracks.shuffle();
      return true;
    }
    return false;
  }

  bool unshuffle() {
    // without _tempTracks unshuffling can't be done
    if (_tempTrack != null) {
      tracks = [..._tempTrack!];
      _tempTrack = null;
      return true;
    }
    return false;
  }
}
