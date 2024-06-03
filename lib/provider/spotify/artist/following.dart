part of '../spotify.dart';

class FollowedArtistsState extends CursorPaginatedState<Artist> {
  FollowedArtistsState({
    required super.items,
    required super.offset,
    required super.limit,
    required super.hasMore,
  });

  @override
  FollowedArtistsState copyWith({
    List<Artist>? items,
    String? offset,
    int? limit,
    bool? hasMore,
  }) {
    return FollowedArtistsState(
      items: items ?? this.items,
      offset: offset ?? this.offset,
      limit: limit ?? this.limit,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

class FollowedArtistsNotifier
    extends CursorPaginatedAsyncNotifier<Artist, FollowedArtistsState> {
  FollowedArtistsNotifier() : super();

  @override
  fetch(offset, limit) async {
    final artists = await spotify.me.following(FollowingType.artist).getPage(
          limit,
          offset ?? '',
        );

    return (artists.items?.toList() ?? [], artists.after);
  }

  @override
  build() async {
    ref.watch(spotifyProvider);
    final (artists, nextCursor) = await fetch(null, 50);
    return FollowedArtistsState(
      items: artists,
      offset: nextCursor,
      limit: 50,
      hasMore: artists.length == 50,
    );
  }

  Future<void> saveArtists(List<String> artistIds) async {
    if (state.value == null) return;
    await spotify.me.follow(FollowingType.artist, artistIds);

    state = await AsyncValue.guard(() async {
      final artists = await spotify.artists.list(artistIds);

      return state.value!.copyWith(
        items: [
          ...state.value!.items,
          ...artists,
        ],
      );
    });

    for (final id in artistIds) {
      ref.invalidate(artistIsFollowingProvider(id));
    }
  }

  Future<void> removeArtists(List<String> artistIds) async {
    if (state.value == null) return;
    await spotify.me.unfollow(FollowingType.artist, artistIds);

    state = await AsyncValue.guard(() async {
      final artists = state.value!.items.where((artist) {
        return !artistIds.contains(artist.id);
      }).toList();

      return state.value!.copyWith(
        items: artists,
      );
    });

    for (final id in artistIds) {
      ref.invalidate(artistIsFollowingProvider(id));
    }
  }
}

final followedArtistsProvider =
    AsyncNotifierProvider<FollowedArtistsNotifier, FollowedArtistsState>(
  () => FollowedArtistsNotifier(),
);

final allFollowedArtistsProvider = FutureProvider<List<Artist>>(
  (ref) async {
    final spotify = ref.watch(spotifyProvider);
    final artists = await spotify.me.following(FollowingType.artist).all();
    return artists.toList();
  },
);
