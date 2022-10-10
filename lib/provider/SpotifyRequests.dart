import 'dart:convert';

import 'package:fl_query/fl_query.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotube/models/Logger.dart';
import 'package:spotube/models/LyricsModels.dart';
import 'package:spotube/provider/Playback.dart';
import 'package:spotube/provider/SpotifyDI.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/provider/UserPreferences.dart';
import 'package:collection/collection.dart';
import 'package:spotube/utils/service_utils.dart';
import 'package:spotube/utils/type_conversion_utils.dart';

final categoriesQueryJob =
    InfiniteQueryJob<Page<Category>, Map<String, dynamic>, int>(
  queryKey: "categories-query",
  initialParam: 0,
  getNextPageParam: (lastPage, lastParam) => lastPage.nextOffset,
  getPreviousPageParam: (lastPage, lastParam) => lastPage.nextOffset - 16,
  refetchOnExternalDataChange: true,
  task: (queryKey, pageParam, data) async {
    final SpotifyApi spotify = data["spotify"] as SpotifyApi;
    final String recommendationMarket = data["recommendationMarket"];
    final categories = await spotify.categories
        .list(country: recommendationMarket)
        .getPage(15, pageParam);

    return categories;
  },
);

final categoryPlaylistsQueryJob =
    InfiniteQueryJob.withVariableKey<Page<PlaylistSimple>, SpotifyApi, int>(
  preQueryKey: "category-playlists",
  initialParam: 0,
  getNextPageParam: (lastPage, lastParam) => lastPage.nextOffset,
  getPreviousPageParam: (lastPage, lastParam) => lastPage.nextOffset - 6,
  task: (queryKey, pageKey, spotify) {
    final id = getVariable(queryKey);
    return (id != "user-featured-playlists"
            ? spotify.playlists.getByCategoryId(id)
            : spotify.playlists.featured)
        .getPage(5, pageKey);
  },
);

final currentUserPlaylistsQueryJob =
    QueryJob<Iterable<PlaylistSimple>, SpotifyApi>(
  queryKey: "current-user-query",
  task: (_, spotify) {
    return spotify.playlists.me.all();
  },
);

final currentUserAlbumsQueryJob = QueryJob<Iterable<AlbumSimple>, SpotifyApi>(
  queryKey: "current-user-albums",
  task: (_, spotify) {
    return spotify.me.savedAlbums().all();
  },
);

final currentUserFollowingArtistsQuery =
    FutureProvider.family<CursorPage<Artist>, String>(
  (ref, pageKey) {
    final spotify = ref.watch(spotifyProvider);
    return spotify.me.following(FollowingType.artist).getPage(15, pageKey);
  },
);

final currentUserFollowingArtistsQueryJob =
    InfiniteQueryJob<CursorPage<Artist>, SpotifyApi, String>(
  queryKey: "user-following-artists",
  initialParam: "",
  getNextPageParam: (lastPage, lastParam) => lastPage.after,
  getPreviousPageParam: (lastPage, lastParam) =>
      lastPage.metadata.previous ?? "",
  task: (queryKey, pageKey, spotify) {
    return spotify.me.following(FollowingType.artist).getPage(15, pageKey);
  },
);

final artistProfileQuery = FutureProvider.family<Artist, String>(
  (ref, id) {
    final spotify = ref.watch(spotifyProvider);
    return spotify.artists.get(id);
  },
);

final currentUserFollowsArtistQuery = FutureProvider.family<bool, String>(
  (ref, artistId) async {
    final spotify = ref.watch(spotifyProvider);
    final result = await spotify.me.isFollowing(
      FollowingType.artist,
      [artistId],
    );
    return result.first;
  },
);

final artistTopTracksQuery =
    FutureProvider.family<Iterable<Track>, String>((ref, id) {
  final spotify = ref.watch(spotifyProvider);
  return spotify.artists.getTopTracks(id, "US");
});

final artistAlbumsQuery = FutureProvider.family<Page<Album>, String>(
  (ref, id) {
    final spotify = ref.watch(spotifyProvider);
    return spotify.artists.albums(id).getPage(5, 0);
  },
);

final artistAlbumsQueryJob =
    InfiniteQueryJob.withVariableKey<Page<Album>, SpotifyApi, int>(
  preQueryKey: "artist-albums",
  initialParam: 0,
  getNextPageParam: (lastPage, lastParam) => lastPage.nextOffset,
  getPreviousPageParam: (lastPage, lastParam) => lastPage.nextOffset - 6,
  task: (queryKey, pageKey, spotify) {
    final id = getVariable(queryKey);
    return spotify.artists.albums(id).getPage(5, pageKey);
  },
);

final artistRelatedArtistsQuery =
    FutureProvider.family<Iterable<Artist>, String>(
  (ref, id) {
    final spotify = ref.watch(spotifyProvider);
    return spotify.artists.getRelatedArtists(id);
  },
);

final currentUserSavedTracksQuery = FutureProvider<List<Track>>((ref) {
  final spotify = ref.watch(spotifyProvider);
  return spotify.tracks.me.saved.all().then(
        (tracks) => tracks.map((e) => e.track!).toList(),
      );
});

final playlistTracksQuery = FutureProvider.family<List<Track>, String>(
  (ref, id) {
    try {
      final spotify = ref.watch(spotifyProvider);
      return id != "user-liked-tracks"
          ? spotify.playlists.getTracksByPlaylistId(id).all().then(
                (value) => value.toList(),
              )
          : spotify.tracks.me.saved.all().then(
                (tracks) => tracks.map((e) => e.track!).toList(),
              );
    } catch (e, stack) {
      getLogger("playlistTracksQuery").e(
        "Fetching playlist tracks",
        e,
        stack,
      );
      return [];
    }
  },
);

final albumTracksQuery = FutureProvider.family<List<TrackSimple>, String>(
  (ref, id) {
    final spotify = ref.watch(spotifyProvider);
    return spotify.albums.getTracks(id).all().then((value) => value.toList());
  },
);

final currentUserQuery = FutureProvider<User>(
  (ref) async {
    final spotify = ref.watch(spotifyProvider);
    final me = await spotify.me.get();
    if (me.images == null || me.images?.isEmpty == true) {
      me.images = [
        Image()
          ..height = 50
          ..width = 50
          ..url = TypeConversionUtils.image_X_UrlString(
            me.images,
            placeholder: ImagePlaceholder.artist,
          ),
      ];
    }
    return me;
  },
);

final playlistIsFollowedQuery = FutureProvider.family<bool, String>(
  (ref, raw) {
    final data = jsonDecode(raw);
    final playlistId = data["playlistId"] as String;
    final userId = data["userId"] as String;
    final spotify = ref.watch(spotifyProvider);
    return spotify.playlists
        .followedBy(playlistId, [userId]).then((value) => value.first);
  },
);

final albumIsSavedForCurrentUserQuery =
    FutureProvider.family<bool, String>((ref, albumId) {
  final spotify = ref.watch(spotifyProvider);
  return spotify.me.isSavedAlbums([albumId]).then((value) => value.first);
});

final searchQuery = FutureProvider.family<List<Page>, String>((ref, term) {
  final spotify = ref.watch(spotifyProvider);
  if (term.isEmpty) return [];
  return spotify.search.get(term).first(10);
});

final geniusLyricsQuery = FutureProvider<String?>(
  (ref) {
    final currentTrack = ref.watch(playbackProvider.select((s) => s.track));
    final geniusAccessToken =
        ref.watch(userPreferencesProvider.select((s) => s.geniusAccessToken));
    if (currentTrack == null) {
      return "“Give this player a track to play”\n- S'Challa";
    }
    return ServiceUtils.getLyrics(
      currentTrack.name!,
      currentTrack.artists?.map((s) => s.name).whereNotNull().toList() ?? [],
      apiKey: geniusAccessToken,
      optimizeQuery: true,
    );
  },
);

final rentanadviserLyricsQuery = FutureProvider<SubtitleSimple?>(
  (ref) {
    final currentTrack = ref.watch(playbackProvider.select((s) => s.track));
    if (currentTrack == null) return null;
    return ServiceUtils.getTimedLyrics(currentTrack);
  },
);
