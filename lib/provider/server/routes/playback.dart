import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:dio/dio.dart' hide Response;
import 'package:dio/dio.dart' as dio_lib;
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:metadata_god/metadata_god.dart';
import 'package:path/path.dart';
import 'package:shelf/shelf.dart';
import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/models/parser/range_headers.dart';
import 'package:spotube/provider/audio_player/audio_player.dart';
import 'package:spotube/provider/audio_player/state.dart';

import 'package:spotube/provider/server/active_track_sources.dart';
import 'package:spotube/provider/server/sourced_track_provider.dart';
import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';
import 'package:spotube/services/audio_player/audio_player.dart';
import 'package:spotube/services/logger/logger.dart';
import 'package:spotube/services/sourced_track/sourced_track.dart';
import 'package:spotube/utils/service_utils.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

final _deviceClients = Set.unmodifiable({
  YoutubeApiClient.ios,
  YoutubeApiClient.android,
  YoutubeApiClient.mweb,
  YoutubeApiClient.safari,
});

String? get _randomUserAgent => _deviceClients
    .elementAt(
      Random().nextInt(_deviceClients.length),
    )
    .payload["context"]["client"]["userAgent"];

class ServerPlaybackRoutes {
  final Ref ref;
  UserPreferences get userPreferences => ref.read(userPreferencesProvider);
  AudioPlayerState get playlist => ref.read(audioPlayerProvider);
  final Dio dio;

  ServerPlaybackRoutes(this.ref) : dio = Dio();

  Future<String> _getTrackCacheFilePath(SourcedTrack track) async {
    return join(
      await UserPreferencesNotifier.getMusicCacheDir(),
      ServiceUtils.sanitizeFilename(
        '${track.query.name} - ${track.query.artists.map((d) => d.name).join(",")} (${track.info.id}).${track.qualityPreset!.name}',
      ),
    );
  }

  Future<SourcedTrack?> _getSourcedTrack(
    Request request,
    String trackId,
  ) async {
    final track =
        playlist.tracks.firstWhere((element) => element.id == trackId);

    final activeSourcedTrack =
        await ref.read(activeTrackSourcesProvider.future);

    final media = audioPlayer.playlist.medias
        .firstWhere((e) => e.uri == request.requestedUri.toString());
    final spotubeMedia =
        media is SpotubeMedia ? media : SpotubeMedia.media(media);
    final sourcedTrack = activeSourcedTrack?.track.id == track.id
        ? activeSourcedTrack?.source
        : await ref.read(
            sourcedTrackProvider(spotubeMedia.track as SpotubeFullTrackObject)
                .future,
          );

    return sourcedTrack;
  }

  Future<dio_lib.Response> streamTrackInformation(
    Request request,
    SourcedTrack track,
  ) async {
    AppLogger.log.i(
      "HEAD request for track: ${track.query.name}\n"
      "Headers: ${request.headers}",
    );

    final trackCacheFile = File(await _getTrackCacheFilePath(track));

    if (await trackCacheFile.exists() && userPreferences.cacheMusic) {
      final fileLength = await trackCacheFile.length();

      return dio_lib.Response(
        statusCode: 200,
        headers: Headers.fromMap({
          "content-type": ["audio/${track.qualityPreset!.name}"],
          "content-length": ["$fileLength"],
          "accept-ranges": ["bytes"],
          "content-range": ["bytes 0-$fileLength/$fileLength"],
        }),
        requestOptions: RequestOptions(path: request.requestedUri.toString()),
      );
    }

    String url = track.url ??
        await ref
            .read(sourcedTrackProvider(track.query).notifier)
            .swapWithNextSibling()
            .then((track) => track.url!);

    final options = Options(
      headers: {
        "user-agent": _randomUserAgent,
        "Cache-Control": "max-age=3600",
        "Connection": "keep-alive",
        "host": Uri.parse(url).host,
      },
      validateStatus: (status) => status! < 400,
    );

    final res = await dio.head(url, options: options);

    return res;
  }

  Future<({dio_lib.Response<Uint8List> response, Uint8List? bytes})>
      streamTrack(
    Request request,
    SourcedTrack track,
    Map<String, dynamic> headers,
  ) async {
    AppLogger.log.i(
      "GET request for track: ${track.query.name}\n"
      "Headers: ${request.headers}",
    );

    final trackCacheFile = File(await _getTrackCacheFilePath(track));

    if (await trackCacheFile.exists() && userPreferences.cacheMusic) {
      final bytes = await trackCacheFile.readAsBytes();
      final cachedFileLength = bytes.length;

      return (
        response: dio_lib.Response<Uint8List>(
          statusCode: 200,
          headers: Headers.fromMap({
            "content-type": ["audio/${track.qualityPreset!.name}"],
            "content-length": ["$cachedFileLength"],
            "accept-ranges": ["bytes"],
            "content-range": ["bytes 0-$cachedFileLength/$cachedFileLength"],
          }),
          requestOptions: RequestOptions(path: request.requestedUri.toString()),
        ),
        bytes: bytes,
      );
    }

    final trackPartialCacheFile = File("${trackCacheFile.path}.part");

    String url = track.url ??
        await ref
            .read(sourcedTrackProvider(track.query).notifier)
            .swapWithNextSibling()
            .then((track) => track.url!);

    var options = Options(
      headers: {
        ...headers,
        "user-agent": _randomUserAgent,
        "Cache-Control": "max-age=3600",
        "Connection": "keep-alive",
        "host": Uri.parse(url).host,
      },
      responseType: ResponseType.bytes,
      validateStatus: (status) => status! < 400,
    );

    final contentLengthRes = await Future<dio_lib.Response?>.value(
      dio.head(url, options: options),
    ).catchError((e, stack) async {
      AppLogger.reportError(e, stack);

      final sourcedTrack = await ref
          .read(sourcedTrackProvider(track.query).notifier)
          .refreshStreamingUrl();

      url = sourcedTrack.url!;

      return dio.head(url, options: options);
    });

    // Redirect to m3u8 link directly as it handles range requests internally
    if (contentLengthRes?.headers.value("content-type") ==
        "application/vnd.apple.mpegurl") {
      return (
        response: dio_lib.Response<Uint8List>(
          statusCode: 301,
          statusMessage: "M3U8 Redirect",
          headers: Headers.fromMap({
            "location": [url],
            "content-type": ["application/vnd.apple.mpegurl"],
          }),
          requestOptions: RequestOptions(path: request.requestedUri.toString()),
          isRedirect: true,
        ),
        bytes: null,
      );
    }

    if (headers["range"] == "bytes=0-" &&
        track.qualityPreset is SpotubeAudioSourceContainerPresetLossless) {
      const bufferSize = 6 * 1024 * 1024; // 6MB for lossless

      final endRange = min(
        bufferSize,
        int.parse(contentLengthRes?.headers.value("content-length") ?? "0"),
      );

      options = options.copyWith(
        headers: {
          ...?options.headers,
          "range": "bytes=0-$endRange",
        },
      );
    }

    final res = await dio.get<Uint8List>(url, options: options);

    AppLogger.log.i(
      "Response for track: ${track.query.name}\n"
      "Status Code: ${res.statusCode}\n"
      "Headers: ${res.headers.map}",
    );

    final bytes = res.data;

    if (bytes == null || !userPreferences.cacheMusic) {
      return (response: res, bytes: bytes);
    }

    final contentRange =
        ContentRangeHeader.parse(res.headers.value("content-range") ?? "");

    if (!await trackPartialCacheFile.exists()) {
      await trackPartialCacheFile.create(recursive: true);
    }

    // Write the stream to the file based on the range
    final partialCacheFile =
        await trackPartialCacheFile.open(mode: FileMode.writeOnlyAppend);
    int fileLength = 0;
    try {
      await partialCacheFile.setPosition(contentRange.start);
      await partialCacheFile.writeFrom(bytes);
      fileLength = await partialCacheFile.length();
    } finally {
      await partialCacheFile.close();
    }

    if (fileLength == contentRange.total) {
      await trackPartialCacheFile.rename(trackCacheFile.path);
    }

    if (contentRange.total == fileLength &&
            track.qualityPreset!.name != "webm" ||
        track.qualityPreset!.name != "weba") {
      final playlistTrack = playlist.tracks.firstWhereOrNull(
        (element) => element.id == track.query.id,
      );
      if (playlistTrack == null) {
        AppLogger.log.e(
          "Track ${track.query.id} not found in playlist, cannot write metadata.",
        );
        return (response: res, bytes: bytes);
      }

      final imageBytes = await ServiceUtils.downloadImage(
        (playlistTrack.album.images).asUrlString(
          placeholder: ImagePlaceholder.albumArt,
          index: 1,
        ),
      );

      await MetadataGod.writeMetadata(
        file: trackCacheFile.path,
        metadata: (playlistTrack as SpotubeFullTrackObject).toMetadata(
          imageBytes: imageBytes,
          fileLength: fileLength,
        ),
      ).catchError((e, stackTrace) {
        AppLogger.reportError(e, stackTrace);
      });
    }

    return (bytes: bytes, response: res);
  }

  /// @head('/stream/<trackId>')
  Future<Response> headStreamTrackId(Request request, String trackId) async {
    try {
      final sourcedTrack = await _getSourcedTrack(request, trackId);

      if (sourcedTrack == null) {
        return Response.notFound("Track not found in the current queue");
      }

      final res = await streamTrackInformation(
        request,
        sourcedTrack,
      );

      return Response(
        res.statusCode!,
        headers: res.headers.map,
      );
    } catch (e, stack) {
      AppLogger.reportError(e, stack);
      return Response.internalServerError();
    }
  }

  /// @get('/stream/<trackId>')
  Future<Response> getStreamTrackId(Request request, String trackId) async {
    try {
      final sourcedTrack = await _getSourcedTrack(request, trackId);

      if (sourcedTrack == null) {
        return Response.notFound("Track not found in the current queue");
      }

      final (bytes: audioBytes, response: res) = await streamTrack(
        request,
        sourcedTrack,
        request.headers,
      );

      return Response(
        res.statusCode!,
        body: audioBytes,
        headers: res.headers.map,
      );
    } catch (e, stack) {
      AppLogger.reportError(e, stack);
      return Response.internalServerError();
    }
  }

  /// @get('/playback/toggle-playback')
  Future<Response> togglePlayback(Request request) async {
    audioPlayer.isPlaying
        ? await audioPlayer.pause()
        : await audioPlayer.resume();

    return Response.ok("Playback toggled");
  }

  /// @get('/playback/previous')
  Future<Response> previousTrack(Request request) async {
    await audioPlayer.skipToPrevious();
    return Response.ok("Previous track");
  }

  /// @get('/playback/next')
  Future<Response> nextTrack(Request request) async {
    await audioPlayer.skipToNext();
    return Response.ok("Next track");
  }
}

final serverPlaybackRoutesProvider =
    Provider((ref) => ServerPlaybackRoutes(ref));
