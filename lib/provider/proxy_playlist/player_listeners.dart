// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'dart:async';

import 'package:catcher_2/catcher_2.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:spotube/components/shared/image/universal_image.dart';
import 'package:spotube/extensions/image.dart';
import 'package:spotube/models/local_track.dart';
import 'package:spotube/provider/palette_provider.dart';
import 'package:spotube/provider/proxy_playlist/proxy_playlist_provider.dart';
import 'package:spotube/provider/proxy_playlist/skip_segments.dart';
import 'package:spotube/provider/server/sourced_track.dart';
import 'package:spotube/services/audio_player/audio_player.dart';

extension ProxyPlaylistListeners on ProxyPlaylistNotifier {
  Future<void> updatePalette() async {
    final palette = ref.read(paletteProvider);
    if (!preferences.albumColorSync) {
      if (palette != null) ref.read(paletteProvider.notifier).state = null;
      return;
    }
    return Future.microtask(() async {
      if (playlist.activeTrack == null) return;

      final palette = await PaletteGenerator.fromImageProvider(
        UniversalImage.imageProvider(
          (playlist.activeTrack?.album?.images).asUrlString(
            placeholder: ImagePlaceholder.albumArt,
          ),
          height: 50,
          width: 50,
        ),
      );
      ref.read(paletteProvider.notifier).state = palette;
    });
  }

  StreamSubscription subscribeToPlaylist() {
    return audioPlayer.playlistStream.listen((mpvPlaylist) {
      state = playlist.copyWith(
        tracks: mpvPlaylist.medias
            .map((media) => SpotubeMedia.fromMedia(media).track)
            .toSet(),
        active: mpvPlaylist.index,
      );

      notificationService.addTrack(playlist.activeTrack!);
      discord.updatePresence(playlist.activeTrack!);
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
        final uid = playlist.activeTrack is LocalTrack
            ? (playlist.activeTrack as LocalTrack).path
            : playlist.activeTrack?.id;

        if (playlist.activeTrack == null ||
            lastScrobbled == uid ||
            position.inSeconds < 30) {
          return;
        }

        scrobbler.scrobble(playlist.activeTrack!);
        history.addTrack(playlist.activeTrack!);
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
          playlist.active == null ||
          playlist.active == playlist.tracks.length - 1) return;
      final nextTrack = playlist.tracks.elementAt(playlist.active! + 1);

      if (lastTrack == nextTrack.id || nextTrack is LocalTrack) return;

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
