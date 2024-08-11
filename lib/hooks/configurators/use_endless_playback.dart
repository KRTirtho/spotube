import 'package:spotube/services/logger/logger.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/provider/authentication/authentication.dart';
import 'package:spotube/provider/audio_player/audio_player.dart';
import 'package:spotube/provider/spotify_provider.dart';
import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';
import 'package:spotube/services/audio_player/audio_player.dart';

void useEndlessPlayback(WidgetRef ref) {
  final auth = ref.watch(authenticationProvider);
  final playback = ref.watch(audioPlayerProvider.notifier);
  final playlist = ref.watch(audioPlayerProvider.select((s) => s.playlist));
  final spotify = ref.watch(spotifyProvider);
  final endlessPlayback =
      ref.watch(userPreferencesProvider.select((s) => s.endlessPlayback));

  useEffect(
    () {
      if (!endlessPlayback || auth.asData?.value == null) return null;

      void listener(int index) async {
        try {
          final playlist = ref.read(audioPlayerProvider);
          if (index != playlist.tracks.length - 1) return;

          final track = playlist.tracks.last;

          final query = "${track.name} Radio";
          final pages = await spotify.search
              .get(query, types: [SearchType.playlist]).first();

          final radios = pages
              .expand((e) => e.items?.toList() ?? <PlaylistSimple>[])
              .toList()
              .cast<PlaylistSimple>();

          final artists = track.artists!.map((e) => e.name);

          final radio = radios.firstWhere(
            (e) {
              final validPlaylists =
                  artists.where((a) => e.description!.contains(a!));
              return e.name == "${track.name} Radio" &&
                  (validPlaylists.length >= 2 ||
                      validPlaylists.length == artists.length) &&
                  e.owner?.displayName != "Spotify";
            },
            orElse: () => radios.first,
          );

          final tracks =
              await spotify.playlists.getTracksByPlaylistId(radio.id!).all();

          await playback.addTracks(
            tracks.toList()
              ..removeWhere((e) {
                final playlist = ref.read(audioPlayerProvider);
                final isDuplicate = playlist.tracks.any((t) => t.id == e.id);
                return e.id == track.id || isDuplicate;
              }),
          );
        } catch (e, stack) {
          AppLogger.reportError(e, stack);
        }
      }

      // Sometimes user can change settings for which the currentIndexChanged
      // might not be called. So we need to check if the current track is the
      // last track and if it is then we need to call the listener manually.
      if (playlist.index == playlist.medias.length - 1 &&
          audioPlayer.isPlaying) {
        listener(playlist.index);
      }

      final subscription =
          audioPlayer.currentIndexChangedStream.listen(listener);

      return subscription.cancel;
    },
    [
      spotify,
      playback,
      playlist.medias,
      endlessPlayback,
      auth,
    ],
  );
}
