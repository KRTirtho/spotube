import 'package:collection/collection.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/models/local_track.dart';
import 'package:spotube/services/sourced_track/sourced_track.dart';

class ProxyPlaylist {
  final Set<Track> tracks;
  final Set<String> collections;
  final int? active;

  ProxyPlaylist(this.tracks, [this.active, this.collections = const {}]);

  factory ProxyPlaylist.fromJson(
    Map<String, dynamic> json,
  ) {
    return ProxyPlaylist(
      List.castFrom<dynamic, Map<String, dynamic>>(
        json['tracks'] ?? <Map<String, dynamic>>[],
      ).map((t) => _makeAppropriateTrack(t)).toSet(),
      json['active'] as int?,
      json['collections'] == null
          ? {}
          : (json['collections'] as List).toSet().cast<String>(),
    );
  }

  factory ProxyPlaylist.fromJsonRaw(Map<String, dynamic> json) => ProxyPlaylist(
        json['tracks'] == null
            ? <Track>{}
            : (json['tracks'] as List).map((t) => Track.fromJson(t)).toSet(),
        json['active'] as int?,
        json['collections'] == null
            ? {}
            : (json['collections'] as List).toSet().cast<String>(),
      );

  Track? get activeTrack =>
      active == null || active == -1 ? null : tracks.elementAtOrNull(active!);

  bool get isFetching => activeTrack == null && tracks.isNotEmpty;

  bool containsCollection(String collection) {
    return collections.contains(collection);
  }

  bool containsTrack(TrackSimple track) {
    return tracks.firstWhereOrNull((element) {
          if (element is LocalTrack && track is LocalTrack) {
            return element.path == track.path;
          }

          return element.id == track.id;
        }) !=
        null;
  }

  bool containsTracks(Iterable<TrackSimple> tracks) {
    if (tracks.isEmpty) return false;
    return tracks.every(containsTrack);
  }

  static Track _makeAppropriateTrack(Map<String, dynamic> track) {
    if (track.containsKey("path")) {
      return LocalTrack.fromJson(track);
    } else {
      return Track.fromJson(track);
    }
  }

  /// To make sure proper instance method is used for JSON serialization
  /// Otherwise default super.toJson() is used
  static Map<String, dynamic> _makeAppropriateTrackJson(Track track) {
    return switch (track) {
      // ignore: unnecessary_cast
      LocalTrack() => (track as LocalTrack).toJson(),
      // ignore: unnecessary_cast
      SourcedTrack() => (track as SourcedTrack).toJson(),
      _ => track.toJson(),
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'tracks': tracks.map(_makeAppropriateTrackJson).toList(),
      'active': active,
      'collections': collections.toList(),
    };
  }

  ProxyPlaylist copyWith({
    Set<Track>? tracks,
    int? active,
    Set<String>? collections,
  }) {
    return ProxyPlaylist(
      tracks ?? this.tracks,
      active ?? this.active,
      collections ?? this.collections,
    );
  }
}
