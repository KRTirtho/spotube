import 'package:dio/dio.dart';
import 'package:dio_retry/dio_retry.dart';
import 'package:spotube/models/metadata/metadata.dart';

class DabMusicApi {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://dabmusic.xyz/api'));

  DabMusicApi() {
    _dio.interceptors.add(
      RetryInterceptor(
        dio: _dio,
        options: const RetryOptions(
          retries: 3,
          retryInterval: Duration(seconds: 1),
        ),
      ),
    );
  }

  Future<List<SpotubeTrackObject>> search(
    String query, {
    int limit = 20,
  }) async {
    try {
      final response = await _dio.get(
        '/search',
        queryParameters: {
          'q': query,
          'type': 'track',
          'limit': limit,
        },
      );

      if (response.statusCode == 200) {
        final tracks = (response.data['tracks'] as List)
            .map((track) => SpotubeTrackObject.fromDabMusicJson(track))
            .toList();
        return tracks;
      } else {
        throw Exception('Failed to search tracks');
      }
    } catch (e) {
      throw Exception('Failed to search tracks: $e');
    }
  }

  Future<String> getStreamUrl(String trackId, {String quality = '27'}) async {
    try {
      final response = await _dio.get(
        '/stream',
        queryParameters: {
          'trackId': trackId,
          'quality': quality,
        },
      );

      if (response.statusCode == 200) {
        return response.data['streamUrl'];
      } else {
        throw Exception('Failed to get stream URL');
      }
    } catch (e) {
      throw Exception('Failed to get stream URL: $e');
    }
  }

  Future<String> getDownloadUrl(String albumId, {String quality = '27'}) async {
    try {
      final response = await _dio.get(
        '/download',
        queryParameters: {
          'albumId': albumId,
          'quality': quality,
        },
      );

      if (response.statusCode == 200) {
        // Assuming the API returns a direct download link or a JSON with the link
        return response.data['downloadUrl'];
      } else {
        throw Exception('Failed to get download URL');
      }
    } catch (e) {
      throw Exception('Failed to get download URL: $e');
    }
  }
}
