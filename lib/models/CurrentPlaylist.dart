import 'package:spotify/spotify.dart';

extension AlbumJson on AlbumSimple {
  Map<String, dynamic> toJson() {
    return {
      "albumType": albumType,
      "id": id,
      "name": name,
      "images": images
          ?.map((image) => {
                "height": image.height,
                "url": image.url,
                "width": image.width,
              })
          .toList(),
    };
  }
}

extension ArtistJson on ArtistSimple {
  Map<String, dynamic> toJson() {
    return {
      "href": href,
      "id": id,
      "name": name,
      "type": type,
      "uri": uri,
    };
  }
}

extension TrackJson on Track {
  Map<String, dynamic> toJson() {
    return {
      "album": album?.toJson(),
      "artists": artists?.map((artist) => artist.toJson()).toList(),
      "availableMarkets": availableMarkets,
      "discNumber": discNumber,
      "duration": duration.toString(),
      "durationMs": durationMs,
      "explicit": explicit,
      // "externalIds": externalIds,
      // "externalUrls": externalUrls,
      "href": href,
      "id": id,
      "isPlayable": isPlayable,
      // "linkedFrom": linkedFrom,
      "name": name,
      "popularity": popularity,
      "previewUrl": previewUrl,
      "trackNumber": trackNumber,
      "type": type,
      "uri": uri,
    };
  }
}

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

  static CurrentPlaylist fromJson(Map<String, dynamic> map) {
    return CurrentPlaylist(
      id: map["id"],
      tracks: List.castFrom<dynamic, Track>(
          map["tracks"].map((track) => Track.fromJson(track)).toList()),
      name: map["name"],
      thumbnail: map["thumbnail"],
    );
  }

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

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "tracks": tracks.map((track) => track.toJson()).toList(),
      "thumbnail": thumbnail,
    };
  }
}
