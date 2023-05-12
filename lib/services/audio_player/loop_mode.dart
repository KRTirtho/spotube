import 'package:media_kit/media_kit.dart';
import 'package:just_audio/just_audio.dart';

/// An unified loop mode for both [LoopMode] and [PlaylistMode]
enum PlaybackLoopMode {
  all,
  one,
  none;

  static PlaybackLoopMode fromLoopMode(LoopMode loopMode) {
    switch (loopMode) {
      case LoopMode.all:
        return PlaybackLoopMode.all;
      case LoopMode.one:
        return PlaybackLoopMode.one;
      case LoopMode.off:
        return PlaybackLoopMode.none;
    }
  }

  LoopMode toLoopMode() {
    switch (this) {
      case PlaybackLoopMode.all:
        return LoopMode.all;
      case PlaybackLoopMode.one:
        return LoopMode.one;
      case PlaybackLoopMode.none:
        return LoopMode.off;
    }
  }

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
}
