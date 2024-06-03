part of '../spotify.dart';

final relatedArtistsProvider = FutureProvider.autoDispose
    .family<List<Artist>, String>((ref, artistId) async {
  ref.cacheFor();

  final spotify = ref.watch(spotifyProvider);
  final artists = await spotify.artists.relatedArtists(artistId);

  return artists.toList();
});
