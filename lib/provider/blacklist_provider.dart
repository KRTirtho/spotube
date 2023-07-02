import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/models/current_playlist.dart';
import 'package:spotube/utils/persisted_state_notifier.dart';

enum BlacklistedType {
  artist,
  track;

  static BlacklistedType fromName(String name) =>
      BlacklistedType.values.firstWhere((e) => e.name == name);
}

class BlacklistedElement {
  final String id;
  final String name;
  final BlacklistedType type;

  BlacklistedElement.artist(this.id, this.name) : type = BlacklistedType.artist;

  BlacklistedElement.track(this.id, this.name) : type = BlacklistedType.track;

  BlacklistedElement.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        type = BlacklistedType.fromName(json['type']);

  Map<String, dynamic> toJson() => {'id': id, 'type': type.name, 'name': name};

  @override
  operator ==(other) =>
      other is BlacklistedElement &&
      other.id == id &&
      other.type == type &&
      other.name == name;

  @override
  int get hashCode => id.hashCode ^ type.hashCode ^ name.hashCode;
}

class BlackListNotifier
    extends PersistedStateNotifier<Set<BlacklistedElement>> {
  BlackListNotifier() : super({}, "blacklist");

  static final provider =
      StateNotifierProvider<BlackListNotifier, Set<BlacklistedElement>>(
    (ref) => BlackListNotifier(),
  );

  void add(BlacklistedElement element) {
    state = state.union({element});
  }

  void remove(BlacklistedElement element) {
    state = state.difference({element});
  }

  bool contains(TrackSimple track) {
    final containsTrack =
        state.contains(BlacklistedElement.track(track.id!, track.name!));

    final containsTrackArtists = track.artists?.any(
          (artist) => state.contains(
            BlacklistedElement.artist(artist.id!, artist.name!),
          ),
        ) ??
        false;

    return containsTrack || containsTrackArtists;
  }

  /// Filters the non blacklisted tracks from the given [tracks]
  Iterable<TrackSimple> filter(Iterable<TrackSimple> tracks) {
    return tracks.whereNot(contains).toList();
  }

  CurrentPlaylist filterPlaylist(CurrentPlaylist playlist) {
    return CurrentPlaylist(
      id: playlist.id,
      name: playlist.name,
      thumbnail: playlist.thumbnail,
      tracks: playlist.tracks.where(
        (track) {
          return !state
                  .contains(BlacklistedElement.track(track.id!, track.name!)) &&
              !(track.artists ?? []).any(
                (artist) => state.contains(
                  BlacklistedElement.artist(artist.id!, artist.name!),
                ),
              );
        },
      ).toList(),
    );
  }

  @override
  Set<BlacklistedElement> fromJson(Map<String, dynamic> json) {
    return json['blacklist']
        .map<BlacklistedElement>((e) => BlacklistedElement.fromJson(e))
        .toSet();
  }

  @override
  Map<String, dynamic> toJson() {
    return {'blacklist': state.map((e) => e.toJson()).toList()};
  }
}
