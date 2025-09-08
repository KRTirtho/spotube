part of '../spotify.dart';

final artistProvider =
    FutureProvider.autoDispose.family((ref, String artistId) {
  ref.cacheFor();

  final spotify = ref.watch(spotifyProvider);

  return spotify.invoke((api) => api.artists.get(artistId));
});
