part of '../spotify.dart';

typedef PlaylistInput = ({
  String playlistName,
  bool? public,
  bool? collaborative,
  String? description,
  String? base64Image,
});

class PlaylistNotifier extends FamilyAsyncNotifier<Playlist, String> {
  @override
  FutureOr<Playlist> build(String arg) {
    final spotify = ref.watch(spotifyProvider);
    return spotify.playlists.get(arg);
  }

  Future<void> create(PlaylistInput input, [ValueChanged? onError]) async {
    if (state is AsyncLoading) return;
    state = const AsyncLoading();

    final spotify = ref.read(spotifyProvider);
    final me = ref.read(meProvider);

    if (me.value == null) return;

    state = await AsyncValue.guard(() async {
      try {
        final playlist = await spotify.playlists.createPlaylist(
          me.value!.id!,
          input.playlistName,
          collaborative: input.collaborative,
          description: input.description,
          public: input.public,
        );

        if (input.base64Image != null) {
          await spotify.playlists.updatePlaylistImage(
            playlist.id!,
            input.base64Image!,
          );
        }

        return playlist;
      } catch (e) {
        onError?.call(e);
        rethrow;
      }
    });

    ref.invalidate(favoritePlaylistsProvider);
  }

  Future<void> modify(PlaylistInput input, [ValueChanged? onError]) async {
    if (state.value == null) return;

    final spotify = ref.read(spotifyProvider);

    await update((state) async {
      try {
        await spotify.playlists.updatePlaylist(
          state.id!,
          input.playlistName,
          collaborative: input.collaborative,
          description: input.description,
          public: input.public,
        );

        if (input.base64Image != null) {
          await spotify.playlists.updatePlaylistImage(
            state.id!,
            input.base64Image!,
          );
        }

        return spotify.playlists.get(state.id!);
      } catch (e) {
        onError?.call(e);
        rethrow;
      }
    });

    ref.invalidate(favoritePlaylistsProvider);
  }
}

final playlistProvider =
    AsyncNotifierProviderFamily<PlaylistNotifier, Playlist, String>(
  () => PlaylistNotifier(),
);
