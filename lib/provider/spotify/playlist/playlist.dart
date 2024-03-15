part of '../spotify.dart';

final playlistProvider = FutureProvider.family<Playlist, String>(
  (ref, playlistId) async {
    final spotify = ref.watch(spotifyProvider);
    return spotify.playlists.get(playlistId);
  },
);
