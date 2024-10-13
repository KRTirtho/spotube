import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/models/spotify/home_feed.dart';
import 'package:spotube/models/spotify_friends.dart';
import 'package:timezone/timezone.dart' as tz;

class CustomSpotifyEndpoints {
  static const _baseUrl = 'https://api.spotify.com/v1';
  final String accessToken;
  final Dio _client;

  CustomSpotifyEndpoints(this.accessToken)
      : _client = Dio(
          BaseOptions(
            baseUrl: _baseUrl,
            responseType: ResponseType.json,
            headers: {
              "content-type": "application/json",
              if (accessToken.isNotEmpty)
                "authorization": "Bearer $accessToken",
              "accept": "application/json",
            },
          ),
        );

  // views API

  /// Get a single view of given genre
  ///
  /// Currently known genres are:
  /// - new-releases-page
  /// - made-for-x-hub (it requires authentication)
  /// - my-mix-genres (it requires authentication)
  /// - artist-seed-mixes (it requires authentication)
  /// - my-mix-decades (it requires authentication)
  /// - my-mix-moods (it requires authentication)
  /// - podcasts-and-more (it requires authentication)
  /// - uniquely-yours-in-hub (it requires authentication)
  /// - made-for-x-dailymix (it requires authentication)
  /// - made-for-x-discovery (it requires authentication)
  Future<Map<String, dynamic>> getView(
    String view, {
    int limit = 20,
    int contentLimit = 10,
    List<String> types = const [
      "album",
      "playlist",
      "artist",
      "show",
      "station",
      "episode",
      "merch",
      "artist_concerts",
      "uri_link"
    ],
    String imageStyle = "gradient_overlay",
    String includeExternal = "audio",
    String? locale,
    Market? market,
    Market? country,
  }) async {
    if (accessToken.isEmpty) {
      throw Exception('[CustomSpotifyEndpoints.getView]: accessToken is empty');
    }

    final queryParams = {
      'limit': limit.toString(),
      'content_limit': contentLimit.toString(),
      'types': types.join(','),
      'image_style': imageStyle,
      'include_external': includeExternal,
      'timestamp': DateTime.now().toUtc().toIso8601String(),
      if (locale != null) 'locale': locale,
      if (market != null) 'market': market.name,
      if (country != null) 'country': country.name,
    }.entries.map((e) => '${e.key}=${e.value}').join('&');

    final res = await _client.getUri(
      Uri.parse('$_baseUrl/views/$view?$queryParams'),
    );

    if (res.statusCode == 200) {
      return res.data;
    } else {
      throw Exception(
        '[CustomSpotifyEndpoints.getView]: Failed to get view'
        '\nStatus code: ${res.statusCode}'
        '\nBody: ${res.data}',
      );
    }
  }

  Future<List<String>> listGenreSeeds() async {
    final res = await _client.getUri(
      Uri.parse("$_baseUrl/recommendations/available-genre-seeds"),
    );

    if (res.statusCode == 200) {
      final body = res.data;
      return List<String>.from(body["genres"] ?? []);
    } else {
      throw Exception(
        '[CustomSpotifyEndpoints.listGenreSeeds]: Failed to get genre seeds'
        '\nStatus code: ${res.statusCode}'
        '\nBody: ${res.data}',
      );
    }
  }

  Future<SpotifyFriends> getFriendActivity() async {
    final res = await _client.getUri(
      Uri.parse("https://guc-spclient.spotify.com/presence-view/v1/buddylist"),
    );
    return SpotifyFriends.fromJson(res.data);
  }

  Future<SpotifyHomeFeed> getHomeFeed({
    required String spTCookie,
    required Market country,
  }) async {
    final headers = {
      'app-platform': 'WebPlayer',
      'authorization': 'Bearer $accessToken',
      'content-type': 'application/json;charset=UTF-8',
      'dnt': '1',
      'origin': 'https://open.spotify.com',
      'referer': 'https://open.spotify.com/'
    };
    final response = await _client.getUri(
      Uri(
        scheme: "https",
        host: "api-partner.spotify.com",
        path: "/pathfinder/v1/query",
        queryParameters: {
          "operationName": "home",
          "variables": jsonEncode({
            "timeZone": tz.local.name,
            "sp_t": spTCookie,
            "country": country.name,
            "facet": null,
            "sectionItemsLimit": 10
          }),
          "extensions": jsonEncode(
            {
              "persistedQuery": {
                "version": 1,

                /// GraphQL persisted Query hash
                /// This can change overtime. We've to lookout for it
                /// Docs: https://www.apollographql.com/docs/graphos/operations/persisted-queries/
                "sha256Hash":
                    "eb3fba2d388cf4fc4d696b1757a58584e9538a3b515ea742e9cc9465807340be",
              }
            },
          ),
        },
      ),
      options: Options(headers: headers),
    );

    final data = SpotifyHomeFeed.fromJson(
      transformHomeFeedJsonMap(response.data),
    );

    return data;
  }

  Future<SpotifyHomeFeedSection> getHomeFeedSection(
    String sectionUri, {
    required String spTCookie,
    required Market country,
  }) async {
    final headers = {
      'app-platform': 'WebPlayer',
      'authorization': 'Bearer $accessToken',
      'content-type': 'application/json;charset=UTF-8',
      'dnt': '1',
      'origin': 'https://open.spotify.com',
      'referer': 'https://open.spotify.com/'
    };
    final response = await _client.getUri(
      Uri(
        scheme: "https",
        host: "api-partner.spotify.com",
        path: "/pathfinder/v1/query",
        queryParameters: {
          "operationName": "homeSection",
          "variables": jsonEncode({
            "timeZone": tz.local.name,
            "sp_t": spTCookie,
            "country": country.name,
            "uri": sectionUri
          }),
          "extensions": jsonEncode(
            {
              "persistedQuery": {
                "version": 1,

                /// GraphQL persisted Query hash
                /// This can change overtime. We've to lookout for it
                /// Docs: https://www.apollographql.com/docs/graphos/operations/persisted-queries/
                "sha256Hash":
                    "eb3fba2d388cf4fc4d696b1757a58584e9538a3b515ea742e9cc9465807340be",
              }
            },
          ),
        },
      ),
      options: Options(headers: headers),
    );

    final data = SpotifyHomeFeedSection.fromJson(
      transformSectionItemJsonMap(
        response.data["data"]["homeSections"]["sections"][0],
      ),
    );

    return data;
  }
}
