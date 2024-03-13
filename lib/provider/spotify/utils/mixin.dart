part of '../spotify.dart';

// ignore: invalid_use_of_internal_member
mixin SpotifyMixin<T> on BuildlessAsyncNotifier<T> {
  SpotifyApi get spotify => ref.read(spotifyProvider);
}
