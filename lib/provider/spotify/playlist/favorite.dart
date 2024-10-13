part of '../spotify.dart';

class FavoritePlaylistsState extends PaginatedState<PlaylistSimple> {
  FavoritePlaylistsState({
    required super.items,
    required super.offset,
    required super.limit,
    required super.hasMore,
  });

  @override
  FavoritePlaylistsState copyWith({
    List<PlaylistSimple>? items,
    int? offset,
    int? limit,
    bool? hasMore,
  }) {
    return FavoritePlaylistsState(
      items: items ?? this.items,
      offset: offset ?? this.offset,
      limit: limit ?? this.limit,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

class FavoritePlaylistsNotifier
    extends PaginatedAsyncNotifier<PlaylistSimple, FavoritePlaylistsState> {
  FavoritePlaylistsNotifier() : super();

  @override
  fetch(int offset, int limit) async {
    final playlists = await spotify.playlists.me.getPage(
      limit,
      offset,
    );

    return playlists.items?.toList() ?? [];
  }

  @override
  build() async {
    ref.watch(spotifyProvider);
    final playlists = await fetch(0, 20);

    return FavoritePlaylistsState(
      items: playlists,
      offset: 0,
      limit: 20,
      hasMore: playlists.length == 20,
    );
  }

  void updatePlaylist(PlaylistSimple playlist) {
    if (state.value == null) return;

    if (state.value!.items.none((e) => e.id == playlist.id)) return;

    state = AsyncData(
      state.value!.copyWith(
        items: state.value!.items
            .map((element) => element.id == playlist.id ? playlist : element)
            .toList(),
      ),
    );
  }

  Future<void> addFavorite(PlaylistSimple playlist) async {
    await update((state) async {
      await spotify.playlists.followPlaylist(playlist.id!);
      return state.copyWith(
        items: [...state.items, playlist],
      );
    });

    ref.invalidate(isFavoritePlaylistProvider(playlist.id!));
  }

  Future<void> removeFavorite(PlaylistSimple playlist) async {
    await update((state) async {
      await spotify.playlists.unfollowPlaylist(playlist.id!);
      return state.copyWith(
        items: state.items.where((e) => e.id != playlist.id).toList(),
      );
    });

    ref.invalidate(isFavoritePlaylistProvider(playlist.id!));
  }

  Future<void> addTracks(String playlistId, List<String> trackIds) async {
    if (state.value == null) return;

    final spotify = ref.read(spotifyProvider);

    await spotify.playlists.addTracks(
      trackIds.map((id) => 'spotify:track:$id').toList(),
      playlistId,
    );

    ref.invalidate(playlistTracksProvider(playlistId));
  }

  Future<void> removeTracks(String playlistId, List<String> trackIds) async {
    if (state.value == null) return;

    final spotify = ref.read(spotifyProvider);

    await spotify.playlists.removeTracks(
      trackIds.map((id) => 'spotify:track:$id').toList(),
      playlistId,
    );

    ref.invalidate(playlistTracksProvider(playlistId));
  }
}

final favoritePlaylistsProvider =
    AsyncNotifierProvider<FavoritePlaylistsNotifier, FavoritePlaylistsState>(
  () => FavoritePlaylistsNotifier(),
);

final isFavoritePlaylistProvider = FutureProvider.family<bool, String>(
  (ref, id) async {
    final spotify = ref.watch(spotifyProvider);
    final me = ref.watch(meProvider);

    if (me.value == null) {
      return false;
    }

    final follows =
        await spotify.playlists.followedByUsers(id, [me.value!.id!]);

    return follows[me.value!.id!] ?? false;
  },
);
