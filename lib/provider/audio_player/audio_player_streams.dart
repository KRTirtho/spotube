import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:spotube/components/image/universal_image.dart';
import 'package:spotube/extensions/image.dart';
import 'package:spotube/models/local_track.dart';
import 'package:spotube/provider/audio_player/audio_player.dart';
import 'package:spotube/provider/audio_player/state.dart';
import 'package:spotube/provider/discord_provider.dart';
import 'package:spotube/provider/history/history.dart';
import 'package:spotube/provider/palette_provider.dart';
import 'package:spotube/provider/skip_segments/skip_segments.dart';
import 'package:spotube/provider/scrobbler/scrobbler.dart';
import 'package:spotube/provider/server/sourced_track.dart';
import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';
import 'package:spotube/services/audio_player/audio_player.dart';
import 'package:spotube/services/audio_services/audio_services.dart';
import 'package:spotube/services/logger/logger.dart';

class AudioPlayerStreamListeners {
  final Ref ref;
  late final AudioServices notificationService;
  AudioPlayerStreamListeners(this.ref) {
    AudioServices.create(ref, ref.read(audioPlayerProvider.notifier)).then(
      (value) => notificationService = value,
    );

    final subscriptions = [
      subscribeToPlaylist(),
      subscribeToSkipSponsor(),
      subscribeToScrobbleChanged(),
      subscribeToPosition(),
      subscribeToPlayerError(),
    ];

    ref.onDispose(() {
      for (final subscription in subscriptions) {
        subscription.cancel();
      }
    });
  }

  ScrobblerNotifier get scrobbler => ref.read(scrobblerProvider.notifier);
  UserPreferences get preferences => ref.read(userPreferencesProvider);
  DiscordNotifier get discord => ref.read(discordProvider.notifier);
  AudioPlayerState get audioPlayerState => ref.read(audioPlayerProvider);
  PlaybackHistoryActions get history =>
      ref.read(playbackHistoryActionsProvider);

  Future<void> updatePalette() async {
    final palette = ref.read(paletteProvider);
    if (!preferences.albumColorSync) {
      if (palette != null) ref.read(paletteProvider.notifier).state = null;
      return;
    }
    return Future.microtask(() async {
      final activeTrack = ref.read(audioPlayerProvider).activeTrack;
      if (activeTrack == null) return;

      final palette = await PaletteGenerator.fromImageProvider(
        UniversalImage.imageProvider(
          (activeTrack.album?.images).asUrlString(
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
      try {
        notificationService.addTrack(audioPlayerState.activeTrack!);
        discord.updatePresence(audioPlayerState.activeTrack!);
        updatePalette();
      } catch (e, stack) {
        AppLogger.reportError(e, stack);
      }
    });
  }

  StreamSubscription subscribeToSkipSponsor() {
    return audioPlayer.positionStream.listen((position) async {
      try {
        final currentSegments = await ref.read(segmentProvider.future);

        if (currentSegments?.segments.isNotEmpty != true ||
            position < const Duration(seconds: 3)) return;

        for (final segment in currentSegments!.segments) {
          final seconds = position.inSeconds;

          if (seconds < segment.start || seconds >= segment.end) continue;

          await audioPlayer.seek(Duration(seconds: segment.end + 1));
        }
      } catch (e, stack) {
        AppLogger.reportError(e, stack);
      }
    });
  }

  StreamSubscription subscribeToScrobbleChanged() {
    String? lastScrobbled;
    return audioPlayer.positionStream.listen((position) {
      try {
        final uid = audioPlayerState.activeTrack is LocalTrack
            ? (audioPlayerState.activeTrack as LocalTrack).path
            : audioPlayerState.activeTrack?.id;

        if (audioPlayerState.activeTrack == null ||
            lastScrobbled == uid ||
            position.inSeconds < 30) {
          return;
        }

        scrobbler.scrobble(audioPlayerState.activeTrack!);
        history.addTrack(audioPlayerState.activeTrack!);
        lastScrobbled = uid;
      } catch (e, stack) {
        AppLogger.reportError(e, stack);
      }
    });
  }

  StreamSubscription subscribeToPosition() {
    String lastTrack = ""; // used to prevent multiple calls to the same track
    return audioPlayer.positionStream.listen((event) async {
      try {
        if (event < const Duration(seconds: 3) ||
            audioPlayerState.playlist.index == -1 ||
            audioPlayerState.playlist.index ==
                audioPlayerState.tracks.length - 1) {
          return;
        }
        final nextTrack = SpotubeMedia.fromMedia(audioPlayerState
            .playlist.medias
            .elementAt(audioPlayerState.playlist.index + 1));

        if (lastTrack == nextTrack.track.id || nextTrack.track is LocalTrack) {
          return;
        }

        try {
          await ref.read(sourcedTrackProvider(nextTrack).future);
        } finally {
          lastTrack = nextTrack.track.id!;
        }
      } catch (e, stack) {
        AppLogger.reportError(e, stack);
      }
    });
  }

  StreamSubscription subscribeToPlayerError() {
    return audioPlayer.errorStream.listen((event) {});
  }
}

final audioPlayerStreamListenersProvider =
    Provider<AudioPlayerStreamListeners>(AudioPlayerStreamListeners.new);
