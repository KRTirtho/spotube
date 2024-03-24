part of 'connect.dart';

enum WsEvent {
  error,
  queue,
  position,
  playing,
  resume,
  pause,
  load,
  next,
  previous,
  jump,
  stop;

  static WsEvent fromString(String value) {
    return WsEvent.values.firstWhere((e) => e.name == value);
  }
}

typedef EventCallback<T> = FutureOr<void> Function(T event);

class WebSocketEvent<T> {
  final WsEvent type;
  final T data;

  WebSocketEvent(this.type, this.data);

  factory WebSocketEvent.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJson,
  ) {
    return WebSocketEvent(
      WsEvent.fromString(json["type"]),
      fromJson(json["data"]),
    );
  }

  String toJson() {
    return jsonEncode({
      "type": type.name,
      "data": data,
    });
  }

  Future<void> onPosition(
    EventCallback<WebSocketPositionEvent> callback,
  ) async {
    if (type == WsEvent.position) {
      await callback(WebSocketPositionEvent.fromJson({"data": data}));
    }
  }

  Future<void> onPlaying(
    EventCallback<WebSocketPlayingEvent> callback,
  ) async {
    if (type == WsEvent.playing) {
      await callback(WebSocketPlayingEvent(data as bool));
    }
  }

  Future<void> onResume(
    EventCallback<WebSocketResumeEvent> callback,
  ) async {
    if (type == WsEvent.resume) {
      await callback(WebSocketResumeEvent());
    }
  }

  Future<void> onPause(
    EventCallback<WebSocketPauseEvent> callback,
  ) async {
    if (type == WsEvent.pause) {
      await callback(WebSocketPauseEvent());
    }
  }

  Future<void> onStop(
    EventCallback<WebSocketStopEvent> callback,
  ) async {
    if (type == WsEvent.stop) {
      await callback(WebSocketStopEvent());
    }
  }

  Future<void> onLoad(
    EventCallback<WebSocketLoadEvent> callback,
  ) async {
    if (type == WsEvent.load) {
      await callback(WebSocketLoadEvent.fromJson(data as Map<String, dynamic>));
    }
  }

  Future<void> onNext(
    EventCallback<WebSocketNextEvent> callback,
  ) async {
    if (type == WsEvent.next) {
      await callback(WebSocketNextEvent());
    }
  }

  Future<void> onPrevious(
    EventCallback<WebSocketPreviousEvent> callback,
  ) async {
    if (type == WsEvent.previous) {
      await callback(WebSocketPreviousEvent());
    }
  }

  Future<void> onJump(
    EventCallback<WebSocketJumpEvent> callback,
  ) async {
    if (type == WsEvent.jump) {
      await callback(WebSocketJumpEvent(data as int));
    }
  }

  Future<void> onError(
    EventCallback<WebSocketErrorEvent> callback,
  ) async {
    if (type == WsEvent.error) {
      await callback(WebSocketErrorEvent(data as String));
    }
  }

  Future<void> onQueue(
    EventCallback<WebSocketQueueEvent> callback,
  ) async {
    if (type == WsEvent.queue) {
      await callback(
        WebSocketQueueEvent.fromJson(data as Map<String, dynamic>),
      );
    }
  }
}

class WebSocketPositionEvent extends WebSocketEvent<Duration> {
  WebSocketPositionEvent(Duration data) : super(WsEvent.position, data);

  WebSocketPositionEvent.fromJson(Map<String, dynamic> json)
      : super(WsEvent.position, Duration(seconds: json["data"] as int));

  @override
  String toJson() {
    return jsonEncode({
      "type": type.name,
      "data": data.inSeconds,
    });
  }
}

class WebSocketPlayingEvent extends WebSocketEvent<bool> {
  WebSocketPlayingEvent(bool data) : super(WsEvent.playing, data);
}

class WebSocketResumeEvent extends WebSocketEvent<void> {
  WebSocketResumeEvent() : super(WsEvent.resume, null);
}

class WebSocketPauseEvent extends WebSocketEvent<void> {
  WebSocketPauseEvent() : super(WsEvent.pause, null);
}

class WebSocketStopEvent extends WebSocketEvent<void> {
  WebSocketStopEvent() : super(WsEvent.stop, null);
}

class WebSocketNextEvent extends WebSocketEvent<void> {
  WebSocketNextEvent() : super(WsEvent.next, null);
}

class WebSocketPreviousEvent extends WebSocketEvent<void> {
  WebSocketPreviousEvent() : super(WsEvent.previous, null);
}

class WebSocketJumpEvent extends WebSocketEvent<int> {
  WebSocketJumpEvent(int data) : super(WsEvent.jump, data);
}

class WebSocketErrorEvent extends WebSocketEvent<String> {
  WebSocketErrorEvent(String data) : super(WsEvent.error, data);
}

class WebSocketQueueEvent extends WebSocketEvent<ProxyPlaylist> {
  WebSocketQueueEvent(ProxyPlaylist data) : super(WsEvent.queue, data);

  factory WebSocketQueueEvent.fromJson(Map<String, dynamic> json) =>
      WebSocketQueueEvent(
        ProxyPlaylist.fromJsonRaw(json),
      );
}
