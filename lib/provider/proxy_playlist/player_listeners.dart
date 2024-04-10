// ignore_for_file: invalid_use_of_protected_member

import 'dart:async';

import 'package:catcher_2/catcher_2.dart';
import 'package:spotube/models/local_track.dart';
import 'package:spotube/provider/proxy_playlist/proxy_playlist_provider.dart';
import 'package:spotube/provider/proxy_playlist/skip_segments.dart';
import 'package:spotube/provider/server/sourced_track.dart';
import 'package:spotube/services/audio_player/audio_player.dart';

extension ProxyPlaylistListeners on ProxyPlaylistNotifier {
  StreamSubscription subscribeToPlaylist() {
    return audioPlayer.playlistStream.listen((playlist) {
      state = state.copyWith(
        tracks: playlist.medias
            .map((media) => SpotubeMedia.fromMedia(media).track)
            .toSet(),
        active: playlist.index,
      );

      notificationService.addTrack(state.activeTrack!);
      discord.updatePresence(state.activeTrack!);
      updatePalette();
    });
  }

  StreamSubscription subscribeToSkipSponsor() {
    return audioPlayer.positionStream.listen((position) async {
      final currentSegments = await ref.read(segmentProvider.future);

      if (currentSegments?.segments.isNotEmpty != true ||
          position < const Duration(seconds: 3)) return;

      for (final segment in currentSegments!.segments) {
        final seconds = position.inSeconds;

        if (seconds < segment.start || seconds >= segment.end) continue;

        await audioPlayer.seek(Duration(seconds: segment.end + 1));
      }
    });
  }

  StreamSubscription subscribeToScrobbleChanged() {
    String? lastScrobbled;
    return audioPlayer.positionStream.listen((position) {
      try {
        final uid = state.activeTrack is LocalTrack
            ? (state.activeTrack as LocalTrack).path
            : state.activeTrack?.id;

        if (state.activeTrack == null ||
            lastScrobbled == uid ||
            position.inSeconds < 30) {
          return;
        }

        scrobbler.scrobble(state.activeTrack!);
        lastScrobbled = uid;
      } catch (e, stack) {
        Catcher2.reportCheckedError(e, stack);
      }
    });
  }

  StreamSubscription subscribeToPosition() {
    String lastTrack = ""; // used to prevent multiple calls to the same track
    return audioPlayer.positionStream.listen((event) async {
      if (event < const Duration(seconds: 3) ||
          state.active == null ||
          state.active == state.tracks.length - 1) return;
      final nextTrack = state.tracks.elementAt(state.active! + 1);

      if (lastTrack == nextTrack.id) return;

      try {
        await ref.read(sourcedTrackProvider(nextTrack).future);
      } finally {
        lastTrack = nextTrack.id!;
      }
    });
  }

  StreamSubscription subscribeToPlayerError() {
    return audioPlayer.errorStream.listen((event) {});
  }
}
