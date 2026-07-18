import 'dart:async';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';
import 'package:spotube/provider/audio_player/audio_player.dart';
import 'package:spotube/provider/audio_player/state.dart';
import 'package:spotube/services/audio_player/audio_player.dart';
import 'package:media_kit/media_kit.dart' hide Track;
import 'package:spotube/services/audio_player/playback_state.dart';
import 'package:spotube/services/logger/logger.dart';
import 'package:spotube/utils/platform.dart';

class MobileAudioService extends BaseAudioHandler {
  AudioSession? session;
  final AudioPlayerNotifier audioPlayerNotifier;

  // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
  AudioPlayerState get playlist => audioPlayerNotifier.state;

  MobileAudioService(this.audioPlayerNotifier) {
    AudioSession.instance.then((s) {
      session = s;
      session?.configure(const AudioSessionConfiguration.music());

      bool wasPausedByBeginEvent = false;

      s.interruptionEventStream.listen((event) async {
        if (event.begin) {
          switch (event.type) {
            case AudioInterruptionType.duck:
              await audioPlayer.setVolume(0.5);
              break;
            case AudioInterruptionType.pause:
            case AudioInterruptionType.unknown:
              {
                wasPausedByBeginEvent = audioPlayer.isPlaying;
                await audioPlayer.pause();
                break;
              }
          }
        } else {
          switch (event.type) {
            case AudioInterruptionType.duck:
              await audioPlayer.setVolume(1.0);
              break;
            case AudioInterruptionType.pause when wasPausedByBeginEvent:
            case AudioInterruptionType.unknown when wasPausedByBeginEvent:
              await audioPlayer.resume();
              wasPausedByBeginEvent = false;
              break;
            default:
              break;
          }
        }
      });

      s.becomingNoisyEventStream.listen((_) {
        audioPlayer.pause();
      });
    });
    audioPlayer.playerStateStream.listen((state) async {
      if (state == AudioPlaybackState.playing) {
        await session?.setActive(true);
      }
      playbackState.add(await _transformEvent());
    });

    audioPlayer.positionStream.listen((pos) async {
      playbackState.add(await _transformEvent());
    });
    audioPlayer.bufferedPositionStream.listen((pos) async {
      playbackState.add(await _transformEvent());
    });

    // Tracks coming from album/playlist metadata may carry an unknown
    // (zero) duration, so the [MediaItem] sent to the OS initially has no
    // duration. Once the player has loaded the source and discovered the
    // real duration, propagate it to the active [MediaItem] so the
    // MediaSession/Now Playing UI shows duration, progress and seeking.
    audioPlayer.durationStream.listen((duration) {
      final updatedItem =
          mediaItemWithDuration(mediaItem.valueOrNull, duration);
      if (updatedItem != null) {
        mediaItem.add(updatedItem);
      }
    });
  }

  /// Returns [item] updated with the player-discovered [duration], or `null`
  /// when no update should be published (no active item, unknown duration or
  /// the item already has that exact duration).
  @visibleForTesting
  static MediaItem? mediaItemWithDuration(MediaItem? item, Duration duration) {
    if (item == null || duration <= Duration.zero) return null;
    if (item.duration == duration) return null;
    return item.copyWith(duration: duration);
  }

  void addItem(MediaItem item) {
    session?.setActive(true);
    mediaItem.add(item);
  }

  @override
  Future<void> play() => audioPlayer.resume();

  @override
  Future<void> pause() => audioPlayer.pause();

  @override
  Future<void> seek(Duration position) => audioPlayer.seek(position);

  @override
  Future<void> setShuffleMode(AudioServiceShuffleMode shuffleMode) async {
    await super.setShuffleMode(shuffleMode);

    audioPlayer.setShuffle(shuffleMode == AudioServiceShuffleMode.all);
  }

  @override
  Future<void> setRepeatMode(AudioServiceRepeatMode repeatMode) async {
    super.setRepeatMode(repeatMode);
    audioPlayer.setLoopMode(switch (repeatMode) {
      AudioServiceRepeatMode.all ||
      AudioServiceRepeatMode.group =>
        PlaylistMode.loop,
      AudioServiceRepeatMode.one => PlaylistMode.single,
      _ => PlaylistMode.none,
    });
  }

  @override
  Future<void> stop() async {
    await audioPlayerNotifier.stop();
  }

  @override
  Future<void> skipToNext() async {
    await audioPlayer.skipToNext();
    await super.skipToNext();
  }

  @override
  Future<void> skipToPrevious() async {
    await audioPlayer.skipToPrevious();
    await super.skipToPrevious();
  }

  @override
  Future<void> onTaskRemoved() async {
    await audioPlayer.pause();
    if (kIsAndroid) exit(0);
  }

  Future<PlaybackState> _transformEvent() async {
    try {
      return PlaybackState(
        controls: [
          MediaControl.skipToPrevious,
          audioPlayer.isPlaying ? MediaControl.pause : MediaControl.play,
          MediaControl.skipToNext,
          MediaControl.stop,
        ],
        systemActions: {
          MediaAction.seek,
        },
        androidCompactActionIndices: const [0, 1, 2],
        playing: audioPlayer.isPlaying,
        updatePosition: audioPlayer.position,
        bufferedPosition: audioPlayer.bufferedPosition,
        shuffleMode: audioPlayer.isShuffled == true
            ? AudioServiceShuffleMode.all
            : AudioServiceShuffleMode.none,
        repeatMode: switch (audioPlayer.loopMode) {
          PlaylistMode.loop => AudioServiceRepeatMode.all,
          PlaylistMode.single => AudioServiceRepeatMode.one,
          _ => AudioServiceRepeatMode.none,
        },
        processingState: audioPlayer.isBuffering
            ? AudioProcessingState.loading
            : AudioProcessingState.ready,
      );
    } catch (e, stack) {
      AppLogger.reportError(e, stack);
      rethrow;
    }
  }
}
