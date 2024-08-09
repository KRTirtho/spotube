import 'dart:io';

import 'package:media_kit/media_kit.dart' hide Track;
import 'package:spotube/services/logger/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:spotify/spotify.dart' hide Playlist;
import 'package:spotube/models/local_track.dart';
import 'package:spotube/services/audio_player/custom_player.dart';
import 'dart:async';

import 'package:media_kit/media_kit.dart' as mk;

import 'package:spotube/services/audio_player/playback_state.dart';
import 'package:spotube/services/sourced_track/sourced_track.dart';
import 'package:spotube/utils/platform.dart';

part 'audio_players_streams_mixin.dart';
part 'audio_player_impl.dart';

class SpotubeMedia extends mk.Media {
  final Track track;

  static int serverPort = 0;

  SpotubeMedia(
    this.track, {
    Map<String, dynamic>? extras,
    super.httpHeaders,
  }) : super(
          track is LocalTrack
              ? track.path
              : "http://${kIsWindows ? "localhost" : InternetAddress.anyIPv4.address}:$serverPort/stream/${track.id}",
          extras: {
            ...?extras,
            "track": switch (track) {
              LocalTrack() => track.toJson(),
              SourcedTrack() => track.toJson(),
              _ => track.toJson(),
            },
          },
        );

  @override
  String get uri {
    return switch (track) {
      /// [super.uri] must be used instead of [track.path] to prevent wrong
      /// path format exceptions in Windows causing [extras] to be null
      LocalTrack() => super.uri,
      _ =>
        "http://${kIsWindows ? "localhost" : InternetAddress.anyIPv4.address}:"
            "$serverPort/stream/${track.id}",
    };
  }

  factory SpotubeMedia.fromMedia(mk.Media media) {
    final track = media.uri.startsWith("http")
        ? Track.fromJson(media.extras?["track"])
        : LocalTrack.fromJson(media.extras?["track"]);
    return SpotubeMedia(
      track,
      extras: media.extras,
      httpHeaders: media.httpHeaders,
    );
  }

  // @override
  // operator ==(Object other) {
  //   if (other is! SpotubeMedia) return false;

  //   final isLocal = track is LocalTrack && other.track is LocalTrack;
  //   return isLocal
  //       ? (other.track as LocalTrack).path == (track as LocalTrack).path
  //       : other.track.id == track.id;
  // }

  // @override
  // int get hashCode => track is LocalTrack
  //     ? (track as LocalTrack).path.hashCode
  //     : track.id.hashCode;
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
      AppLogger.reportError(event, StackTrace.current);
    });
  }

  /// Whether the current platform supports the audioplayers plugin
  static const bool _mkSupportedPlatform = true;

  bool get mkSupportedPlatform => _mkSupportedPlatform;

  Duration get duration {
    return _mkPlayer.state.duration;
  }

  Playlist get playlist {
    return _mkPlayer.state.playlist;
  }

  Duration get position {
    return _mkPlayer.state.position;
  }

  Duration get bufferedPosition {
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

  PlaylistMode get loopMode {
    return _mkPlayer.state.playlistMode;
  }

  /// Returns the current volume of the player, between 0 and 1
  double get volume {
    return _mkPlayer.state.volume / 100;
  }

  bool get isBuffering {
    return _mkPlayer.state.buffering;
  }
}
