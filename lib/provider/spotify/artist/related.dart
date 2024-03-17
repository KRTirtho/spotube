part of '../spotify.dart';

final relatedArtistsProvider =
    FutureProvider.family<List<Artist>, String>((ref, artistId) async {
  final spotify = ref.watch(spotifyProvider);
  final artists = await spotify.artists.relatedArtists(artistId);

  return artists.toList();
});
