import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:queue/queue.dart';
import 'package:path/path.dart' as path;
import 'package:spotify/spotify.dart';
import 'package:spotube/models/Logger.dart';
import 'package:spotube/models/SpotubeTrack.dart';
import 'package:spotube/provider/Playback.dart';
import 'package:spotube/provider/UserPreferences.dart';
import 'package:spotube/provider/YouTube.dart';
import 'package:spotube/utils/platform.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

Queue queueInstance = Queue(delay: const Duration(seconds: 5));
Queue grabberQueue = Queue(delay: const Duration(seconds: 5));

class Downloader with ChangeNotifier {
  Ref ref;
  Queue _queue;
  YoutubeExplode yt;
  String downloadPath;
  FutureOr<bool> Function(SpotubeTrack track)? onFileExists;
  Downloader(
    this.ref,
    this._queue, {
    required this.downloadPath,
    required this.yt,
    this.onFileExists,
  });

  int currentlyRunning = 0;
  // ignore: prefer_collection_literals
  Set<Track> inQueue = Set();

  final logger = getLogger(Downloader);

  void addToQueue(Track baseTrack) async {
    if (inQueue.any((t) => t.id == baseTrack.id!)) return;
    inQueue.add(baseTrack);
    currentlyRunning++;
    notifyListeners();
    if (kIsMobile) {
      grabberQueue.add(() async {
        final track = await ref.read(playbackProvider).toSpotubeTrack(
              baseTrack,
              noSponsorBlock: true,
            );

        final filename = '${track.ytTrack.title}.mp3';

        final url =
            ((await yt.videos.streamsClient.getManifest(track.ytTrack.url)))
                .audioOnly
                .where((audio) => audio.codec.mimeType == "audio/mp4")
                .withHighestBitrate()
                .url;
        await FlutterDownloader.enqueue(
          savedDir: downloadPath,
          url: url.toString(),
          fileName: filename,
          openFileFromNotification: true,
          showNotification: true,
        );
      });
    } else {
      grabberQueue.add(() async {
        final track = await ref.read(playbackProvider).toSpotubeTrack(
              baseTrack,
              noSponsorBlock: true,
            );
        _queue.add(() async {
          final filename = '${track.ytTrack.title}.mp3';
          final file = File(path.join(downloadPath, filename));
          try {
            logger.v("[addToQueue] Download starting for ${file.path}");
            if (file.existsSync() && await onFileExists?.call(track) != true) {
              return;
            }
            file.createSync(recursive: true);
            StreamManifest manifest =
                await yt.videos.streamsClient.getManifest(track.ytTrack.url);
            logger.v(
              "[addToQueue] Getting download information for ${file.path}",
            );
            final audioStream = yt.videos.streamsClient
                .get(
                  manifest.audioOnly
                      .where((audio) => audio.codec.mimeType == "audio/mp4")
                      .withHighestBitrate(),
                )
                .asBroadcastStream();

            logger.v(
              "[addToQueue] ${file.path} download started",
            );

            IOSink outputFileStream = file.openWrite();
            await audioStream.pipe(outputFileStream);
            await outputFileStream.flush();
            logger.v(
              "[addToQueue] Download of ${file.path} is done successfully",
            );
          } catch (e, stack) {
            logger.e(
              "[addToQueue] Failed download of ${file.path}",
              e,
              stack,
            );
            rethrow;
          } finally {
            currentlyRunning--;
            inQueue.removeWhere((t) => t.id == track.id);
            notifyListeners();
          }
        });
      });
    }
  }

  cancelAll() {
    grabberQueue.cancel();
    grabberQueue = Queue();
    inQueue.clear();
    currentlyRunning = 0;
    if (kIsMobile) {
      FlutterDownloader.cancelAll();
    } else {
      _queue.cancel();
      queueInstance = Queue();
      _queue = queueInstance;
    }
    notifyListeners();
  }
}

final downloaderProvider = ChangeNotifierProvider(
  (ref) {
    return Downloader(
      ref,
      queueInstance,
      yt: ref.watch(youtubeProvider),
      downloadPath: ref.watch(
        userPreferencesProvider.select(
          (s) => s.downloadLocation,
        ),
      ),
    );
  },
);
