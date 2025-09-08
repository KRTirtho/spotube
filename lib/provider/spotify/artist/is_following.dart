part of '../spotify.dart';

final artistIsFollowingProvider = FutureProvider.family(
  (ref, String artistId) async {
    final spotify = ref.watch(spotifyProvider);
    return spotify.invoke(
      (api) => api.me.checkFollowing(FollowingType.artist, [artistId]).then(
        (value) => value[artistId] ?? false,
      ),
    );
  },
);
