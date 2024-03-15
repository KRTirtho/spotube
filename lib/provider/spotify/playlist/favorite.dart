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
}

final favoritePlaylistsProvider =
    AsyncNotifierProvider<FavoritePlaylistsNotifier, FavoritePlaylistsState>(
  () => FavoritePlaylistsNotifier(),
);

final allFavoritePlaylistsProvider = FutureProvider<List<PlaylistSimple>>(
  (ref) async {
    final spotify = ref.watch(spotifyProvider);
    return (await spotify.playlists.me.all()).toList();
  },
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
