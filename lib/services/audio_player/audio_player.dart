import 'package:catcher/catcher.dart';
import 'package:flutter_desktop_tools/flutter_desktop_tools.dart';
import 'package:spotube/services/audio_player/mk_state_player.dart';
import 'package:just_audio/just_audio.dart' as ja;
import 'dart:async';

import 'package:media_kit/media_kit.dart' as mk;

import 'package:spotube/models/spotube_track.dart';
import 'package:spotube/services/audio_player/loop_mode.dart';
import 'package:spotube/services/audio_player/playback_state.dart';

part 'audio_players_streams_mixin.dart';
part 'audio_player_impl.dart';

abstract class AudioPlayerInterface {
  final MkPlayerWithState? _mkPlayer;
  final ja.AudioPlayer? _justAudio;

  AudioPlayerInterface()
      : _mkPlayer = _mkSupportedPlatform ? MkPlayerWithState() : null,
        _justAudio = !_mkSupportedPlatform ? ja.AudioPlayer() : null {
    _mkPlayer?.streams.error.listen((event) {
      Catcher.reportCheckedError(event, StackTrace.current);
    });
  }

  /// Whether the current platform supports the audioplayers plugin
  static final bool _mkSupportedPlatform =
      DesktopTools.platform.isWindows || DesktopTools.platform.isLinux;

  bool get mkSupportedPlatform => _mkSupportedPlatform;

  Future<Duration?> get duration async {
    if (mkSupportedPlatform) {
      return _mkPlayer!.state.duration;
    } else {
      return _justAudio!.duration;
    }
  }

  Future<Duration?> get position async {
    if (mkSupportedPlatform) {
      return _mkPlayer!.state.position;
    } else {
      return _justAudio!.position;
    }
  }

  Future<Duration?> get bufferedPosition async {
    if (mkSupportedPlatform) {
      // audioplayers doesn't have the capability to get buffered position
      return null;
    } else {
      return null;
    }
  }

  bool get hasSource {
    if (mkSupportedPlatform) {
      return _mkPlayer!.playlist.medias.isNotEmpty;
    } else {
      return _justAudio!.audioSource != null;
    }
  }

  // states
  bool get isPlaying {
    if (mkSupportedPlatform) {
      return _mkPlayer!.state.playing;
    } else {
      return _justAudio!.playing;
    }
  }

  bool get isPaused {
    if (mkSupportedPlatform) {
      return !_mkPlayer!.state.playing;
    } else {
      return !isPlaying;
    }
  }

  bool get isStopped {
    if (mkSupportedPlatform) {
      return !hasSource;
    } else {
      return _justAudio!.processingState == ja.ProcessingState.idle;
    }
  }

  Future<bool> get isCompleted async {
    if (mkSupportedPlatform) {
      return _mkPlayer!.state.completed;
    } else {
      return _justAudio!.processingState == ja.ProcessingState.completed;
    }
  }

  Future<bool> get isShuffled async {
    if (mkSupportedPlatform) {
      return _mkPlayer!.shuffled;
    } else {
      return _justAudio!.shuffleModeEnabled;
    }
  }

  Future<PlaybackLoopMode> get loopMode async {
    if (mkSupportedPlatform) {
      return PlaybackLoopMode.fromPlaylistMode(_mkPlayer!.loopMode);
    } else {
      return PlaybackLoopMode.fromLoopMode(_justAudio!.loopMode);
    }
  }

  /// Returns the current volume of the player, between 0 and 1
  double get volume {
    if (mkSupportedPlatform) {
      return _mkPlayer!.state.volume / 100;
    } else {
      return _justAudio!.volume;
    }
  }

  bool get isBuffering {
    if (mkSupportedPlatform) {
      // audioplayers doesn't have the capability to get buffering state
      return false;
    } else {
      return _justAudio!.processingState == ja.ProcessingState.buffering ||
          _justAudio!.processingState == ja.ProcessingState.loading;
    }
  }
}
