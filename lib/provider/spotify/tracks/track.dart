part of '../spotify.dart';

final trackProvider =
    FutureProvider.autoDispose.family<Track, String>((ref, id) async {
  ref.cacheFor();

  final spotify = ref.watch(spotifyProvider);

  return spotify.invoke((api) => api.tracks.get(id));
});
