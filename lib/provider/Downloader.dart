import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dart_tags/dart_tags.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:queue/queue.dart';
import 'package:path/path.dart' as path;
import 'package:spotify/spotify.dart';
import 'package:spotube/components/Library/UserLocalTracks.dart';
import 'package:spotube/models/Id3Tags.dart';
import 'package:spotube/models/Logger.dart';
import 'package:spotube/models/SpotubeTrack.dart';
import 'package:spotube/provider/Playback.dart';
import 'package:spotube/provider/UserPreferences.dart';
import 'package:spotube/provider/YouTube.dart';
import 'package:spotube/utils/platform.dart';
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

  Playback get _playback => ref.read(playbackProvider);

  void addToQueue(Track baseTrack) async {
    if (inQueue.any((t) => t.id == baseTrack.id!)) return;
    inQueue.add(baseTrack);
    currentlyRunning++;
    notifyListeners();

    // Using android Audio Focus to keep the app run in background
    _playback.mobileAudioService?.session?.setActive(true);
    grabberQueue.add(() async {
      final track = await ref.read(playbackProvider).toSpotubeTrack(
            baseTrack,
            noSponsorBlock: true,
          );
      _queue.add(() async {
        final cleanTitle = track.ytTrack.title.replaceAll(
          RegExp(r'[/\\?%*:|"<>]'),
          "",
        );
        final filename = '$cleanTitle.mp3';
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

          // Tagging isn't supported in Android currently
          if (kIsAndroid) return;

          final imageUri = TypeConversionUtils.image_X_UrlString(
            track.album?.images ?? [],
          );
          final response = await get(
            Uri.parse(
              imageUri,
            ),
          );
          final picture = AttachedPicture.base64(
            response.headers["Content-Type"] ?? "image/jpeg",
            3,
            track.name!,
            base64Encode(response.bodyBytes),
          );
          // write id3 metadata
          final tag = Id3Tags(
            album: track.album?.name,
            picture: picture,
            title: track.name,
            genre: "Spotube",
            tcop: track.ytTrack.uploadDate?.year.toString(),
            tdrc: track.ytTrack.uploadDate?.year.toString(),
            tpe2: TypeConversionUtils.artists_X_String<Artist>(
              track.artists ?? [],
            ),
            tsse: "",
            comment: Comment(
              "eng",
              track.ytTrack.description,
              track.ytTrack.title,
            ),
          );

          logger.v("[addToQueue] Writing metadata to ${file.path}");

          final taggedMp3 = await tagProcessor.putTagsToByteArray(
            file.readAsBytes(),
            [
              Tag()
                ..type = "ID3"
                ..version = "2.4.0"
                ..tags = tag.toJson()
            ],
          );
          await file.writeAsBytes(taggedMp3);
          logger.v(
            "[addToQueue] Writing metadata to ${file.path} is successful",
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
          if (currentlyRunning == 0 && !_playback.isPlaying) {
            _playback.mobileAudioService?.session?.setActive(false);
          }
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
      yt: ref.watch(youtubeProvider),
      downloadPath: ref.watch(
        userPreferencesProvider.select(
          (s) => s.downloadLocation,
        ),
      ),
    );
  },
);
