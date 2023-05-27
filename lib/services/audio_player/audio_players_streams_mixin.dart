part of 'audio_player.dart';

mixin SpotubeAudioPlayersStreams on AudioPlayerInterface {
  // stream getters
  Stream<Duration> get durationStream {
    // if (mkSupportedPlatform) {
    return _mkPlayer.streams.duration.asBroadcastStream();
    // } else {
    //   return _justAudio!.durationStream
    //       .where((event) => event != null)
    //       .map((event) => event!)
    //       .asBroadcastStream();
    // }
  }

  Stream<Duration> get positionStream {
    // if (mkSupportedPlatform) {
    return _mkPlayer.streams.position.asBroadcastStream();
    // } else {
    //   return _justAudio!.positionStream.asBroadcastStream();
    // }
  }

  Stream<Duration> get bufferedPositionStream {
    // if (mkSupportedPlatform) {
    // audioplayers doesn't have the capability to get buffered position
    return _mkPlayer.streams.buffer.asBroadcastStream();
    // } else {
    //   return _justAudio!.bufferedPositionStream.asBroadcastStream();
    // }
  }

  Stream<void> get completedStream {
    // if (mkSupportedPlatform) {
    return _mkPlayer.streams.completed.asBroadcastStream();
    // } else {
    //   return _justAudio!.playerStateStream
    //       .where(
    //           (event) => event.processingState == ja.ProcessingState.completed)
    //       .asBroadcastStream();
    // }
  }

  /// Stream that emits when the player is almost (%) complete
  Stream<int> percentCompletedStream(double percent) {
    return positionStream
        .asyncMap(
          (position) async => (await duration)?.inSeconds == 0
              ? 0
              : (position.inSeconds /
                      ((await duration)?.inSeconds ?? 100) *
                      100)
                  .toInt(),
        )
        .where((event) => event >= percent)
        .asBroadcastStream();
  }

  Stream<bool> get playingStream {
    // if (mkSupportedPlatform) {
    return _mkPlayer.streams.playing.asBroadcastStream();
    // } else {
    //   return _justAudio!.playingStream.asBroadcastStream();
    // }
  }

  Stream<bool> get shuffledStream {
    // if (mkSupportedPlatform) {
    return _mkPlayer.shuffleStream.asBroadcastStream();
    // } else {
    //   return _justAudio!.shuffleModeEnabledStream.asBroadcastStream();
    // }
  }

  Stream<PlaybackLoopMode> get loopModeStream {
    // if (mkSupportedPlatform) {
    return _mkPlayer.loopModeStream
        .map(PlaybackLoopMode.fromPlaylistMode)
        .asBroadcastStream();
    // } else {
    //   return _justAudio!.loopModeStream
    //       .map(PlaybackLoopMode.fromLoopMode)
    //       .asBroadcastStream();
    // }
  }

  Stream<double> get volumeStream {
    // if (mkSupportedPlatform) {
    return _mkPlayer.streams.volume
        .map((event) => event / 100)
        .asBroadcastStream();
    // } else {
    //   return _justAudio!.volumeStream.asBroadcastStream();
    // }
  }

  Stream<bool> get bufferingStream {
    // if (mkSupportedPlatform) {
    return Stream.value(false).asBroadcastStream();
    // } else {
    //   return _justAudio!.playerStateStream
    //       .map(
    //         (event) =>
    //             event.processingState == ja.ProcessingState.buffering ||
    //             event.processingState == ja.ProcessingState.loading,
    //       )
    //       .asBroadcastStream();
    // }
  }

  Stream<AudioPlaybackState> get playerStateStream {
    // if (mkSupportedPlatform) {
    return _mkPlayer.playerStateStream.asBroadcastStream();
    // } else {
    //   return _justAudio!.playerStateStream
    //       .map(AudioPlaybackState.fromJaPlayerState)
    //       .asBroadcastStream();
    // }
  }

  Stream<int> get currentIndexChangedStream {
    // if (mkSupportedPlatform) {
    return _mkPlayer.indexChangeStream;
    // } else {
    //   return _justAudio!.sequenceStateStream
    //       .map((event) => event?.currentIndex ?? -1)
    //       .asBroadcastStream();
    // }
  }

  Stream<String> get activeSourceChangedStream {
    // if (mkSupportedPlatform) {
    return _mkPlayer.indexChangeStream
        .map((event) {
          return _mkPlayer.playlist.medias.elementAtOrNull(event)?.uri;
        })
        .where((event) => event != null)
        .cast<String>();
    // } else {
    //   return _justAudio!.sequenceStateStream
    //       .map((event) {
    //         return (event?.currentSource as ja.UriAudioSource?)?.uri.toString();
    //       })
    //       .where((event) => event != null)
    //       .cast<String>();
    // }
  }
}
