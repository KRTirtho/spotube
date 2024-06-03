import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:catcher_2/catcher_2.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/models/connect/connect.dart';
import 'package:spotube/models/logger.dart';
import 'package:spotube/provider/connect/clients.dart';
import 'package:spotube/provider/history/history.dart';
import 'package:spotube/provider/proxy_playlist/proxy_playlist_provider.dart';
import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';
import 'package:spotube/services/audio_player/audio_player.dart';
import 'package:bonsoir/bonsoir.dart';
import 'package:spotube/services/device_info/device_info.dart';
import 'package:spotube/utils/primitive_utils.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:spotube/provider/volume_provider.dart';

final logger = getLogger('ConnectServer');
final _connectClientStreamController = StreamController<String>.broadcast();

Stream<String> get connectClientStream => _connectClientStreamController.stream;

final connectServerProvider = FutureProvider((ref) async {
  final enabled =
      ref.watch(userPreferencesProvider.select((s) => s.enableConnect));
  final resolvedService = await ref
      .watch(connectClientsProvider.selectAsync((s) => s.resolvedService));
  final playbackNotifier = ref.read(proxyPlaylistProvider.notifier);
  final historyNotifier = ref.read(playbackHistoryProvider.notifier);

  if (!enabled || resolvedService != null) {
    return null;
  }

  final app = Router();

  app.get(
    "/ping",
    (Request req) {
      return Response.ok("pong");
    },
  );

  final subscriptions = <StreamSubscription>[];

  FutureOr<Response> websocket(Request req) => webSocketHandler(
        (WebSocketChannel channel, String? protocol) async {
          final context =
              (req.context["shelf.io.connection_info"] as HttpConnectionInfo?);
          final origin =
              "${context?.remoteAddress.host}:${context?.remotePort}";
          _connectClientStreamController.add(origin);

          ref.listen(
            proxyPlaylistProvider,
            (previous, next) {
              channel.sink.add(
                WebSocketQueueEvent(next).toJson(),
              );
            },
            fireImmediately: true,
          );

          // because audioPlayer events doesn't fireImmediately
          channel.sink.add(
            WebSocketPlayingEvent(audioPlayer.isPlaying).toJson(),
          );
          channel.sink.add(
            WebSocketPositionEvent(await audioPlayer.position ?? Duration.zero)
                .toJson(),
          );
          channel.sink.add(
            WebSocketDurationEvent(await audioPlayer.duration ?? Duration.zero)
                .toJson(),
          );
          channel.sink.add(
            WebSocketShuffleEvent(audioPlayer.isShuffled).toJson(),
          );
          channel.sink.add(
            WebSocketLoopEvent(audioPlayer.loopMode).toJson(),
          );
          channel.sink.add(
            WebSocketVolumeEvent(audioPlayer.volume).toJson(),
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
                  WebSocketPlayingEvent(playing).toJson(),
                );
              },
            ),
            audioPlayer.durationStream.listen(
              (duration) {
                channel.sink.add(
                  WebSocketDurationEvent(duration).toJson(),
                );
              },
            ),
            audioPlayer.shuffledStream.listen(
              (shuffled) {
                channel.sink.add(
                  WebSocketShuffleEvent(shuffled).toJson(),
                );
              },
            ),
            audioPlayer.loopModeStream.listen(
              (loopMode) {
                channel.sink.add(
                  WebSocketLoopEvent(loopMode).toJson(),
                );
              },
            ),
            audioPlayer.volumeStream.listen(
              (volume) {
                channel.sink.add(
                  WebSocketVolumeEvent(volume).toJson(),
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

                    if (event.data.collectionId == null) return;
                    playbackNotifier.addCollection(event.data.collectionId!);
                    if (event.data.collection is AlbumSimple) {
                      historyNotifier
                          .addAlbums([event.data.collection as AlbumSimple]);
                    } else {
                      historyNotifier.addPlaylists(
                          [event.data.collection as PlaylistSimple]);
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

                  event.onSeek((event) async {
                    await audioPlayer.seek(event.data);
                  });

                  event.onShuffle((event) async {
                    await audioPlayer.setShuffle(event.data);
                  });

                  event.onLoop((event) async {
                    await audioPlayer.setLoopMode(event.data);
                  });

                  event.onAddTrack((event) async {
                    await playbackNotifier.addTrack(event.data);
                  });

                  event.onRemoveTrack((event) async {
                    await playbackNotifier.removeTrack(event.data);
                  });

                  event.onReorder((event) async {
                    await playbackNotifier.moveTrack(
                      event.data.oldIndex,
                      event.data.newIndex,
                    );
                  });

                  event.onVolume((event) async {
                    ref.read(volumeProvider.notifier).setVolume(event.data);
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
      )(req);

  final port = Random().nextInt(17000) + 3000;

  final server = await serve(
    (request) {
      if (request.url.path.startsWith('ws')) {
        return websocket(request);
      }
      return app(request);
    },
    InternetAddress.anyIPv4,
    port,
  );

  logger.i('Server running on http://${server.address.host}:${server.port}');

  final service = BonsoirService(
    name: await DeviceInfoService.instance.computerName(),
    type: '_spotube._tcp',
    port: port,
    attributes: {
      "id": PrimitiveUtils.uuid.v4(),
      "deviceId": await DeviceInfoService.instance.deviceId(),
    },
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
