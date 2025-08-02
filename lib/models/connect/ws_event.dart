part of 'connect.dart';

enum WsEvent {
  error,
  volume,
  removeTrack,
  addTrack,
  reorder,
  shuffle,
  loop,
  seek,
  duration,
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
      await callback(
        WebSocketLoadEvent(
          WebSocketLoadEventData.fromJson(data as Map<String, dynamic>),
        ),
      );
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

  Future<void> onDuration(
    EventCallback<WebSocketDurationEvent> callback,
  ) async {
    if (type == WsEvent.duration) {
      await callback(
        WebSocketDurationEvent(
          Duration(seconds: data as int),
        ),
      );
    }
  }

  Future<void> onSeek(
    EventCallback<WebSocketSeekEvent> callback,
  ) async {
    if (type == WsEvent.seek) {
      await callback(
        WebSocketSeekEvent(
          Duration(seconds: data as int),
        ),
      );
    }
  }

  Future<void> onShuffle(
    EventCallback<WebSocketShuffleEvent> callback,
  ) async {
    if (type == WsEvent.shuffle) {
      await callback(WebSocketShuffleEvent(data as bool));
    }
  }

  Future<void> onLoop(
    EventCallback<WebSocketLoopEvent> callback,
  ) async {
    if (type == WsEvent.loop) {
      await callback(
        WebSocketLoopEvent(
          PlaylistMode.values.firstWhere((e) => e.name == data as String),
        ),
      );
    }
  }

  Future<void> onRemoveTrack(
    EventCallback<WebSocketRemoveTrackEvent> callback,
  ) async {
    if (type == WsEvent.removeTrack) {
      await callback(WebSocketRemoveTrackEvent(data as String));
    }
  }

  Future<void> onAddTrack(
    EventCallback<WebSocketAddTrackEvent> callback,
  ) async {
    if (type == WsEvent.addTrack) {
      await callback(
          WebSocketAddTrackEvent.fromJson(data as Map<String, dynamic>));
    }
  }

  Future<void> onReorder(
    EventCallback<WebSocketReorderEvent> callback,
  ) async {
    if (type == WsEvent.reorder) {
      await callback(
          WebSocketReorderEvent.fromJson(data as Map<String, dynamic>));
    }
  }

  Future<void> onVolume(
    EventCallback<WebSocketVolumeEvent> callback,
  ) async {
    if (type == WsEvent.volume) {
      await callback(WebSocketVolumeEvent(data as double));
    }
  }
}

class WebSocketLoopEvent extends WebSocketEvent<PlaylistMode> {
  WebSocketLoopEvent(PlaylistMode data) : super(WsEvent.loop, data);

  WebSocketLoopEvent.fromJson(Map<String, dynamic> json)
      : super(
          WsEvent.loop,
          PlaylistMode.values.firstWhere(
            (e) => e.name == json["data"] as String,
          ),
        );

  @override
  String toJson() {
    return jsonEncode({
      "type": type.name,
      "data": data.name,
    });
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

class WebSocketDurationEvent extends WebSocketEvent<Duration> {
  WebSocketDurationEvent(Duration data) : super(WsEvent.duration, data);

  WebSocketDurationEvent.fromJson(Map<String, dynamic> json)
      : super(WsEvent.duration, Duration(seconds: json["data"] as int));

  @override
  String toJson() {
    return jsonEncode({
      "type": type.name,
      "data": data.inSeconds,
    });
  }
}

class WebSocketSeekEvent extends WebSocketEvent<Duration> {
  WebSocketSeekEvent(Duration data) : super(WsEvent.seek, data);

  WebSocketSeekEvent.fromJson(Map<String, dynamic> json)
      : super(WsEvent.seek, Duration(seconds: json["data"] as int));

  @override
  String toJson() {
    return jsonEncode({
      "type": type.name,
      "data": data.inSeconds,
    });
  }
}

class WebSocketShuffleEvent extends WebSocketEvent<bool> {
  WebSocketShuffleEvent(bool data) : super(WsEvent.shuffle, data);
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

class WebSocketQueueEvent extends WebSocketEvent<AudioPlayerState> {
  WebSocketQueueEvent(AudioPlayerState data) : super(WsEvent.queue, data);

  factory WebSocketQueueEvent.fromJson(Map<String, dynamic> json) =>
      WebSocketQueueEvent(
        AudioPlayerState.fromJson(json),
      );
}

class WebSocketRemoveTrackEvent extends WebSocketEvent<String> {
  WebSocketRemoveTrackEvent(String data) : super(WsEvent.removeTrack, data);
}

class WebSocketAddTrackEvent extends WebSocketEvent<SpotubeFullTrackObject> {
  WebSocketAddTrackEvent(SpotubeFullTrackObject data)
      : super(WsEvent.addTrack, data);

  WebSocketAddTrackEvent.fromJson(Map<String, dynamic> json)
      : super(
          WsEvent.addTrack,
          SpotubeFullTrackObject.fromJson(
            json["data"] as Map<String, dynamic>,
          ),
        );
}

typedef ReorderData = ({int oldIndex, int newIndex});

class WebSocketReorderEvent extends WebSocketEvent<ReorderData> {
  WebSocketReorderEvent(ReorderData data) : super(WsEvent.reorder, data);

  factory WebSocketReorderEvent.fromJson(Map<String, dynamic> json) =>
      WebSocketReorderEvent(
        (
          oldIndex: json["oldIndex"] as int,
          newIndex: json["newIndex"] as int,
        ),
      );

  @override
  String toJson() {
    return jsonEncode({
      "type": type.name,
      "data": {
        "oldIndex": data.oldIndex,
        "newIndex": data.newIndex,
      },
    });
  }
}

class WebSocketVolumeEvent extends WebSocketEvent<double> {
  WebSocketVolumeEvent(double data) : super(WsEvent.volume, data);
}
