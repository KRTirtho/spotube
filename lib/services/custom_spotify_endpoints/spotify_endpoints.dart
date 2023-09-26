import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:spotify/spotify.dart';

class CustomSpotifyEndpoints {
  static const _baseUrl = 'https://api.spotify.com/v1';
  final String accessToken;
  final http.Client _client;

  CustomSpotifyEndpoints(this.accessToken) : _client = http.Client();

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
      if (market != null) 'market': market,
      if (country != null) 'country': country,
    }.entries.map((e) => '${e.key}=${e.value}').join('&');

    final res = await _client.get(
      Uri.parse('$_baseUrl/views/$view?$queryParams'),
      headers: {
        "content-type": "application/json",
        "authorization": "Bearer $accessToken",
        "accept": "application/json",
      },
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      throw Exception(
        '[CustomSpotifyEndpoints.getView]: Failed to get view'
        '\nStatus code: ${res.statusCode}'
        '\nBody: ${res.body}',
      );
    }
  }

  Future<List<String>> listGenreSeeds() async {
    final res = await _client.get(
      Uri.parse("$_baseUrl/recommendations/available-genre-seeds"),
      headers: {
        "content-type": "application/json",
        if (accessToken.isNotEmpty) "authorization": "Bearer $accessToken",
        "accept": "application/json",
      },
    );

    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      return List<String>.from(body["genres"] ?? []);
    } else {
      throw Exception(
        '[CustomSpotifyEndpoints.listGenreSeeds]: Failed to get genre seeds'
        '\nStatus code: ${res.statusCode}'
        '\nBody: ${res.body}',
      );
    }
  }

  void _addList(
      Map<String, String> parameters, String key, Iterable<String> paramList) {
    if (paramList.isNotEmpty) {
      parameters[key] = paramList.join(',');
    }
  }

  void _addTunableTrackMap(
      Map<String, String> parameters, Map<String, num>? tunableTrackMap) {
    if (tunableTrackMap != null) {
      parameters.addAll(tunableTrackMap.map<String, String>((k, v) =>
          MapEntry(k, v is int ? v.toString() : v.toStringAsFixed(2))));
    }
  }

  Future<List<Track>> getRecommendations({
    Iterable<String>? seedArtists,
    Iterable<String>? seedGenres,
    Iterable<String>? seedTracks,
    int limit = 20,
    Market? market,
    Map<String, num>? max,
    Map<String, num>? min,
    Map<String, num>? target,
  }) async {
    assert(limit >= 1 && limit <= 100, 'limit should be 1 <= limit <= 100');
    final seedsNum = (seedArtists?.length ?? 0) +
        (seedGenres?.length ?? 0) +
        (seedTracks?.length ?? 0);
    assert(
        seedsNum >= 1 && seedsNum <= 5,
        'Up to 5 seed values may be provided in any combination of seed_artists,'
        ' seed_tracks and seed_genres.');
    final parameters = <String, String>{'limit': limit.toString()};
    final _ = {
      'seed_artists': seedArtists,
      'seed_genres': seedGenres,
      'seed_tracks': seedTracks
    }.forEach((key, list) => _addList(parameters, key, list!));
    if (market != null) parameters['market'] = market.name;
    for (var map in [min, max, target]) {
      _addTunableTrackMap(parameters, map);
    }
    final pathQuery =
        "$_baseUrl/recommendations?${parameters.entries.map((e) => '${e.key}=${e.value}').join('&')}";
    final res = await _client.get(
      Uri.parse(pathQuery),
      headers: {
        "content-type": "application/json",
        if (accessToken.isNotEmpty) "authorization": "Bearer $accessToken",
        "accept": "application/json",
      },
    );
    final result = jsonDecode(res.body);
    return List.castFrom<dynamic, Track>(
      result["tracks"].map((track) => Track.fromJson(track)).toList(),
    );
  }
}
