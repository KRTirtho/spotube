part of '../spotify.dart';

// ignore: invalid_use_of_internal_member
mixin SpotifyMixin<T> on AsyncNotifierBase<T> {
  SpotifyApiWrapper get spotify => ref.read(spotifyProvider);
}

extension on AutoDisposeAsyncNotifierProviderRef {
  // When invoked keeps your provider alive for [duration]
  void cacheFor([Duration duration = const Duration(minutes: 5)]) {
    final link = keepAlive();
    final timer = Timer(duration, () => link.close());
    onDispose(() => timer.cancel());
  }
}

extension on AutoDisposeRef {
  // When invoked keeps your provider alive for [duration]
  void cacheFor([Duration duration = const Duration(minutes: 5)]) {
    final link = keepAlive();
    final timer = Timer(duration, () => link.close());
    onDispose(() => timer.cancel());
  }
}
