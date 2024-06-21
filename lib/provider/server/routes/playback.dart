import 'package:dio/dio.dart' hide Response;
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shelf/shelf.dart';
import 'package:spotube/provider/proxy_playlist/proxy_playlist.dart';
import 'package:spotube/provider/proxy_playlist/proxy_playlist_provider.dart';
import 'package:spotube/provider/server/active_sourced_track.dart';
import 'package:spotube/provider/server/sourced_track.dart';
import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';
import 'package:spotube/provider/user_preferences/user_preferences_state.dart';
import 'package:spotube/services/logger/logger.dart';

class ServerPlaybackRoutes {
  final Ref ref;
  UserPreferences get userPreferences => ref.read(userPreferencesProvider);
  ProxyPlaylist get playlist => ref.read(proxyPlaylistProvider);
  final Dio dio;

  ServerPlaybackRoutes(this.ref) : dio = Dio();

  /// @get('/stream/<trackId>')
  Future<Response> getStreamTrackId(Request request, String trackId) async {
    try {
      final track =
          playlist.tracks.firstWhere((element) => element.id == trackId);
      final activeSourcedTrack = ref.read(activeSourcedTrackProvider);
      final sourcedTrack = activeSourcedTrack?.id == track.id
          ? activeSourcedTrack
          : await ref.read(sourcedTrackProvider(track).future);

      ref.read(activeSourcedTrackProvider.notifier).update(sourcedTrack);

      final res = await dio.get(
        sourcedTrack!.url,
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
          validateStatus: (status) => status! < 500,
        ),
      );

      final audioStream =
          (res.data?.stream as Stream<Uint8List>?)?.asBroadcastStream();

      audioStream!.listen(
        (event) {},
        cancelOnError: true,
      );

      return Response(
        res.statusCode!,
        body: audioStream,
        context: {
          "shelf.io.buffer_output": false,
        },
        headers: res.headers.map,
      );
    } catch (e, stack) {
      AppLogger.reportError(e, stack);
      return Response.internalServerError();
    }
  }
}

final serverPlaybackRoutesProvider =
    Provider((ref) => ServerPlaybackRoutes(ref));