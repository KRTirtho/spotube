import 'package:catcher_2/catcher_2.dart';
import 'package:fl_query/fl_query.dart';
import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/library/playlist_generate/recommendation_attribute_dials.dart';
import 'package:spotube/extensions/map.dart';
import 'package:spotube/extensions/track.dart';
import 'package:spotube/hooks/spotify/use_spotify_infinite_query.dart';
import 'package:spotube/hooks/spotify/use_spotify_query.dart';
import 'package:spotube/pages/library/playlist_generate/playlist_generate.dart';
import 'package:spotube/provider/custom_spotify_endpoint_provider.dart';
import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';

typedef RecommendationParameters = ({
  RecommendationAttribute acousticness,
  RecommendationAttribute danceability,
  RecommendationAttribute duration_ms,
  RecommendationAttribute energy,
  RecommendationAttribute instrumentalness,
  RecommendationAttribute key,
  RecommendationAttribute liveness,
  RecommendationAttribute loudness,
  RecommendationAttribute mode,
  RecommendationAttribute popularity,
  RecommendationAttribute speechiness,
  RecommendationAttribute tempo,
  RecommendationAttribute time_signature,
  RecommendationAttribute valence,
});

Map<String, num> recommendationAttributeToMap(RecommendationAttribute attr) => {
      "min": attr.min,
      "target": attr.target,
      "max": attr.max,
    };

({Map<String, num> min, Map<String, num> target, Map<String, num> max})
    recommendationParametersToMap(RecommendationParameters params) {
  final maxMap = <String, num>{
    if (params.acousticness != zeroValues)
      "acousticness": params.acousticness.max,
    if (params.danceability != zeroValues)
      "danceability": params.danceability.max,
    if (params.duration_ms != zeroValues) "duration_ms": params.duration_ms.max,
    if (params.energy != zeroValues) "energy": params.energy.max,
    if (params.instrumentalness != zeroValues)
      "instrumentalness": params.instrumentalness.max,
    if (params.key != zeroValues) "key": params.key.max,
    if (params.liveness != zeroValues) "liveness": params.liveness.max,
    if (params.loudness != zeroValues) "loudness": params.loudness.max,
    if (params.mode != zeroValues) "mode": params.mode.max,
    if (params.popularity != zeroValues) "popularity": params.popularity.max,
    if (params.speechiness != zeroValues) "speechiness": params.speechiness.max,
    if (params.tempo != zeroValues) "tempo": params.tempo.max,
    if (params.time_signature != zeroValues)
      "time_signature": params.time_signature.max,
    if (params.valence != zeroValues) "valence": params.valence.max,
  };
  final minMap = <String, num>{
    if (params.acousticness != zeroValues)
      "acousticness": params.acousticness.min,
    if (params.danceability != zeroValues)
      "danceability": params.danceability.min,
    if (params.duration_ms != zeroValues) "duration_ms": params.duration_ms.min,
    if (params.energy != zeroValues) "energy": params.energy.min,
    if (params.instrumentalness != zeroValues)
      "instrumentalness": params.instrumentalness.min,
    if (params.key != zeroValues) "key": params.key.min,
    if (params.liveness != zeroValues) "liveness": params.liveness.min,
    if (params.loudness != zeroValues) "loudness": params.loudness.min,
    if (params.mode != zeroValues) "mode": params.mode.min,
    if (params.popularity != zeroValues) "popularity": params.popularity.min,
    if (params.speechiness != zeroValues) "speechiness": params.speechiness.min,
    if (params.tempo != zeroValues) "tempo": params.tempo.min,
    if (params.time_signature != zeroValues)
      "time_signature": params.time_signature.min,
    if (params.valence != zeroValues) "valence": params.valence.min,
  };
  final targetMap = <String, num>{
    if (params.acousticness != zeroValues)
      "acousticness": params.acousticness.target,
    if (params.danceability != zeroValues)
      "danceability": params.danceability.target,
    if (params.duration_ms != zeroValues)
      "duration_ms": params.duration_ms.target,
    if (params.energy != zeroValues) "energy": params.energy.target,
    if (params.instrumentalness != zeroValues)
      "instrumentalness": params.instrumentalness.target,
    if (params.key != zeroValues) "key": params.key.target,
    if (params.liveness != zeroValues) "liveness": params.liveness.target,
    if (params.loudness != zeroValues) "loudness": params.loudness.target,
    if (params.mode != zeroValues) "mode": params.mode.target,
    if (params.popularity != zeroValues) "popularity": params.popularity.target,
    if (params.speechiness != zeroValues)
      "speechiness": params.speechiness.target,
    if (params.tempo != zeroValues) "tempo": params.tempo.target,
    if (params.time_signature != zeroValues)
      "time_signature": params.time_signature.target,
    if (params.valence != zeroValues) "valence": params.valence.target,
  };

  return (
    max: maxMap,
    min: minMap,
    target: targetMap,
  );
}

class PlaylistQueries {
  const PlaylistQueries();

  Query<bool, dynamic> doesUserFollow(
    WidgetRef ref,
    String playlistId,
    String userId,
  ) {
    return useSpotifyQuery<bool, dynamic>(
      "playlist-is-followed/$playlistId/$userId",
      (spotify) async {
        final result =
            await spotify.playlists.followedByUsers(playlistId, [userId]);
        return result[userId] ?? false;
      },
      ref: ref,
    );
  }

  InfiniteQuery<Page<PlaylistSimple>, dynamic, int> ofMine(WidgetRef ref) {
    return useSpotifyInfiniteQuery<Page<PlaylistSimple>, dynamic, int>(
      "current-user-playlists",
      (page, spotify) async {
        final playlists = await spotify.playlists.me.getPage(10, page * 10);
        return playlists;
      },
      initialPage: 0,
      nextPage: (lastPage, lastPageData) =>
          (lastPageData.items?.length ?? 0) < 10 || lastPageData.isLast
              ? null
              : lastPage + 1,
      ref: ref,
    );
  }

  Query<List<PlaylistSimple>, dynamic> ofMineAll(WidgetRef ref) {
    return useSpotifyQuery<List<PlaylistSimple>, dynamic>(
      "current-user-all-playlists",
      (spotify) async {
        var page = await spotify.playlists.me.getPage(50);
        final playlists = <PlaylistSimple>[];

        if (page.isLast == true) {
          return page.items?.toList() ?? [];
        }

        playlists.addAll(page.items ?? []);
        while (!page.isLast) {
          page = await spotify.playlists.me.getPage(50, page.nextOffset);
          playlists.addAll(page.items ?? []);
        }

        return playlists;
      },
      ref: ref,
    );
  }

  Future<List<Track>> likedTracks(SpotifyApi spotify) async {
    final tracks = await spotify.tracks.me.saved.all();

    return tracks.map((e) => e.track!).toList();
  }

  Query<List<Track>, dynamic> likedTracksQuery(WidgetRef ref) {
    final query = useCallback((spotify) => likedTracks(spotify), []);
    final context = useContext();

    return useSpotifyQuery<List<Track>, dynamic>(
      "user-liked-tracks",
      query,
      jsonConfig: JsonConfig(
        toJson: (tracks) => <String, dynamic>{
          'tracks': tracks.map((e) => e.toJson()).toList(),
        },
        fromJson: (json) => (json['tracks'] as List)
            .map(
              (e) => Track.fromJson((e as Map).castKeyDeep<String>()),
            )
            .toList(),
      ),
      refreshConfig: RefreshConfig.withDefaults(
        context,
        // will never make it stale
        staleDuration: const Duration(days: 60),
      ),
      ref: ref,
    );
  }

  Query<Playlist, dynamic> byId(WidgetRef ref, String id) {
    return useSpotifyQuery<Playlist, dynamic>(
      "playlist/$id",
      (spotify) async {
        return await spotify.playlists.get(id);
      },
      ref: ref,
    );
  }

  Future<List<Track>> tracksOf(
    int pageParam,
    SpotifyApi spotify,
    String playlistId,
  ) async {
    try {
      final playlists = await spotify.playlists
          .getTracksByPlaylistId(playlistId)
          .getPage(20, pageParam * 20);
      return playlists.items?.toList() ?? <Track>[];
    } catch (e, stack) {
      Catcher2.reportCheckedError(e, stack);
      rethrow;
    }
  }

  int? tracksOfQueryNextPage(int lastPage, List<Track> lastPageData) {
    if (lastPageData.length < 20) {
      return null;
    }
    return lastPage + 1;
  }

  InfiniteQuery<List<Track>, dynamic, int> tracksOfQuery(
    WidgetRef ref,
    String playlistId,
  ) {
    return useSpotifyInfiniteQuery<List<Track>, dynamic, int>(
      "playlist-tracks/$playlistId",
      (page, spotify) => tracksOf(page, spotify, playlistId),
      initialPage: 0,
      nextPage: tracksOfQueryNextPage,
      ref: ref,
    );
  }

  InfiniteQuery<Page<PlaylistSimple>, dynamic, int> featured(
    WidgetRef ref,
  ) {
    return useSpotifyInfiniteQuery<Page<PlaylistSimple>, dynamic, int>(
      "featured-playlists",
      (pageParam, spotify) async {
        try {
          final playlists =
              await spotify.playlists.featured.getPage(5, pageParam);
          return playlists;
        } catch (e, stack) {
          Catcher2.reportCheckedError(e, stack);
          rethrow;
        }
      },
      initialPage: 0,
      nextPage: (lastPage, lastPageData) {
        if (lastPageData.isLast || (lastPageData.items ?? []).length < 5) {
          return null;
        }
        return lastPageData.nextOffset;
      },
      ref: ref,
    );
  }

  Query<List<Track>, dynamic> generate(
    WidgetRef ref, {
    ({List<String> tracks, List<String> artists, List<String> genres})? seeds,
    RecommendationParameters? parameters,
    int limit = 20,
    Market? market,
  }) {
    final marketOfPreference = ref.watch(
      userPreferencesProvider.select((s) => s.recommendationMarket),
    );
    final customSpotify = ref.watch(customSpotifyEndpointProvider);

    final parametersMap =
        parameters == null ? null : recommendationParametersToMap(parameters);

    final query = useQuery<List<Track>, dynamic>(
      "generate-playlist",
      () async {
        final tracks = await customSpotify.getRecommendations(
          limit: limit,
          market: market ?? marketOfPreference,
          max: parametersMap?.max,
          min: parametersMap?.min,
          target: parametersMap?.target,
          seedArtists: seeds?.artists,
          seedGenres: seeds?.genres,
          seedTracks: seeds?.tracks,
        );
        return tracks;
      },
    );

    useEffect(() {
      return ref.listenManual(
        customSpotifyEndpointProvider,
        (previous, next) {
          if (previous != next) {
            query.refresh();
          }
        },
      ).close;
    }, [query]);

    return query;
  }
}
