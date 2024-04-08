import 'dart:io';
import 'dart:math';

import 'package:catcher_2/catcher_2.dart';
import 'package:dio/dio.dart' hide Response;
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:spotube/models/logger.dart';
import 'package:spotube/provider/proxy_playlist/proxy_playlist.dart';
import 'package:spotube/provider/proxy_playlist/proxy_playlist_provider.dart';
import 'package:spotube/provider/server/active_sourced_track.dart';
import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';
import 'package:spotube/provider/user_preferences/user_preferences_state.dart';
import 'package:spotube/services/sourced_track/sourced_track.dart';

class PlaybackServer {
  final Ref ref;
  UserPreferences get userPreferences => ref.read(userPreferencesProvider);
  ProxyPlaylist get playlist => ref.read(ProxyPlaylistNotifier.provider);
  final Logger logger;
  final Dio dio;

  final Router router;

  static final port = Random().nextInt(17000) + 1500;

  PlaybackServer(this.ref)
      : logger = getLogger('PlaybackServer'),
        dio = Dio(),
        router = Router() {
    router.get('/stream/<trackId>', getStreamTrackId);

    const pipeline = Pipeline();

    if (kDebugMode) {
      pipeline.addMiddleware(logRequests());
      dio.interceptors.add(LogInterceptor());
    }

    serve(pipeline.addHandler(router.call), InternetAddress.loopbackIPv4, port)
        .then((server) {
      logger
          .t('Playback server at http://${server.address.host}:${server.port}');

      ref.onDispose(() {
        dio.close(force: true);
        server.close();
      });
    });
  }

  /// @get('/stream/<trackId>')
  Future<Response> getStreamTrackId(Request request, String trackId) async {
    try {
      final track =
          playlist.tracks.firstWhere((element) => element.id == trackId);
      final sourcedTrack =
          await SourcedTrack.fetchFromTrack(track: track, ref: ref);

      ref.read(activeSourcedTrackProvider.notifier).update(sourcedTrack);

      final res = await dio.get(
        sourcedTrack.url,
        options: Options(
          headers: {
            ...request.headers,
            "User-Agent":
                "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36",
            "host": Uri.parse(sourcedTrack.url).host,
            "Cache-Control": "max-age=0",
            "Connection": "keep-alive",
          },
          responseType: ResponseType.stream,
        ),
      );

      final audioStream = res.data?.stream as Stream<Uint8List>?;

      return Response(
        200,
        body: audioStream,
        context: {
          "shelf.io.buffer_output": false,
        },
        headers: res.headers.map,
      );
    } catch (e, stack) {
      Catcher2.reportCheckedError(e, stack);
      return Response.internalServerError();
    }
  }
}

final playbackServerProvider = Provider<PlaybackServer>((ref) {
  return PlaybackServer(ref);
});
