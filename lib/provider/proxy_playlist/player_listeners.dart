// ignore_for_file: invalid_use_of_protected_member

import 'dart:async';

import 'package:catcher_2/catcher_2.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:spotube/models/local_track.dart';
import 'package:spotube/provider/proxy_playlist/proxy_playlist_provider.dart';
import 'package:spotube/provider/proxy_playlist/skip_segments.dart';
import 'package:spotube/services/audio_player/audio_player.dart';
import 'package:spotube/services/sourced_track/exceptions.dart';

extension ProxyPlaylistListeners on ProxyPlaylistNotifier {
  StreamSubscription<String> subscribeToSourceChanges() =>
      audioPlayer.activeSourceChangedStream.listen((event) {
        try {
          final newActiveTrack = mapSourcesToTracks([event]).firstOrNull;

          if (newActiveTrack == null ||
              newActiveTrack.id == state.activeTrack?.id) {
            return;
          }

          notificationService.addTrack(newActiveTrack);
          discord.updatePresence(newActiveTrack);
          state = state.copyWith(
            active: state.tracks
                .toList()
                .indexWhere((element) => element.id == newActiveTrack.id),
          );

          updatePalette();
        } catch (e, stackTrace) {
          Catcher2.reportCheckedError(e, stackTrace);
        }
      });

  StreamSubscription subscribeToPercentCompletion() {
    final isPreSearching = ObjectRef(false);

    return audioPlayer.percentCompletedStream(2).listen((event) async {
      if (isPreSearching.value ||
          audioPlayer.currentSource == null ||
          audioPlayer.nextSource == null ||
          isPlayable(audioPlayer.nextSource!)) return;

      try {
        isPreSearching.value = true;

        final track = await ensureSourcePlayable(audioPlayer.nextSource!);

        if (track != null) {
          state = state.copyWith(tracks: mergeTracks([track], state.tracks));
        }
      } catch (e, stackTrace) {
        // Removing tracks that were not found to avoid queue interruption
        if (e is TrackNotFoundError) {
          final oldTrack =
              mapSourcesToTracks([audioPlayer.nextSource!]).firstOrNull;
          await removeTrack(oldTrack!.id!);
        }
        Catcher2.reportCheckedError(e, stackTrace);
      } finally {
        isPreSearching.value = false;
      }
    });
  }

  StreamSubscription subscribeToShuffleChanges() {
    return audioPlayer.shuffledStream.listen((event) {
      try {
        final newlyOrderedTracks = mapSourcesToTracks(audioPlayer.sources);

        final newActiveIndex = newlyOrderedTracks.indexWhere(
          (element) => element.id == state.activeTrack?.id,
        );

        if (newActiveIndex == -1) return;

        state = state.copyWith(
          tracks: newlyOrderedTracks.toSet(),
          active: newActiveIndex,
        );
      } catch (e, stackTrace) {
        Catcher2.reportCheckedError(e, stackTrace);
      }
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

  StreamSubscription subscribeToPlayerError() {
    return audioPlayer.errorStream.listen((event) {});
  }
}
