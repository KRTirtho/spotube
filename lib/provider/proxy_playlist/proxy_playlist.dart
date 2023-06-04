import 'package:collection/collection.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/extensions/track.dart';
import 'package:spotube/models/local_track.dart';
import 'package:spotube/models/spotube_track.dart';

class ProxyPlaylist {
  final Set<Track> tracks;
  final int? active;

  ProxyPlaylist(this.tracks, [this.active]);
  factory ProxyPlaylist.fromJson(Map<String, dynamic> json) {
    return ProxyPlaylist(
      List.castFrom<dynamic, Map<String, dynamic>>(
        json['tracks'] ?? <Map<String, dynamic>>[],
      ).map(_makeAppropriateTrack).toSet(),
      json['active'] as int?,
    );
  }

  Track? get activeTrack =>
      active == null || active == -1 ? null : tracks.elementAtOrNull(active!);

  bool get isFetching =>
      activeTrack != null &&
      activeTrack is! SpotubeTrack &&
      activeTrack is! LocalTrack;

  bool containsTrack(TrackSimple track) {
    return tracks.firstWhereOrNull((element) => element.id == track.id) != null;
  }

  bool containsTracks(Iterable<TrackSimple> tracks) {
    if (tracks.isEmpty) return false;
    return tracks.every(containsTrack);
  }

  static Track _makeAppropriateTrack(Map<String, dynamic> track) {
    if (track.containsKey("ytUri")) {
      return SpotubeTrack.fromJson(track);
    } else if (track.containsKey("path")) {
      return LocalTrack.fromJson(track);
    } else {
      return Track.fromJson(track);
    }
  }

  static Map<String, dynamic> _makeAppropriateTrackJson(Track track) {
    if (track is LocalTrack) {
      return track.toJson();
    } else {
      return track.toJson();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'tracks': tracks.map(_makeAppropriateTrackJson).toList(),
      'active': active,
    };
  }

  ProxyPlaylist copyWith({
    Set<Track>? tracks,
    int? active,
  }) {
    return ProxyPlaylist(
      tracks ?? this.tracks,
      active ?? this.active,
    );
  }
}
