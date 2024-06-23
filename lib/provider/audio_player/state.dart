import 'package:media_kit/media_kit.dart' hide Track;
import 'package:spotify/spotify.dart' hide Playlist;
import 'package:spotube/services/audio_player/audio_player.dart';

class AudioPlayerState {
  final bool playing;
  final double volume;
  final PlaylistMode loopMode;
  final bool shuffled;
  final Playlist playlist;

  final List<Track> tracks;

  AudioPlayerState({
    required this.playing,
    required this.volume,
    required this.loopMode,
    required this.shuffled,
    required this.playlist,
    List<Track>? tracks,
  }) : tracks = tracks ??
            playlist.medias
                .map((media) => SpotubeMedia.fromMedia(media).track)
                .toList();

  AudioPlayerState copyWith({
    bool? playing,
    double? volume,
    PlaylistMode? loopMode,
    bool? shuffled,
    Playlist? playlist,
  }) {
    return AudioPlayerState(
      playing: playing ?? this.playing,
      volume: volume ?? this.volume,
      loopMode: loopMode ?? this.loopMode,
      shuffled: shuffled ?? this.shuffled,
      playlist: playlist ?? this.playlist,
      tracks: playlist == null ? tracks : null,
    );
  }
}
