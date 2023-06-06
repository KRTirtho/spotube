import 'dart:convert';

import 'package:catcher/catcher.dart';
import 'package:fl_query/fl_query.dart';
import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/extensions/map.dart';
import 'package:spotube/extensions/track.dart';
import 'package:spotube/hooks/use_spotify_infinite_query.dart';
import 'package:spotube/hooks/use_spotify_query.dart';
import 'package:spotube/provider/custom_spotify_endpoint_provider.dart';
import 'package:spotube/provider/user_preferences_provider.dart';

typedef RecommendationParameters = ({
  double acousticness,
  double danceability,
  double duration_ms,
  double energy,
  double instrumentalness,
  double key,
  double liveness,
  double loudness,
  double mode,
  double popularity,
  double speechiness,
  double tempo,
  double time_signature,
  double valence,
});

Map<String, num> recommendationParametersToMap(
        RecommendationParameters params) =>
    {
      "acousticness": params.acousticness,
      "danceability": params.danceability,
      "duration_ms": params.duration_ms,
      "energy": params.energy,
      "instrumentalness": params.instrumentalness,
      "key": params.key,
      "liveness": params.liveness,
      "loudness": params.loudness,
      "mode": params.mode,
      "popularity": params.popularity,
      "speechiness": params.speechiness,
      "tempo": params.tempo,
      "time_signature": params.time_signature,
      "valence": params.valence,
    };

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
        final result = await spotify.playlists.followedBy(playlistId, [userId]);
        return result.first;
      },
      ref: ref,
    );
  }

  Query<Iterable<PlaylistSimple>, dynamic> ofMine(WidgetRef ref) {
    return useSpotifyQuery<Iterable<PlaylistSimple>, dynamic>(
      "current-user-playlists",
      (spotify) {
        return spotify.playlists.me.all();
      },
      ref: ref,
    );
  }

  Future<List<Track>> tracksOf(String playlistId, SpotifyApi spotify) {
    if (playlistId == "user-liked-tracks") {
      return spotify.tracks.me.saved.all().then(
            (tracks) => tracks.map((e) => e.track!).toList(),
          );
    }
    return spotify.playlists.getTracksByPlaylistId(playlistId).all().then(
          (value) => value.toList(),
        );
  }

  Query<List<Track>, dynamic> tracksOfQuery(
    WidgetRef ref,
    String playlistId,
  ) {
    return useSpotifyQuery<List<Track>, dynamic>(
      "playlist-tracks/$playlistId",
      (spotify) => tracksOf(playlistId, spotify),
      jsonConfig: playlistId == "user-liked-tracks"
          ? JsonConfig(
              toJson: (tracks) => <String, dynamic>{
                'tracks': tracks.map((e) => e.toJson()).toList()
              },
              fromJson: (json) => (json['tracks'] as List)
                  .map((e) => Track.fromJson(
                        (e as Map).castKeyDeep<String>(),
                      ))
                  .toList(),
            )
          : null,
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
          Catcher.reportCheckedError(e, stack);
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
    RecommendationParameters? min,
    RecommendationParameters? max,
    RecommendationParameters? target,
    int limit = 20,
    String? market,
  }) {
    final marketOfPreference = ref.watch(
      userPreferencesProvider.select((s) => s.recommendationMarket),
    );
    final customSpotify = ref.watch(customSpotifyEndpointProvider);

    final query = useQuery<List<Track>, dynamic>(
      "generate-playlist",
      () async {
        final tracks = await customSpotify.getRecommendations(
          limit: limit,
          market: market ?? marketOfPreference,
          max: max != null ? recommendationParametersToMap(max) : null,
          min: min != null ? recommendationParametersToMap(min) : null,
          target: target != null ? recommendationParametersToMap(target) : null,
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
