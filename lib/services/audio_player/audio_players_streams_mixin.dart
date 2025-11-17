part of 'audio_player.dart';

mixin SpotubeAudioPlayersStreams on AudioPlayerInterface {
  // stream getters
  Stream<Duration> get durationStream {
    // if (mkSupportedPlatform) {
    return _mkPlayer.stream.duration;
    // } else {
    //   return _justAudio!.durationStream
    //       .where((event) => event != null)
    //       .map((event) => event!)
    //       ;
    // }
  }

  Stream<Duration> get positionStream {
    // if (mkSupportedPlatform) {
    return _mkPlayer.stream.position;
    // } else {
    //   return _justAudio!.positionStream;
    // }
  }

  Stream<Duration> get bufferedPositionStream {
    // if (mkSupportedPlatform) {
    // audioplayers doesn't have the capability to get buffered position
    return _mkPlayer.stream.buffer;
    // } else {
    //   return _justAudio!.bufferedPositionStream;
    // }
  }

  Stream<void> get completedStream {
    // if (mkSupportedPlatform) {
    return _mkPlayer.stream.completed;
    // } else {
    //   return _justAudio!.playerStateStream
    //       .where(
    //           (event) => event.processingState == ja.ProcessingState.completed)
    //       ;
    // }
  }

  /// Stream that emits when the player is almost (%) complete
  Stream<int> percentCompletedStream(double percent) {
    return positionStream
        .asyncMap(
          (position) async => duration == Duration.zero
              ? 0
              : (position.inSeconds / duration.inSeconds * 100).toInt(),
        )
        .where((event) => event >= percent);
  }

  Stream<bool> get playingStream {
    // if (mkSupportedPlatform) {
    return _mkPlayer.stream.playing;
    // } else {
    //   return _justAudio!.playingStream;
    // }
  }

  Stream<bool> get shuffledStream {
    // if (mkSupportedPlatform) {
    return _mkPlayer.shuffleStream;
    // } else {
    //   return _justAudio!.shuffleModeEnabledStream;
    // }
  }

  Stream<PlaylistMode> get loopModeStream {
    // if (mkSupportedPlatform) {
    return _mkPlayer.stream.playlistMode;
    // } else {
    //   return _justAudio!.loopModeStream
    //       .map(PlaylistMode.fromLoopMode)
    //       ;
    // }
  }

  Stream<double> get volumeStream {
    // if (mkSupportedPlatform) {
    return _mkPlayer.stream.volume.map((event) => event / 100);
    // } else {
    //   return _justAudio!.volumeStream;
    // }
  }

  Stream<bool> get bufferingStream {
    // if (mkSupportedPlatform) {
    return Stream.value(false);
    // } else {
    //   return _justAudio!.playerStateStream
    //       .map(
    //         (event) =>
    //             event.processingState == ja.ProcessingState.buffering ||
    //             event.processingState == ja.ProcessingState.loading,
    //       )
    //       ;
    // }
  }

  Stream<AudioPlaybackState> get playerStateStream {
    // if (mkSupportedPlatform) {
    return _mkPlayer.playerStateStream;
    // } else {
    //   return _justAudio!.playerStateStream
    //       .map(AudioPlaybackState.fromJaPlayerState)
    //       ;
    // }
  }

  Stream<int> get currentIndexChangedStream {
    // if (mkSupportedPlatform) {
    return _mkPlayer.indexChangeStream;
    // } else {
    //   return _justAudio!.sequenceStateStream
    //       .map((event) => event?.currentIndex ?? -1)
    //       ;
    // }
  }

  Stream<String> get activeSourceChangedStream {
    // if (mkSupportedPlatform) {
    return _mkPlayer.indexChangeStream
        .map((event) {
          return _mkPlayer.state.playlist.medias.elementAtOrNull(event)?.uri;
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

  Stream<List<mk.AudioDevice>> get devicesStream =>
      _mkPlayer.stream.audioDevices.asBroadcastStream();

  Stream<mk.AudioDevice> get selectedDeviceStream =>
      _mkPlayer.stream.audioDevice.asBroadcastStream();

  Stream<String> get errorStream => _mkPlayer.stream.error;

  Stream<mk.Playlist> get playlistStream => _mkPlayer.stream.playlist;
}
