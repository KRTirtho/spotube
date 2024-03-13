part of '../spotify.dart';

final artistProvider = FutureProvider.family((ref, String artistId) {
  final spotify = ref.watch(spotifyProvider);

  return spotify.artists.get(artistId);
});
