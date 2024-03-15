part of '../spotify.dart';

final likedTracksProvider = FutureProvider<List<Track>>((ref) async {
  final spotify = ref.watch(spotifyProvider);
  final savedTracked = await spotify.tracks.me.saved.all();

  return savedTracked.map((e) => e.track!).toList();
});
