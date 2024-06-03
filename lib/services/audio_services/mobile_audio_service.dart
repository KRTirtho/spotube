import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:spotube/provider/proxy_playlist/proxy_playlist.dart';
import 'package:spotube/provider/proxy_playlist/proxy_playlist_provider.dart';
import 'package:spotube/services/audio_player/audio_player.dart';
import 'package:spotube/services/audio_player/loop_mode.dart';

class MobileAudioService extends BaseAudioHandler {
  AudioSession? session;
  final ProxyPlaylistNotifier playlistNotifier;

  // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
  ProxyPlaylist get playlist => playlistNotifier.state;

  MobileAudioService(this.playlistNotifier) {
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
      playbackState.add(await _transformEvent());
    });

    audioPlayer.positionStream.listen((pos) async {
      playbackState.add(await _transformEvent());
    });
    audioPlayer.bufferedPositionStream.listen((pos) async {
      playbackState.add(await _transformEvent());
    });
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
    audioPlayer.setLoopMode(
      PlaybackLoopMode.fromAudioServiceRepeatMode(repeatMode),
    );
  }

  @override
  Future<void> stop() async {
    await playlistNotifier.stop();
  }

  @override
  Future<void> skipToNext() async {
    await playlistNotifier.next();
    await super.skipToNext();
  }

  @override
  Future<void> skipToPrevious() async {
    await playlistNotifier.previous();
    await super.skipToPrevious();
  }

  @override
  Future<void> onTaskRemoved() async {
    await playlistNotifier.stop();
    return super.onTaskRemoved();
  }

  Future<PlaybackState> _transformEvent() async {
    final position = (await audioPlayer.position) ?? Duration.zero;
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
      updatePosition: position,
      bufferedPosition: await audioPlayer.bufferedPosition ?? Duration.zero,
      shuffleMode: audioPlayer.isShuffled == true
          ? AudioServiceShuffleMode.all
          : AudioServiceShuffleMode.none,
      repeatMode: (audioPlayer.loopMode).toAudioServiceRepeatMode(),
      processingState: playlist.isFetching == true
          ? AudioProcessingState.loading
          : AudioProcessingState.ready,
    );
  }
}
