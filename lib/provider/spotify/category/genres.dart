part of '../spotify.dart';

final categoryGenresProvider = FutureProvider<List<String>>((ref) async {
  final customSpotify = ref.watch(customSpotifyEndpointProvider);
  return await customSpotify.listGenreSeeds();
});
