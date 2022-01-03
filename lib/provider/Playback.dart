import 'package:flutter/cupertino.dart';
import 'package:spotify/spotify.dart';

class CurrentPlaylist {
  List<Track> tracks;
  String id;
  String name;
  String thumbnail;
  CurrentPlaylist({
    required List<Track> this.tracks,
    required String this.id,
    required String this.name,
    required String this.thumbnail,
  });
}

class Playback extends ChangeNotifier {
  CurrentPlaylist? _currentPlaylist;
  Track? _currentTrack;
  Playback({CurrentPlaylist? currentPlaylist, Track? currentTrack}) {
    _currentPlaylist = currentPlaylist;
    _currentTrack = currentTrack;
  }

  CurrentPlaylist? get currentPlaylist => _currentPlaylist;
  Track? get currentTrack => _currentTrack;

  set setCurrentTrack(Track track) {
    _currentTrack = track;
    notifyListeners();
  }

  set setCurrentPlaylist(CurrentPlaylist playlist) {
    _currentPlaylist = playlist;
    notifyListeners();
  }

  reset() {
    _currentPlaylist = null;
    _currentTrack = null;
    notifyListeners();
  }
}

var x = Playback();
