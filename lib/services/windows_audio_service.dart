import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smtc_windows/smtc_windows.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/provider/playlist_queue_provider.dart';
import 'package:spotube/services/audio_player.dart';
import 'package:spotube/utils/type_conversion_utils.dart';

class WindowsAudioService {
  final SMTCWindows smtc;
  final Ref ref;
  final PlaylistQueueNotifier playlistNotifier;

  final subscriptions = <StreamSubscription>[];

  WindowsAudioService(this.ref, this.playlistNotifier)
      : smtc = SMTCWindows(enabled: false) {
    smtc.setPlaybackStatus(PlaybackStatus.Stopped);
    final buttonStream = smtc.buttonPressStream.listen((event) {
      switch (event) {
        case PressedButton.play:
          playlistNotifier.resume();
          break;
        case PressedButton.pause:
          playlistNotifier.pause();
          break;
        case PressedButton.next:
          playlistNotifier.next();
          break;
        case PressedButton.previous:
          playlistNotifier.previous();
          break;
        case PressedButton.stop:
          playlistNotifier.stop();
          break;
        default:
          break;
      }
    });

    final playerStateStream =
        audioPlayer.onPlayerStateChanged.listen((state) async {
      switch (state) {
        case PlayerState.playing:
          await smtc.setPlaybackStatus(PlaybackStatus.Playing);
          break;
        case PlayerState.paused:
          await smtc.setPlaybackStatus(PlaybackStatus.Paused);
          break;
        case PlayerState.stopped:
          await smtc.setPlaybackStatus(PlaybackStatus.Stopped);
          await smtc.disableSmtc();
          break;
        case PlayerState.completed:
          await smtc.setPlaybackStatus(PlaybackStatus.Changing);
          await smtc.disableSmtc();
          break;
        default:
          break;
      }
    });

    final positionStream = audioPlayer.onPositionChanged.listen((pos) async {
      await smtc.setPosition(pos);
    });

    final durationStream =
        audioPlayer.onDurationChanged.listen((duration) async {
      await smtc.setEndTime(duration);
    });

    subscriptions.addAll([
      buttonStream,
      playerStateStream,
      positionStream,
      durationStream,
    ]);
  }

  Future<void> addTrack(Track track) async {
    if (!smtc.enabled) {
      await smtc.enableSmtc();
    }
    await smtc.updateMetadata(MusicMetadata(
      title: track.name!,
      albumArtist: track.artists?.first.name ?? "Unknown",
      artist: TypeConversionUtils.artists_X_String<Artist>(track.artists ?? []),
      album: track.album?.name ?? "Unknown",
      thumbnail: TypeConversionUtils.image_X_UrlString(
        track.album?.images ?? [],
        placeholder: ImagePlaceholder.albumArt,
      ),
    ));
  }

  void dispose() {
    smtc.disableSmtc();
    smtc.dispose();
    for (var element in subscriptions) {
      element.cancel();
    }
  }
}
