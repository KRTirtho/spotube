// import 'package:just_audio/just_audio.dart';

/// An unified playback state enum
enum AudioPlaybackState {
  playing,
  paused,
  completed,
  buffering,
  stopped;

  // static AudioPlaybackState fromJaPlayerState(PlayerState state) {
  //   if (state.playing) {
  //     return AudioPlaybackState.playing;
  //   }

  //   switch (state.processingState) {
  //     case ProcessingState.idle:
  //       return AudioPlaybackState.stopped;
  //     case ProcessingState.ready:
  //       return AudioPlaybackState.paused;
  //     case ProcessingState.completed:
  //       return AudioPlaybackState.completed;
  //     case ProcessingState.loading:
  //     case ProcessingState.buffering:
  //       return AudioPlaybackState.buffering;
  //   }
  // }
}
