import 'package:fl_query/fl_query.dart';
import 'package:spotube/models/LyricsModels.dart';
import 'package:spotube/models/SpotubeTrack.dart';
import 'package:spotify/spotify.dart';
import 'package:collection/collection.dart';
import 'package:spotube/utils/service_utils.dart';
import 'package:spotube/utils/type_conversion_utils.dart';
import 'package:tuple/tuple.dart';

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
  queryKey: "current-user-playlists",
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

final artistProfileQueryJob = QueryJob.withVariableKey<Artist, SpotifyApi>(
  preQueryKey: "artist-profile",
  task: (queryKey, externalData) =>
      externalData.artists.get(getVariable(queryKey)),
);

final artistTopTracksQueryJob =
    QueryJob.withVariableKey<Iterable<Track>, SpotifyApi>(
  preQueryKey: "artist-top-track-query",
  task: (queryKey, spotify) {
    return spotify.artists.getTopTracks(getVariable(queryKey), "US");
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

final artistRelatedArtistsQueryJob =
    QueryJob.withVariableKey<Iterable<Artist>, SpotifyApi>(
  preQueryKey: "artist-related-artist-query",
  task: (queryKey, spotify) {
    return spotify.artists.getRelatedArtists(getVariable(queryKey));
  },
);

final currentUserFollowsArtistQueryJob =
    QueryJob.withVariableKey<bool, SpotifyApi>(
  preQueryKey: "user-follows-artists-query",
  task: (artistId, spotify) async {
    final result = await spotify.me.isFollowing(
      FollowingType.artist,
      [getVariable(artistId)],
    );
    return result.first;
  },
);

final playlistTracksQueryJob =
    QueryJob.withVariableKey<List<Track>, SpotifyApi>(
  preQueryKey: "playlist-tracks",
  task: (queryKey, spotify) {
    final id = getVariable(queryKey);
    return id != "user-liked-tracks"
        ? spotify.playlists.getTracksByPlaylistId(id).all().then(
              (value) => value.toList(),
            )
        : spotify.tracks.me.saved.all().then(
              (tracks) => tracks.map((e) => e.track!).toList(),
            );
  },
);

final albumTracksQueryJob =
    QueryJob.withVariableKey<List<TrackSimple>, SpotifyApi>(
  preQueryKey: "album-tracks",
  task: (queryKey, spotify) {
    final id = getVariable(queryKey);
    return spotify.albums.getTracks(id).all().then((value) => value.toList());
  },
);

final currentUserQueryJob = QueryJob<User, SpotifyApi>(
  queryKey: "current-user",
  refetchOnExternalDataChange: true,
  task: (_, spotify) async {
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

final playlistIsFollowedQueryJob = QueryJob.withVariableKey<bool, SpotifyApi>(
  preQueryKey: "playlist-is-followed",
  task: (queryKey, spotify) {
    final idMap = getVariable(queryKey).split(":");

    return spotify.playlists.followedBy(idMap.first, [idMap.last]).then(
      (value) => value.first,
    );
  },
);

final albumIsSavedForCurrentUserQueryJob =
    QueryJob.withVariableKey<bool, SpotifyApi>(task: (queryKey, spotify) {
  return spotify.me
      .isSavedAlbums([getVariable(queryKey)]).then((value) => value.first);
});

final searchMutationJob = MutationJob<List<Page>, Tuple2<String, SpotifyApi>>(
  mutationKey: "search-query",
  task: (ref, variables) {
    final queryString = variables.item1;
    final spotify = variables.item2;
    if (queryString.isEmpty) return [];
    return spotify.search.get(queryString).first(10);
  },
);

final geniusLyricsQueryJob = QueryJob<String, Tuple2<Track?, String>>(
  queryKey: "genius-lyrics-query",
  task: (_, externalData) async {
    final currentTrack = externalData.item1;
    final geniusAccessToken = externalData.item2;
    if (currentTrack == null) {
      return "“Give this player a track to play”\n- S'Challa";
    }
    final lyrics = await ServiceUtils.getLyrics(
      currentTrack.name!,
      currentTrack.artists?.map((s) => s.name).whereNotNull().toList() ?? [],
      apiKey: geniusAccessToken,
      optimizeQuery: true,
    );

    if (lyrics == null) throw Exception("Unable find lyrics");
    return lyrics;
  },
);

final rentanadviserLyricsQueryJob = QueryJob<SubtitleSimple, SpotubeTrack?>(
  queryKey: "synced-lyrics",
  task: (_, currentTrack) async {
    if (currentTrack == null) throw "No track currently";

    final timedLyrics = await ServiceUtils.getTimedLyrics(currentTrack);
    if (timedLyrics == null) throw Exception("Unable to find lyrics");

    return timedLyrics;
  },
);

final toggleFavoriteTrackMutationJob =
    MutationJob.withVariableKey<bool, Tuple2<SpotifyApi, bool>>(
  preMutationKey: "toggle-track-like",
  task: (queryKey, externalData) async {
    final trackId = getVariable(queryKey);
    final spotify = externalData.item1;
    final isLiked = externalData.item2;

    if (isLiked) {
      await spotify.tracks.me.removeOne(trackId);
    } else {
      await spotify.tracks.me.saveOne(trackId);
    }
    return !isLiked;
  },
);

final toggleFavoritePlaylistMutationJob =
    MutationJob.withVariableKey<bool, Tuple2<SpotifyApi, bool>>(
  preMutationKey: "toggle-playlist-like",
  task: (queryKey, externalData) async {
    final playlistId = getVariable(queryKey);
    final spotify = externalData.item1;
    final isLiked = externalData.item2;

    if (isLiked) {
      await spotify.playlists.unfollowPlaylist(playlistId);
    } else {
      await spotify.playlists.followPlaylist(playlistId);
    }
    return !isLiked;
  },
);

final toggleFavoriteAlbumMutationJob =
    MutationJob.withVariableKey<bool, Tuple2<SpotifyApi, bool>>(
  preMutationKey: "toggle-album-like",
  task: (queryKey, externalData) async {
    final albumId = getVariable(queryKey);
    final spotify = externalData.item1;
    final isLiked = externalData.item2;

    if (isLiked) {
      await spotify.me.removeAlbums([albumId]);
    } else {
      await spotify.me.saveAlbums([albumId]);
    }
    return !isLiked;
  },
);
