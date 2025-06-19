import 'dart:io';

import 'package:media_kit/media_kit.dart' hide Track;
import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/models/playback/track_sources.dart';
import 'package:spotube/services/logger/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:spotube/services/audio_player/custom_player.dart';
import 'dart:async';

import 'package:media_kit/media_kit.dart' as mk;

import 'package:spotube/services/audio_player/playback_state.dart';
import 'package:spotube/utils/platform.dart';

part 'audio_players_streams_mixin.dart';
part 'audio_player_impl.dart';

class SpotubeMedia extends mk.Media {
  static int serverPort = 0;

  final SpotubeTrackObject track;

  static String get _host =>
      kIsWindows ? "localhost" : InternetAddress.anyIPv4.address;

  static String _queries(SpotubeFullTrackObject track) {
    final params = TrackSourceQuery.fromTrack(track).toJson();

    return params.entries
        .map((e) =>
            "${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}")
        .join("&");
  }

  SpotubeMedia(
    this.track, {
    Map<String, dynamic>? extras,
    super.httpHeaders,
  })  : assert(
          track is SpotubeLocalTrackObject || track is SpotubeFullTrackObject,
          "Track must be a either a local track or a full track object with ISRC",
        ),
        // If the track is a local track, use its path, otherwise use the server URL
        super(
          track is SpotubeLocalTrackObject
              ? track.path
              : "http://$_host:$serverPort/stream/${track.id}?${_queries(track as SpotubeFullTrackObject)}",
        );

  @override
  String get uri {
    return switch (track) {
      /// [super.uri] must be used instead of [track.path] to prevent wrong
      /// path format exceptions in Windows causing [extras] to be null
      SpotubeLocalTrackObject() => super.uri,
      _ => "http://$_host:"
          "$serverPort/stream/${track.id}",
    };
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
