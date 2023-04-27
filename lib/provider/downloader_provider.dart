import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:metadata_god/metadata_god.dart';
import 'package:queue/queue.dart';
import 'package:path/path.dart' as path;
import 'package:spotify/spotify.dart' hide Image, Queue;
import 'package:spotube/components/shared/dialogs/replace_downloaded_dialog.dart';

import 'package:spotube/models/logger.dart';
import 'package:spotube/models/spotube_track.dart';
import 'package:spotube/provider/user_preferences_provider.dart';
import 'package:spotube/services/youtube.dart';
import 'package:spotube/utils/type_conversion_utils.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' hide Comment;

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

  // Playback get _playback => ref.read(playbackProvider);

  void addToQueue(Track baseTrack) async {
    if (kIsWeb) return;
    if (inQueue.any((t) => t.id == baseTrack.id!)) return;
    inQueue.add(baseTrack);
    currentlyRunning++;
    notifyListeners();

    // Using android Audio Focus to keep the app run in background
    grabberQueue.add(() async {
      final track = await SpotubeTrack.fetchFromTrack(
        baseTrack,
        ref.read(userPreferencesProvider),
      );

      _queue.add(() async {
        final cleanTitle = track.ytTrack.title.replaceAll(
          RegExp(r'[/\\?%*:|"<>]'),
          "",
        );
        final filename = '$cleanTitle.m4a';
        final file = File(path.join(downloadPath, filename));
        try {
          final replaceFileGlobal = ref.read(replaceDownloadedFileState);
          logger.v("[addToQueue] Download starting for ${file.path}");
          if (file.existsSync() &&
              (replaceFileGlobal ?? await onFileExists?.call(track)) != true) {
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
                    .where(
                      (audio) => audio.codec.mimeType == "audio/mp4",
                    )
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

          logger.v(
            "[addToQueue] Writing metadata to ${file.path}",
          );
          final imageUri = TypeConversionUtils.image_X_UrlString(
            track.album?.images ?? [],
            placeholder: ImagePlaceholder.online,
          );
          final response = await get(Uri.parse(imageUri));

          await MetadataGod.writeMetadata(
            file: file.path,
            metadata: Metadata(
              title: track.name,
              artist: track.artists?.map((a) => a.name).join(", "),
              album: track.album?.name,
              albumArtist: track.artists?.map((a) => a.name).join(", "),
              year: track.album?.releaseDate != null
                  ? int.tryParse(track.album!.releaseDate!)
                  : null,
              trackNumber: track.trackNumber,
              discNumber: track.discNumber,
              durationMs: track.durationMs?.toDouble(),
              fileSize: file.lengthSync(),
              trackTotal: track.album?.tracks?.length,
              picture: response.headers['content-type'] != null
                  ? Picture(
                      data: response.bodyBytes,
                      mimeType: response.headers['content-type']!,
                    )
                  : null,
            ),
          );
          logger.v(
            "[addToQueue] Writing metadata to ${file.path} is successful",
          );
        } catch (e) {
          logger.v("[addToQueue] Failed download of ${file.path}", e);
          rethrow;
        } finally {
          currentlyRunning--;
          inQueue.removeWhere((t) => t.id == track.id);
          notifyListeners();
        }
      });
    });
  }

  cancelAll() {
    grabberQueue.cancel();
    grabberQueue = Queue();
    inQueue.clear();
    currentlyRunning = 0;
    _queue.cancel();
    queueInstance = Queue();
    _queue = queueInstance;
    notifyListeners();
  }
}

final downloaderProvider = ChangeNotifierProvider(
  (ref) {
    return Downloader(
      ref,
      queueInstance,
      yt: youtube,
      downloadPath: ref.watch(
        userPreferencesProvider.select(
          (s) => s.downloadLocation,
        ),
      ),
    );
  },
);
