import 'dart:io';

import 'package:catcher_2/catcher_2.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/extensions/track.dart';
import 'package:spotube/models/local_track.dart';
import 'package:spotube/provider/server/server.dart';
import 'package:spotube/services/audio_player/custom_player.dart';
// import 'package:just_audio/just_audio.dart' as ja;
import 'dart:async';

import 'package:media_kit/media_kit.dart' as mk;

import 'package:spotube/services/audio_player/loop_mode.dart';
import 'package:spotube/services/audio_player/playback_state.dart';

part 'audio_players_streams_mixin.dart';
part 'audio_player_impl.dart';

class SpotubeMedia extends mk.Media {
  final Track track;

  SpotubeMedia(
    this.track, {
    Map<String, String>? extras,
    super.httpHeaders,
  }) : super(
          track is LocalTrack
              ? track.path
              : "http://${InternetAddress.loopbackIPv4.address}:${PlaybackServer.port}/stream/${track.id}",
          extras: {
            ...?extras,
            "track": track.toJson(),
          },
        );

  factory SpotubeMedia.fromMedia(mk.Media media) {
    final track = Track.fromJson(media.extras?["track"]);
    return SpotubeMedia(track);
  }
}

abstract class AudioPlayerInterface {
  final CustomPlayer _mkPlayer;
  // final ja.AudioPlayer? _justAudxio;

  AudioPlayerInterface()
      : _mkPlayer = CustomPlayer(
          configuration: const mk.PlayerConfiguration(
            title: "Spotube",
          ),
        )
  // _justAudio = !_mkSupportedPlatform ? ja.AudioPlayer() : null
  {
    _mkPlayer.stream.error.listen((event) {
      Catcher2.reportCheckedError(event, StackTrace.current);
    });
  }

  /// Whether the current platform supports the audioplayers plugin
  static const bool _mkSupportedPlatform = true;
  // DesktopTools.platform.isWindows || DesktopTools.platform.isLinux;

  bool get mkSupportedPlatform => _mkSupportedPlatform;

  Future<Duration?> get duration async {
    return _mkPlayer.state.duration;
    // if (mkSupportedPlatform) {
    // } else {
    //   return _justAudio!.duration;
    // }
  }

  Future<Duration?> get position async {
    return _mkPlayer.state.position;
    // if (mkSupportedPlatform) {
    // } else {
    //   return _justAudio!.position;
    // }
  }

  Future<Duration?> get bufferedPosition async {
    if (mkSupportedPlatform) {
      // audioplayers doesn't have the capability to get buffered position
      return null;
    } else {
      return null;
    }
  }

  Future<mk.AudioDevice> get selectedDevice async {
    return _mkPlayer.state.audioDevice;
  }

  Future<List<mk.AudioDevice>> get devices async {
    return _mkPlayer.state.audioDevices;
  }

  bool get hasSource {
    return _mkPlayer.state.playlist.medias.isNotEmpty;
    // if (mkSupportedPlatform) {
    //   return _mkPlayer.state.playlist.medias.isNotEmpty;
    // } else {
    //   return _justAudio!.audioSource != null;
    // }
  }

  // states
  bool get isPlaying {
    return _mkPlayer.state.playing;
    // if (mkSupportedPlatform) {
    //   return _mkPlayer.state.playing;
    // } else {
    //   return _justAudio!.playing;
    // }
  }

  bool get isPaused {
    return !_mkPlayer.state.playing;
    // if (mkSupportedPlatform) {
    //   return !_mkPlayer.state.playing;
    // } else {
    //   return !isPlaying;
    // }
  }

  bool get isStopped {
    return !hasSource;
    // if (mkSupportedPlatform) {
    // return !hasSource;
    // } else {
    //   return _justAudio!.processingState == ja.ProcessingState.idle;
    // }
  }

  Future<bool> get isCompleted async {
    return _mkPlayer.state.completed;
    // if (mkSupportedPlatform) {
    // return _mkPlayer.state.completed;
    // } else {
    //   return _justAudio!.processingState == ja.ProcessingState.completed;
    // }
  }

  Future<bool> get isShuffled async {
    return _mkPlayer.shuffled;
    // if (mkSupportedPlatform) {
    //   return _mkPlayer.shuffled;
    // } else {
    //   return _justAudio!.shuffleModeEnabled;
    // }
  }

  PlaybackLoopMode get loopMode {
    return PlaybackLoopMode.fromPlaylistMode(_mkPlayer.state.playlistMode);
    // if (mkSupportedPlatform) {
    //   return PlaybackLoopMode.fromPlaylistMode(_mkPlayer.loopMode);
    // } else {
    //   return PlaybackLoopMode.fromLoopMode(_justAudio!.loopMode);
    // }
  }

  /// Returns the current volume of the player, between 0 and 1
  double get volume {
    return _mkPlayer.state.volume / 100;
    // if (mkSupportedPlatform) {
    //   return _mkPlayer.state.volume / 100;
    // } else {
    //   return _justAudio!.volume;
    // }
  }

  bool get isBuffering {
    return false;
    // if (mkSupportedPlatform) {
    //   // audioplayers doesn't have the capability to get buffering state
    //   return false;
    // } else {
    //   return _justAudio!.processingState == ja.ProcessingState.buffering ||
    //       _justAudio!.processingState == ja.ProcessingState.loading;
    // }
  }
}
