import 'package:media_kit/media_kit.dart' hide Track;
import 'package:spotify/spotify.dart' hide Playlist;
import 'package:spotube/services/audio_player/audio_player.dart';

class AudioPlayerState {
  final bool playing;
  final PlaylistMode loopMode;
  final bool shuffled;
  final Playlist playlist;

  final List<Track> tracks;
  final List<String> collections;

  AudioPlayerState({
    required this.playing,
    required this.loopMode,
    required this.shuffled,
    required this.playlist,
    required this.collections,
    List<Track>? tracks,
  }) : tracks = tracks ??
            playlist.medias
                .map((media) => SpotubeMedia.fromMedia(media).track)
                .toList();

  factory AudioPlayerState.fromJson(Map<String, dynamic> json) {
    return AudioPlayerState(
      playing: json['playing'],
      loopMode: PlaylistMode.values.firstWhere(
        (e) => e.name == json['loopMode'],
        orElse: () => audioPlayer.loopMode,
      ),
      shuffled: json['shuffled'],
      playlist: Playlist(
        json['playlist']['medias']
            .map(
              (media) => SpotubeMedia.fromMedia(Media(
                media['uri'],
                extras: media['extras'],
                httpHeaders: media['httpHeaders'],
              )),
            )
            .cast<Media>()
            .toList(),
        index: json['playlist']['index'],
      ),
      collections: List<String>.from(json['collections']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'playing': playing,
      'loopMode': loopMode.name,
      'shuffled': shuffled,
      'playlist': {
        'medias': playlist.medias
            .map((media) => {
                  'uri': media.uri,
                  'extras': media.extras,
                  'httpHeaders': media.httpHeaders,
                })
            .toList(),
        'index': playlist.index,
      },
      'collections': collections,
    };
  }

  AudioPlayerState copyWith({
    bool? playing,
    PlaylistMode? loopMode,
    bool? shuffled,
    Playlist? playlist,
    List<String>? collections,
  }) {
    return AudioPlayerState(
      playing: playing ?? this.playing,
      loopMode: loopMode ?? this.loopMode,
      shuffled: shuffled ?? this.shuffled,
      playlist: playlist ?? this.playlist,
      collections: collections ?? this.collections,
      tracks: playlist == null ? tracks : null,
    );
  }

  Track? get activeTrack {
    if (playlist.index == -1) return null;
    return tracks.elementAtOrNull(playlist.index);
  }

  Media? get activeMedia {
    if (playlist.index == -1 || playlist.medias.isEmpty) return null;
    return playlist.medias.elementAt(playlist.index);
  }

  bool containsTrack(Track track) {
    return tracks.any((t) => t.id == track.id);
  }

  bool containsTracks(List<Track> tracks) {
    return tracks.every(containsTrack);
  }

  bool containsCollection(String collectionId) {
    return collections.contains(collectionId);
  }
}
