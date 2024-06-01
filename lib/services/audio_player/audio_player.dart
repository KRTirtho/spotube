import 'dart:io';

import 'package:catcher_2/catcher_2.dart';
import 'package:flutter/foundation.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/models/local_track.dart';
import 'package:spotube/provider/server/server.dart';
import 'package:spotube/services/audio_player/custom_player.dart';
import 'dart:async';

import 'package:media_kit/media_kit.dart' as mk;

import 'package:spotube/services/audio_player/loop_mode.dart';
import 'package:spotube/services/audio_player/playback_state.dart';
import 'package:spotube/services/sourced_track/sourced_track.dart';

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
            "track": switch (track) {
              LocalTrack() => track.toJson(),
              SourcedTrack() => track.toJson(),
              _ => track.toJson(),
            },
          },
        );

  factory SpotubeMedia.fromMedia(mk.Media media) {
    final track = media.uri.startsWith("http")
        ? Track.fromJson(media.extras?["track"])
        : LocalTrack.fromJson(media.extras?["track"]);
    return SpotubeMedia(track);
  }
}

abstract class AudioPlayerInterface {
  final CustomPlayer _mkPlayer;

  AudioPlayerInterface()
      : _mkPlayer = CustomPlayer(
          configuration: const mk.PlayerConfiguration(
            title: "Spotube",
            logLevel: kDebugMode ? mk.MPVLogLevel.info : mk.MPVLogLevel.error,
          ),
        ) {
    _mkPlayer.stream.error.listen((event) {
      Catcher2.reportCheckedError(event, StackTrace.current);
    });
  }

  /// Whether the current platform supports the audioplayers plugin
  static const bool _mkSupportedPlatform = true;

  bool get mkSupportedPlatform => _mkSupportedPlatform;

  Future<Duration?> get duration async {
    return _mkPlayer.state.duration;
  }

  Future<Duration?> get position async {
    return _mkPlayer.state.position;
  }

  Future<Duration?> get bufferedPosition async {
    return _mkPlayer.state.buffer;
  }

  Future<mk.AudioDevice> get selectedDevice async {
    return _mkPlayer.state.audioDevice;
  }

  Future<List<mk.AudioDevice>> get devices async {
    return _mkPlayer.state.audioDevices;
  }

  bool get hasSource {
    return _mkPlayer.state.playlist.medias.isNotEmpty;
  }

  // states
  bool get isPlaying {
    return _mkPlayer.state.playing;
  }

  bool get isPaused {
    return !_mkPlayer.state.playing;
  }

  bool get isStopped {
    return !hasSource;
  }

  Future<bool> get isCompleted async {
    return _mkPlayer.state.completed;
  }

  bool get isShuffled {
    return _mkPlayer.shuffled;
  }

  PlaybackLoopMode get loopMode {
    return PlaybackLoopMode.fromPlaylistMode(_mkPlayer.state.playlistMode);
  }

  /// Returns the current volume of the player, between 0 and 1
  double get volume {
    return _mkPlayer.state.volume / 100;
  }

  bool get isBuffering {
    return _mkPlayer.state.buffering;
  }
}
