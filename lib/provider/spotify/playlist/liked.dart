part of '../spotify.dart';

class LikedTracksNotifier extends AsyncNotifier<List<Track>> {
  @override
  FutureOr<List<Track>> build() async {
    final spotify = ref.watch(spotifyProvider);
    final savedTracked = await spotify.tracks.me.saved.all();

    return savedTracked.map((e) => e.track!).toList();
  }

  Future<void> toggleFavorite(Track track) async {
    if (state.value == null) return;
    final spotify = ref.read(spotifyProvider);

    await update((tracks) async {
      final isLiked = tracks.map((e) => e.id).contains(track.id);

      if (isLiked) {
        await spotify.tracks.me.removeOne(track.id!);
        return tracks.where((e) => e.id != track.id).toList();
      } else {
        await spotify.tracks.me.saveOne(track.id!);
        return [track, ...tracks];
      }
    });
  }
}

final likedTracksProvider =
    AsyncNotifierProvider<LikedTracksNotifier, List<Track>>(
  () => LikedTracksNotifier(),
);
