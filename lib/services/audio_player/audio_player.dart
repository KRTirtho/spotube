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

// Constants class for shared constants like port and addresses
class Constants {
  static const defaultServerPort = 8080;
  static const defaultLocalHost = "localhost";
}

// Helper to get network address based on the platform
String getNetworkAddress() {
  return kIsWindows ? Constants.defaultLocalHost : InternetAddress.anyIPv4.address;
}

// Helper to get URI for a given track
String getUriForTrack(Track track, int serverPort) {
  return track is LocalTrack
      ? track.path
      : "http://${getNetworkAddress()}:$serverPort/stream/${track.id}";
}

// SpotubeMedia class handling media creation logic
class SpotubeMedia extends mk.Media {
  final Track track;
  static int serverPort = Constants.defaultServerPort;

  SpotubeMedia(this.track, {Map<String, dynamic>? extras, super.httpHeaders})
      : super(
          getUriForTrack(track, serverPort),
          extras: {
            ...?extras,
            "track": track.toJson(),
          },
        );

  @override
  String get uri => getUriForTrack(track, serverPort);

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
}

// Factory class to create SpotubeMedia instances
class SpotubeMediaFactory {
  static SpotubeMedia create(Track track, {Map<String, dynamic>? extras, Map<String, String>? headers}) {
    return SpotubeMedia(track, extras: extras, httpHeaders: headers);
  }
}

// Playback state management class
class PlaybackStateManager {
  final CustomPlayer player;

  PlaybackStateManager(this.player);

  bool get isPlaying => player.state.playing;
  bool get isPaused => !player.state.playing;
  bool get isStopped => player.state.playlist.medias.isEmpty;

  Duration get duration => player.state.duration;
  Duration get position => player.state.position;
  Duration get bufferedPosition => player.state.buffer;
  bool get isShuffled => player.shuffled;
  double get volume => player.state.volume / 100;

  Future<List<mk.AudioDevice>> get devices async => player.state.audioDevices;
  Future<mk.AudioDevice> get selectedDevice async => player.state.audioDevice;

  PlaylistMode get loopMode => player.state.playlistMode;
}

// Main AudioPlayerInterface class with DI and error handling
abstract class AudioPlayerInterface {
  final CustomPlayer player;
  final PlaybackStateManager stateManager;

  AudioPlayerInterface(this.player)
      : stateManager = PlaybackStateManager(player) {
    player.stream.error.listen((event) {
      AppLogger.reportError(event, StackTrace.current);
      // Retry or fallback mechanism can be added here
    });
  }

  // High-level control methods for playback
  Future<void> play() async {
    try {
      await player.play();
    } catch (e) {
      AppLogger.reportError(e, StackTrace.current);
    }
  }

  Future<void> pause() async {
    try {
      await player.pause();
    } catch (e) {
      AppLogger.reportError(e, StackTrace.current);
    }
  }

  Future<void> stop() async {
    try {
      await player.stop();
    } catch (e) {
      AppLogger.reportError(e, StackTrace.current);
    }
  }

  Future<void> seek(Duration position) async {
    try {
      await player.seek(position);
    } catch (e) {
      AppLogger.reportError(e, StackTrace.current);
    }
  }

  // Access state information through the state manager
  bool get isPlaying => stateManager.isPlaying;
  bool get isPaused => stateManager.isPaused;
  bool get isStopped => stateManager.isStopped;
  Duration get duration => stateManager.duration;
  Duration get position => stateManager.position;
  Duration get bufferedPosition => stateManager.bufferedPosition;
  bool get isShuffled => stateManager.isShuffled;
  double get volume => stateManager.volume;
  Future<List<mk.AudioDevice>> get devices => stateManager.devices;
  Future<mk.AudioDevice> get selectedDevice => stateManager.selectedDevice;
  PlaylistMode get loopMode => stateManager.loopMode;
}

// Example implementation for a specific platform/player
class MyAudioPlayer extends AudioPlayerInterface {
  MyAudioPlayer(CustomPlayer player) : super(player);

  // Additional functionality can be added here if necessary
}
