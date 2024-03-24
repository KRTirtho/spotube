import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:catcher_2/catcher_2.dart';
import 'package:shelf/shelf_io.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:spotube/models/connect/connect.dart';
import 'package:spotube/models/logger.dart';
import 'package:spotube/provider/proxy_playlist/proxy_playlist_provider.dart';
import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';
import 'package:spotube/services/audio_player/audio_player.dart';
import 'package:bonsoir/bonsoir.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

final logger = getLogger('ConnectServer');

final connectServerProvider = FutureProvider((ref) async {
  final enabled =
      ref.watch(userPreferencesProvider.select((s) => s.enableConnect));
  final playbackNotifier = ref.read(ProxyPlaylistNotifier.notifier);

  if (!enabled) {
    return null;
  }

  final app = Router();

  final subscriptions = <StreamSubscription>[];

  final websocket = webSocketHandler(
    (WebSocketChannel channel, String? protocol) {
      ref.listen(
        ProxyPlaylistNotifier.provider,
        (previous, next) {
          channel.sink.add(
            WebSocketQueueEvent(next).toJson(),
          );
        },
      );

      subscriptions.addAll([
        audioPlayer.positionStream.listen(
          (position) {
            channel.sink.add(
              WebSocketPositionEvent(position).toJson(),
            );
          },
        ),
        audioPlayer.playingStream.listen(
          (playing) {
            channel.sink.add(
              WebSocketEvent(WsEvent.playing, playing).toJson(),
            );
          },
        ),
        channel.stream.listen(
          (message) {
            try {
              final event = WebSocketEvent.fromJson(
                jsonDecode(message),
                (data) => data,
              );

              event.onLoad((event) async {
                await playbackNotifier.load(
                  event.data.tracks,
                  autoPlay: true,
                  initialIndex: event.data.initialIndex ?? 0,
                );

                if (event.data.collectionId != null) {
                  playbackNotifier.addCollection(event.data.collectionId!);
                }
              });

              event.onPause((event) async {
                await audioPlayer.pause();
              });

              event.onResume((event) async {
                await audioPlayer.resume();
              });

              event.onStop((event) async {
                await audioPlayer.stop();
              });

              event.onNext((event) async {
                await playbackNotifier.next();
              });

              event.onPrevious((event) async {
                await playbackNotifier.previous();
              });

              event.onJump((event) async {
                await playbackNotifier.jumpTo(event.data);
              });
            } catch (e, stackTrace) {
              Catcher2.reportCheckedError(e, stackTrace);
              channel.sink.add(WebSocketErrorEvent(e.toString()).toJson());
            }
          },
          onDone: () {
            logger.i('Connection closed');
          },
        ),
      ]);
    },
  );

  final port = Random().nextInt(17000) + 3000;

  final server = await serve(
    (request) {
      if (request.url.path.startsWith('ws')) {
        return websocket(request);
      }
      return app(request);
    },
    InternetAddress.loopbackIPv4,
    port,
  );

  logger.i('Server running on http://${server.address.host}:${server.port}');

  final service = BonsoirService(
    name: 'Spotube',
    type: '_spotube._tcp',
    port: port,
  );

  final broadcast = BonsoirBroadcast(service: service);

  await broadcast.ready;
  await broadcast.start();

  ref.onDispose(() async {
    logger.i('Stopping server');
    for (final subscription in subscriptions) {
      await subscription.cancel();
    }
    await broadcast.stop();
    await server.close();
  });

  return app;
});
