import 'dart:async';
import 'dart:convert';

import 'package:catcher_2/catcher_2.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotube/models/connect/connect.dart';
import 'package:spotube/provider/connect/clients.dart';
import 'package:spotube/provider/proxy_playlist/proxy_playlist_provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

final playingStreamController = StreamController<bool>.broadcast();
final playingProvider = StreamProvider.autoDispose<bool>(
  (ref) => playingStreamController.stream,
);

final positionStreamController = StreamController<Duration>.broadcast();
final positionProvider = StreamProvider.autoDispose<Duration>(
  (ref) => positionStreamController.stream,
);

class ConnectNotifier extends AsyncNotifier<WebSocketChannel?> {
  @override
  build() async {
    try {
      final connectClients = ref.watch(connectClientsProvider);
      print('Building ConnectNotifier');

      if (connectClients.asData?.value.resolvedService == null) return null;

      final service = connectClients.asData!.value.resolvedService!;

      print(
          'Connecting to ${service.name}: ws://${service.host}:${service.port}/ws');

      final channel = WebSocketChannel.connect(
        Uri.parse('ws://${service.host}:${service.port}/ws'),
      );

      await channel.ready;

      print(
          'Connected to ${service.name}: ws://${service.host}:${service.port}/ws');

      final subscription = channel.stream.listen(
        (message) {
          final event =
              WebSocketEvent.fromJson(jsonDecode(message), (data) => data);

          event.onQueue((event) {
            ref.read(ProxyPlaylistNotifier.notifier).state = event.data;
          });

          event.onPlaying((event) {
            playingStreamController.add(event.data);
          });

          event.onPosition((event) {
            positionStreamController.add(event.data);
          });
        },
        onError: (error) {
          Catcher2.reportCheckedError(
            error,
            StackTrace.current,
          );
        },
      );

      ref.onDispose(() {
        subscription.cancel();
        channel.sink.close(status.goingAway);
      });

      return channel;
    } catch (e, stack) {
      Catcher2.reportCheckedError(e, stack);
      rethrow;
    }
  }

  void emit(Object message) {
    if (state.value == null) return;
    state.value?.sink.add(
      message is String ? message : (message as dynamic).toJson(),
    );
  }

  void resume() {
    emit(WebSocketResumeEvent());
  }

  void pause() {
    emit(WebSocketPauseEvent());
  }

  void stop() {
    emit(WebSocketStopEvent());
  }

  void jumpTo(int position) {
    emit(WebSocketJumpEvent(position));
  }

  void load(WebSocketLoadEventData data) {
    emit(WebSocketLoadEvent(data));
  }

  void next() {
    emit(WebSocketNextEvent());
  }

  void previous() {
    emit(WebSocketPreviousEvent());
  }
}

final connectProvider =
    AsyncNotifierProvider<ConnectNotifier, WebSocketChannel?>(
  () => ConnectNotifier(),
);
