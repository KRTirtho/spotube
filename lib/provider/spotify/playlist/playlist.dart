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
    return spotify.invoke(
      (api) => api.playlists.get(arg),
    );
  }

  Future<void> create(PlaylistInput input, [ValueChanged? onError]) async {
    if (state is AsyncLoading) return;
    state = const AsyncLoading();

    final spotify = ref.read(spotifyProvider);
    final me = ref.read(meProvider);

    if (me.value == null) return;

    state = await AsyncValue.guard(() async {
      try {
        final playlist = await spotify.invoke(
          (api) => api.playlists.createPlaylist(
            me.value!.id!,
            input.playlistName,
            collaborative: input.collaborative,
            description: input.description,
            public: input.public,
          ),
        );

        if (input.base64Image != null) {
          await spotify.invoke(
            (api) => api.playlists.updatePlaylistImage(
              playlist.id!,
              input.base64Image!,
            ),
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
        await spotify.invoke(
          (api) => api.playlists.updatePlaylist(
            state.id!,
            input.playlistName,
            collaborative: input.collaborative,
            description: input.description,
            public: input.public,
          ),
        );

        if (input.base64Image != null) {
          await spotify.invoke(
            (api) => api.playlists.updatePlaylistImage(
              state.id!,
              input.base64Image!,
            ),
          );

          final playlist = await spotify.invoke(
            (api) => api.playlists.get(state.id!),
          );

          ref.read(favoritePlaylistsProvider.notifier).updatePlaylist(playlist);
          return playlist;
        }

        final playlist = Playlist.fromJson(
          {
            ...state.toJson(),
            'name': input.playlistName,
            'collaborative': input.collaborative,
            'description': input.description,
            'public': input.public,
          },
        );

        ref.read(favoritePlaylistsProvider.notifier).updatePlaylist(playlist);

        return playlist;
      } catch (e, stack) {
        onError?.call(e);
        AppLogger.reportError(e, stack);
        rethrow;
      }
    });
  }

  Future<void> addTracks(List<String> trackIds, [ValueChanged? onError]) async {
    try {
      if (state.value == null) return;

      final spotify = ref.read(spotifyProvider);

      await spotify.invoke(
        (api) => api.playlists.addTracks(
          trackIds.map((id) => "spotify:track:$id").toList(),
          state.value!.id!,
        ),
      );
    } catch (e, stack) {
      onError?.call(e);
      AppLogger.reportError(e, stack);
      rethrow;
    }
  }
}

final playlistProvider =
    AsyncNotifierProvider.family<PlaylistNotifier, Playlist, String>(
  () => PlaylistNotifier(),
);

final _blendModes = BlendMode.values
    .where((e) => switch (e) {
          BlendMode.clear ||
          BlendMode.src ||
          BlendMode.srcATop ||
          BlendMode.srcIn ||
          BlendMode.srcOut ||
          BlendMode.srcOver ||
          BlendMode.dstOut ||
          BlendMode.xor =>
            false,
          _ => true
        })
    .toList();

typedef PlaylistImageInfo = ({
  Color color,
  BlendMode colorBlendMode,
  String src,
  Alignment placement,
});

final playlistImageProvider = Provider.family<PlaylistImageInfo, String>(
  (ref, playlistId) {
    final random = Random();

    return (
      color: Colors.primaries[random.nextInt(Colors.primaries.length)],
      colorBlendMode: _blendModes[random.nextInt(_blendModes.length)],
      src: Assets
          .patterns.values[random.nextInt(Assets.patterns.values.length)].path,
      placement: random.nextBool() ? Alignment.topLeft : Alignment.bottomLeft,
    );
  },
);
