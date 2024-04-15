part of '../spotify.dart';

final meProvider = FutureProvider<User>((ref) async {
  final spotify = ref.watch(spotifyProvider);
  return spotify.me.get();
});
