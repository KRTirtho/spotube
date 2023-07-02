import 'package:audio_service/audio_service.dart';
import 'package:media_kit/media_kit.dart';

/// An unified loop mode for both [LoopMode] and [PlaylistMode]
enum PlaybackLoopMode {
  all,
  one,
  none;

  // static PlaybackLoopMode fromLoopMode(LoopMode loopMode) {
  //   switch (loopMode) {
  //     case LoopMode.all:
  //       return PlaybackLoopMode.all;
  //     case LoopMode.one:
  //       return PlaybackLoopMode.one;
  //     case LoopMode.off:
  //       return PlaybackLoopMode.none;
  //   }
  // }

  // LoopMode toLoopMode() {
  //   switch (this) {
  //     case PlaybackLoopMode.all:
  //       return LoopMode.all;
  //     case PlaybackLoopMode.one:
  //       return LoopMode.one;
  //     case PlaybackLoopMode.none:
  //       return LoopMode.off;
  //   }
  // }

  static PlaybackLoopMode fromPlaylistMode(PlaylistMode mode) {
    switch (mode) {
      case PlaylistMode.single:
        return PlaybackLoopMode.one;
      case PlaylistMode.loop:
        return PlaybackLoopMode.all;
      case PlaylistMode.none:
        return PlaybackLoopMode.none;
    }
  }

  PlaylistMode toPlaylistMode() {
    switch (this) {
      case PlaybackLoopMode.all:
        return PlaylistMode.loop;
      case PlaybackLoopMode.one:
        return PlaylistMode.single;
      case PlaybackLoopMode.none:
        return PlaylistMode.none;
    }
  }

  static PlaybackLoopMode fromAudioServiceRepeatMode(
      AudioServiceRepeatMode mode) {
    switch (mode) {
      case AudioServiceRepeatMode.all:
      case AudioServiceRepeatMode.group:
        return PlaybackLoopMode.all;
      case AudioServiceRepeatMode.one:
        return PlaybackLoopMode.one;
      case AudioServiceRepeatMode.none:
        return PlaybackLoopMode.none;
    }
  }

  AudioServiceRepeatMode toAudioServiceRepeatMode() {
    switch (this) {
      case PlaybackLoopMode.all:
        return AudioServiceRepeatMode.all;
      case PlaybackLoopMode.one:
        return AudioServiceRepeatMode.one;
      case PlaybackLoopMode.none:
        return AudioServiceRepeatMode.none;
    }
  }

  static PlaybackLoopMode fromString(String? value) {
    switch (value) {
      case 'all':
        return PlaybackLoopMode.all;
      case 'one':
        return PlaybackLoopMode.one;
      case 'none':
        return PlaybackLoopMode.none;
      default:
        return PlaybackLoopMode.none;
    }
  }
}
