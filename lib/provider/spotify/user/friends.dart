part of '../spotify.dart';

final friendsProvider = FutureProvider<SpotifyFriends>((ref) async {
  final customSpotify = ref.watch(customSpotifyEndpointProvider);

  return customSpotify.getFriendActivity();
});
