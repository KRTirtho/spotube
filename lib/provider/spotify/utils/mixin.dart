part of '../spotify.dart';

mixin SpotifyMixin<T> on AsyncNotifier<T> {
  SpotifyApi get spotify => ref.read(spotifyProvider);
}
