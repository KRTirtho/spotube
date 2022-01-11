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

  List<String> get trackIds => tracks.map((e) => e.id!).toList();
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

  /// sets the provided id matched track's uri\
  /// Doesn't notify listeners\
  /// @returns `bool` - `true` if succeed & `false` when failed
  bool setTrackUriById(String id, String uri) {
    if (_currentPlaylist == null) return false;
    try {
      int index =
          _currentPlaylist!.tracks.indexWhere((element) => element.id == id);
      if (index == -1) return false;
      _currentPlaylist!.tracks[index].uri = uri;
      return _currentPlaylist!.tracks[index].uri == uri;
    } catch (e) {
      return false;
    }
  }
}

var x = Playback();
