import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:spotube/services/youtube_engine/youtube_engine.dart';
// import 'package:youtube_explode_dart/solvers.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import 'dart:async';

/// It contains methods that are computationally expensive
class IsolatedYoutubeExplode {
  final Isolate _isolate;
  final SendPort _sendPort;
  final ReceivePort _receivePort;

  IsolatedYoutubeExplode._(
    Isolate isolate,
    ReceivePort receivePort,
    SendPort sendPort,
  )   : _isolate = isolate,
        _receivePort = receivePort,
        _sendPort = sendPort;

  static IsolatedYoutubeExplode? _instance;

  static IsolatedYoutubeExplode get instance => _instance!;

  static bool get isInitialized => _instance != null;

  static Future<void> initialize() async {
    if (_instance != null) {
      return;
    }

    final completer = Completer<SendPort>();

    final receivePort = ReceivePort();

    /// Listen for the main isolate to set the main port
    final subscription = receivePort.listen((message) {
      if (message is SendPort) {
        completer.complete(message);
      }
    });

    final isolate = await Isolate.spawn(_isolateEntry, receivePort.sendPort);

    _instance = IsolatedYoutubeExplode._(
      isolate,
      receivePort,
      await completer.future,
    );

    if (completer.isCompleted) {
      subscription.cancel();
    }
  }

  static Future<void> _isolateEntry(SendPort mainSendPort) async {
    final receivePort = ReceivePort();
    // final solver = await DenoEJSSolver.init();
    final youtubeExplode = YoutubeExplode();
    final stopWatch = kDebugMode ? Stopwatch() : null;

    /// Send the main port to the main isolate
    mainSendPort.send(receivePort.sendPort);

    receivePort.listen((message) async {
      final SendPort replyPort = message[0];
      final String methodName = message[1];
      final List<dynamic> arguments = message[2];

      if (stopWatch != null) {
        if (stopWatch.isRunning) {
          stopWatch.stop();
          final symbol = stopWatch.elapsedMilliseconds < 1000 ? "⚠️" : "⏱️";
          debugPrint(
            "$symbol YoutubeExplode operation gap ${stopWatch.elapsedMilliseconds} ms",
          );
          stopWatch.reset();
        } else {
          stopWatch.start();
        }
      }

      // Run the requested method on YoutubeExplode
      var result = switch (methodName) {
        "search" => youtubeExplode.search
            .search(
              arguments[0] as String,
              filter: arguments.elementAtOrNull(1) ?? TypeFilters.video,
            )
            .then((s) => s.toList()),
        "video" => youtubeExplode.videos.get(arguments[0] as String),
        "manifest" => youtubeExplode.videos.streamsClient.getManifest(
            arguments[0] as String,
            requireWatchPage: arguments.elementAtOrNull(1) ?? true,
            ytClients: arguments.elementAtOrNull(2) as List<YoutubeApiClient>?,
          ),
        _ => throw ArgumentError('Invalid method name: $methodName'),
      };

      replyPort.send(await result);
    });
  }

  Future<T> _runMethod<T>(String methodName, List<dynamic> args) {
    final completer = Completer<T>();
    final responsePort = ReceivePort();

    responsePort.listen((message) {
      completer.complete(message as T);
      responsePort.close();
    });

    _sendPort.send([responsePort.sendPort, methodName, args]);
    return completer.future;
  }

  Future<List<Video>> search(
    String query, {
    SearchFilter? filter,
  }) async {
    return _runMethod<List<Video>>("search", [query]);
  }

  Future<Video> video(String videoId) async {
    return _runMethod<Video>("video", [videoId]);
  }

  Future<StreamManifest> manifest(
    String videoId, {
    bool requireWatchPage = false,
    List<YoutubeApiClient>? ytClients,
  }) async {
    return _runMethod<StreamManifest>("manifest", [
      videoId,
      requireWatchPage,
      ytClients,
    ]);
  }

  void dispose() {
    _receivePort.close();
    _isolate.kill(priority: Isolate.immediate);
  }
}

class YouTubeExplodeEngine implements YouTubeEngine {
  static final _youtubeExplode = IsolatedYoutubeExplode.instance;

  static bool get isAvailableForPlatform => true;

  static Future<bool> isInstalled() async {
    return true;
  }

  @override
  Future<StreamManifest> getStreamManifest(String videoId) async {
    await IsolatedYoutubeExplode.initialize();

    final streamManifest = await _youtubeExplode.manifest(
      videoId,
      requireWatchPage: false,
      ytClients: [
        YoutubeApiClient.ios,
        YoutubeApiClient.androidVr,
        YoutubeApiClient.android,
      ],
    );

    final audioStreams = streamManifest.audioOnly.where(
      (stream) => stream.bitrate.bitsPerSecond >= 40960,
    );

    return StreamManifest(
      audioStreams.map(
        (stream) => AudioOnlyStreamInfo(
          stream.videoId,
          stream.tag,
          stream.url,
          stream.container,
          stream.size,
          stream.bitrate,
          stream.audioCodec,
          switch (stream.bitrate.bitsPerSecond) {
            > 130 * 1024 => "high",
            > 64 * 1024 => "medium",
            _ => "low",
          },
          stream.fragments,
          stream.codec,
          stream.audioTrack,
        ),
      ),
    );
  }

  @override
  Future<Video> getVideo(String videoId) async {
    await IsolatedYoutubeExplode.initialize();
    return _youtubeExplode.video(videoId);
  }

  @override
  Future<(Video, StreamManifest)> getVideoWithStreamInfo(String videoId) async {
    await IsolatedYoutubeExplode.initialize();

    final video = await getVideo(videoId);
    final streamManifest = await getStreamManifest(videoId);

    return (video, streamManifest);
  }

  @override
  Future<List<Video>> searchVideos(String query) async {
    await IsolatedYoutubeExplode.initialize();

    return _youtubeExplode
        .search(
          query,
          filter: TypeFilters.video,
        )
        .then((searchList) => searchList.toList());
  }

  @override
  void dispose() {
    IsolatedYoutubeExplode.instance.dispose();
  }
}
