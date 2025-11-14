import 'package:dio/dio.dart';
import 'package:spotube/models/audio_quality.dart';
import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/services/dio/retry_interceptor.dart';

class DabMusicApi {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://dabmusic.xyz/api',
      followRedirects: false,
      validateStatus: (status) {
        return status != null && status < 500;
      },
    ),
  );

  DabMusicApi() {
    _dio.interceptors.add(
      RetryInterceptor(
        dio: _dio,
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

  Future<String> getStreamUrl(
    String trackId, {
    AudioQuality quality = AudioQuality.high,
  }) async {
    try {
      final response = await _dio.get(
        '/stream',
        queryParameters: {
          'trackId': trackId,
          'quality': quality.toDabMusicQuality(),
        },
      );

      if (response.statusCode == 302) {
        return response.headers.value('location')!;
      } else {
        throw Exception('Failed to get stream URL');
      }
    } catch (e) {
      throw Exception('Failed to get stream URL: $e');
    }
  }

  Future<String> getDownloadUrl(
    String trackId, {
    AudioQuality quality = AudioQuality.high,
  }) async {
    try {
      final response = await _dio.get(
        '/download',
        queryParameters: {
          'trackId': trackId,
          'quality': quality.toDabMusicQuality(),
        },
      );

      if (response.statusCode == 302) {
        return response.headers.value('location')!;
      } else {
        throw Exception('Failed to get download URL');
      }
    } catch (e) {
      throw Exception('Failed to get download URL: $e');
    }
  }
}
