part of '../spotify.dart';

final trackProvider = FutureProvider.family<Track, String>((ref, id) async {
  final spotify = ref.watch(spotifyProvider);

  return spotify.tracks.get(id);
});
