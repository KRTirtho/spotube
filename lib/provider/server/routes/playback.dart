import 'package:dio/dio.dart' hide Response;
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shelf/shelf.dart';
import 'package:spotube/provider/audio_player/audio_player.dart';
import 'package:spotube/provider/audio_player/state.dart';
import 'package:spotube/provider/server/active_sourced_track.dart';
import 'package:spotube/provider/server/sourced_track.dart';
import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';
import 'package:spotube/services/audio_player/audio_player.dart';
import 'package:spotube/services/logger/logger.dart';

class ServerPlaybackRoutes {
  final Ref ref;
  UserPreferences get userPreferences => ref.read(userPreferencesProvider);
  AudioPlayerState get playlist => ref.read(audioPlayerProvider);
  final Dio dio;

  ServerPlaybackRoutes(this.ref) : dio = Dio();

  /// @get('/stream/<trackId>')
  Future<Response> getStreamTrackId(Request request, String trackId) async {
    final options = Options(
      headers: {
        ...request.headers,
        "User-Agent":
            "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36",
        "Cache-Control": "max-age=0",
        "Connection": "keep-alive",
      },
      responseType: ResponseType.stream,
      validateStatus: (status) => status! < 400,
    );
    try {
      final track =
          playlist.tracks.firstWhere((element) => element.id == trackId);

      final activeSourcedTrack = ref.read(activeSourcedTrackProvider);
      final sourcedTrack = activeSourcedTrack?.id == track.id
          ? activeSourcedTrack
          : await ref.read(sourcedTrackProvider(SpotubeMedia(track)).future);

      ref.read(activeSourcedTrackProvider.notifier).update(sourcedTrack);
      final res = await dio
          .get(
        sourcedTrack!.url,
        options: options.copyWith(
          headers: {
            ...options.headers!,
            "host": Uri.parse(sourcedTrack.url).host,
          },
        ),
      )
          .catchError((e, stack) async {
        final sourcedTrack = await ref
            .read(sourcedTrackProvider(SpotubeMedia(track)).notifier)
            .switchToAlternativeSources();

        ref.read(activeSourcedTrackProvider.notifier).update(sourcedTrack);

        return await dio.get(
          sourcedTrack!.url,
          options: options.copyWith(
            headers: {
              ...options.headers!,
              "host": Uri.parse(sourcedTrack.url).host,
            },
          ),
        );
      });

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
