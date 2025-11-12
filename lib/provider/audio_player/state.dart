import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:media_kit/media_kit.dart' hide Track;
import 'package:spotube/models/metadata/metadata.dart';

part 'state.freezed.dart';
part 'state.g.dart';

@freezed
class AudioPlayerState with _$AudioPlayerState {
  const AudioPlayerState._();

  factory AudioPlayerState._inner({
    required bool playing,
    required PlaylistMode loopMode,
    required bool shuffled,
    required List<String> collections,
    @Default(0) int currentIndex,
    @Default([]) List<SpotubeTrackObject> tracks,
  }) = _AudioPlayerState;

  factory AudioPlayerState({
    required bool playing,
    required PlaylistMode loopMode,
    required bool shuffled,
    required List<String> collections,
    int currentIndex = 0,
    List<SpotubeTrackObject> tracks = const [],
  }) {
    assert(
      tracks.every((track) =>
          track is SpotubeFullTrackObject || track is SpotubeLocalTrackObject),
      'All tracks must be either SpotubeFullTrackObject or SpotubeLocalTrackObject',
    );

    return AudioPlayerState._inner(
      playing: playing,
      loopMode: loopMode,
      shuffled: shuffled,
      currentIndex: currentIndex,
      tracks: tracks,
      collections: collections,
    );
  }

  factory AudioPlayerState.fromJson(Map<String, dynamic> json) =>
      _$AudioPlayerStateFromJson(json);

  SpotubeTrackObject? get activeTrack {
    if (currentIndex < 0 || currentIndex >= tracks.length) return null;
    return tracks[currentIndex];
  }

  bool containsTrack(SpotubeTrackObject track) {
    return tracks.isNotEmpty &&
        tracks.any(
          (t) =>
              t is SpotubeLocalTrackObject && track is SpotubeLocalTrackObject
                  ? t.path == track.path
                  : t.id == track.id,
        );
  }

  bool containsTracks(List<SpotubeTrackObject> tracks) {
    return this.tracks.isNotEmpty && tracks.every(containsTrack);
  }

  bool containsCollection(String collectionId) {
    return collections.contains(collectionId);
  }
}
