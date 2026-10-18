import 'dart:math';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class YouTubeVisionOsClient {
  static const String visionOsUserAgent =
      'com.google.visionos.youtube/1.04(RealityDevice17,1; U; CPU visionOS 26_6_0 like Mac OS X; US)';
  static const String androidUserAgent =
      'com.google.android.youtube/20.10.38 (Linux; U; Android 11) gzip';
  static const String iosUserAgent =
      'com.google.ios.youtube/20.10.4 (iPhone16,2; U; CPU iOS 18_3_2 like Mac OS X;)';

  static const String _cpnAlphabet =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_';

  static final Random _random = Random();
  static final Dio _dio = Dio();
  static String? _cachedVisitorData;
  static DateTime? _visitorDataExpiry;

  static String userAgentForUrl(String url) {
    final client = Uri.tryParse(url)?.queryParameters['c'];
    return switch (client) {
      'VISIONOS' => visionOsUserAgent,
      'ANDROID' => androidUserAgent,
      'IOS' => iosUserAgent,
      _ => visionOsUserAgent,
    };
  }

  static String _generateRandomString(int length) {
    return List.generate(
      length,
      (_) => _cpnAlphabet[_random.nextInt(_cpnAlphabet.length)],
    ).join();
  }

  static Map<String, dynamic> get _baseClient => const {
        'clientName': 'VISIONOS',
        'clientVersion': '1.04',
        'clientScreen': 'WATCH',
        'platform': 'MOBILE',
        'deviceMake': 'Apple',
        'deviceModel': 'RealityDevice17,1',
        'osName': 'visionOS',
        'osVersion': '26.6.0.23O770',
        'hl': 'en-GB',
        'gl': 'US',
        'utcOffsetMinutes': 0,
      };

  static Future<String> _getVisitorData() async {
    final now = DateTime.now();
    if (_cachedVisitorData != null &&
        _visitorDataExpiry != null &&
        now.isBefore(_visitorDataExpiry!)) {
      return _cachedVisitorData!;
    }

    final res = await _dio.post(
      'https://www.youtube.com/youtubei/v1/visitor_id?prettyPrint=false',
      data: {
        'context': {
          'client': _baseClient,
          'request': {
            'internalExperimentFlags': const [],
            'useSsl': true,
          },
          'user': {
            'lockedSafetyMode': false,
          },
        },
      },
      options: Options(
        headers: const {
          'User-Agent': visionOsUserAgent,
          'X-Goog-Api-Format-Version': '2',
          'Content-Type': 'application/json',
        },
      ),
    );

    final visitorData = res.data?['responseContext']?['visitorData'] as String?;
    if (visitorData == null || visitorData.isEmpty) {
      throw Exception('Failed to obtain YouTube visitorData');
    }

    _cachedVisitorData = visitorData;
    _visitorDataExpiry = now.add(const Duration(minutes: 30));
    return visitorData;
  }

  static Future<StreamManifest> getStreamManifest(String videoId) async {
    final visitorData = await _getVisitorData();
    final cpn = _generateRandomString(16);
    final tParam = _generateRandomString(12);

    final playerRes = await _dio.post(
      'https://youtubei.googleapis.com/youtubei/v1/player?prettyPrint=false&t=$tParam&id=$videoId',
      data: {
        'videoId': videoId,
        'cpn': cpn,
        'contentCheckOk': true,
        'racyCheckOk': true,
        'context': {
          'client': {
            ..._baseClient,
            'visitorData': visitorData,
          },
          'request': {
            'internalExperimentFlags': const [],
            'useSsl': true,
          },
          'user': {
            'lockedSafetyMode': false,
          },
        },
      },
      options: Options(
        headers: const {
          'User-Agent': visionOsUserAgent,
          'X-Goog-Api-Format-Version': '2',
          'Content-Type': 'application/json',
        },
      ),
    );

    final adaptiveFormats =
        playerRes.data?['streamingData']?['adaptiveFormats'] as List?;
    if (adaptiveFormats == null || adaptiveFormats.isEmpty) {
      _cachedVisitorData = null;
      throw Exception(
        'No adaptiveFormats in VISIONOS response for video $videoId: '
        '${playerRes.data?["playabilityStatus"]}',
      );
    }

    final streams = <AudioOnlyStreamInfo>[];
    for (final raw in adaptiveFormats) {
      if (raw is! Map) continue;
      final mimeTypeStr = raw['mimeType'] as String?;
      final rawUrl = raw['url'] as String?;
      final itag = raw['itag'] as int?;
      final bitrateVal = (raw['bitrate'] ?? raw['averageBitrate']) as int?;

      if (mimeTypeStr == null ||
          !mimeTypeStr.startsWith('audio/') ||
          rawUrl == null ||
          itag == null ||
          bitrateVal == null) {
        continue;
      }

      final audioTrack = raw['audioTrack'];
      if (audioTrack is Map && audioTrack['audioIsDefault'] == false) {
        continue;
      }

      final mediaType = MediaType.parse(mimeTypeStr);
      final container = StreamContainer.parse(mediaType.subtype);
      final contentLength =
          int.tryParse(raw['contentLength']?.toString() ?? '') ?? 0;
      final fileSize =
          contentLength > 0 ? FileSize(contentLength) : FileSize.unknown;
      final codecStr = mediaType.parameters['codecs'] ?? mediaType.subtype;
      final urlWithCpn = rawUrl.contains('cpn=') ? rawUrl : '$rawUrl&cpn=$cpn';

      streams.add(
        AudioOnlyStreamInfo(
          VideoId(videoId),
          itag,
          Uri.parse(urlWithCpn),
          container,
          fileSize,
          Bitrate(bitrateVal),
          codecStr,
          switch (bitrateVal) {
            > 130 * 1024 => 'high',
            > 64 * 1024 => 'medium',
            _ => 'low',
          },
          const [],
          mediaType,
          null,
        ),
      );
    }

    if (streams.isEmpty) {
      throw Exception('No audio streams parsed from VISIONOS for $videoId');
    }

    return StreamManifest(streams);
  }
}
