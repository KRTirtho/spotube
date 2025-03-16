part of '../spotify.dart';

class FeaturedPlaylistsState extends PaginatedState<PlaylistSimple> {
  FeaturedPlaylistsState({
    required super.items,
    required super.offset,
    required super.limit,
    required super.hasMore,
  });

  @override
  FeaturedPlaylistsState copyWith({
    List<PlaylistSimple>? items,
    int? offset,
    int? limit,
    bool? hasMore,
  }) {
    return FeaturedPlaylistsState(
      items: items ?? this.items,
      offset: offset ?? this.offset,
      limit: limit ?? this.limit,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

class FeaturedPlaylistsNotifier
    extends PaginatedAsyncNotifier<PlaylistSimple, FeaturedPlaylistsState> {
  FeaturedPlaylistsNotifier() : super();

  @override
  fetch(int offset, int limit) async {
    try {
      final playlists = await spotify.playlists.featured.getPage(
        limit,
        offset,
      );

      return playlists.items?.toList() ?? [];
    } catch (e) {
      /// This check only needs to be done once. Since this is one of the very first
      /// request
      ///
      /// If the token is invalid, we refresh it and retry the request.
      /// Same goes for expired tokens
      if ((e is AuthorizationException && e.error == 'invalid_token') ||
          e is ExpirationException) {
        await ref.read(authenticationProvider.notifier).refreshCredentials();

        final playlists = await spotify.playlists.featured.getPage(
          limit,
          offset,
        );
        return playlists.items?.toList() ?? [];
      }
      rethrow;
    }
  }

  @override
  build() async {
    ref.watch(spotifyProvider);
    final playlists = await fetch(0, 20);

    return FeaturedPlaylistsState(
      items: playlists,
      offset: 0,
      limit: 20,
      hasMore: playlists.length == 20,
    );
  }
}

final featuredPlaylistsProvider =
    AsyncNotifierProvider<FeaturedPlaylistsNotifier, FeaturedPlaylistsState>(
  () => FeaturedPlaylistsNotifier(),
);
