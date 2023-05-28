import 'dart:convert';

import 'package:http/http.dart' as http;

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
    String? market,
    String? country,
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
}
