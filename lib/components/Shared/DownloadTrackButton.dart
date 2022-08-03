import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/models/SpotubeTrack.dart';
import 'package:spotube/provider/Playback.dart';
import 'package:spotube/provider/UserPreferences.dart';
import 'package:spotube/utils/platform.dart';
import 'package:spotube/utils/service_utils.dart';
import 'package:spotube/utils/type_conversion_utils.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';
import 'package:collection/collection.dart';

enum TrackStatus { downloading, idle, done }

class DownloadTrackButton extends HookConsumerWidget {
  final Track? track;
  const DownloadTrackButton({Key? key, this.track}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final UserPreferences preferences = ref.watch(userPreferencesProvider);
    final Playback playback = ref.watch(playbackProvider);
    final status = useState<TrackStatus>(TrackStatus.idle);
    YoutubeExplode yt = useMemoized(() => YoutubeExplode());

    final outputFile = useState<File?>(null);
    String fileName =
        "${track?.name} - ${TypeConversionUtils.artists_X_String<Artist>(track?.artists ?? [])}";

    useEffect(() {
      (() async {
        outputFile.value =
            File(path.join(preferences.downloadLocation, "$fileName.mp3"));
      }());
      return null;
    }, [fileName, track, preferences.downloadLocation]);

    final _downloadTrack = useCallback(() async {
      try {
        if (track == null || outputFile.value == null) return;
        if ((kIsMobile) &&
            !await Permission.storage.isGranted &&
            !await Permission.storage.isPermanentlyDenied) {
          final status = await Permission.storage.request();
          if (!status.isGranted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content:
                    Text("Couldn't download track. Not enough permissions"),
              ),
            );
            return;
          }
        }
        StreamManifest manifest = await yt.videos.streamsClient
            .getManifest((track as SpotubeTrack).ytTrack.url);

        File outputLyricsFile = File(
            path.join(preferences.downloadLocation, "$fileName-lyrics.txt"));

        if (await outputFile.value!.exists()) {
          final shouldReplace = await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Track Already Exists"),
                content: const Text(
                    "Do you want to replace the already downloaded track?"),
                actions: [
                  TextButton(
                    child: const Text("No"),
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                  ),
                  TextButton(
                    child: const Text("Yes"),
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                  )
                ],
              );
            },
          );
          if (shouldReplace != true) return;
        }

        final audioStream = yt.videos.streamsClient
            .get(
              manifest.audioOnly
                  .where((audio) => audio.codec.mimeType == "audio/mp4")
                  .withHighestBitrate(),
            )
            .asBroadcastStream();

        final statusCb = audioStream.listen(
          (event) {
            if (status.value != TrackStatus.downloading) {
              status.value = TrackStatus.downloading;
            }
          },
          onDone: () async {
            status.value = TrackStatus.done;
            await Future.delayed(
              const Duration(seconds: 3),
              () {
                if (status.value == TrackStatus.done) {
                  status.value = TrackStatus.idle;
                }
              },
            );
          },
        );

        if (!await outputFile.value!.exists()) {
          await outputFile.value!.create(recursive: true);
        }

        IOSink outputFileStream = outputFile.value!.openWrite();
        await audioStream.pipe(outputFileStream);
        await outputFileStream.flush();
        await outputFileStream.close().then((value) async {
          if (status.value == TrackStatus.downloading) {
            status.value = TrackStatus.done;
            await Future.delayed(
              const Duration(seconds: 3),
              () {
                if (status.value == TrackStatus.done) {
                  status.value = TrackStatus.idle;
                }
              },
            );
          }
          return statusCb.cancel();
        });

        if (preferences.saveTrackLyrics && playback.track != null) {
          if (!await outputLyricsFile.exists()) {
            await outputLyricsFile.create(recursive: true);
          }
          final lyrics = await ServiceUtils.getLyrics(
            playback.track!.name!,
            playback.track!.artists
                    ?.map((s) => s.name)
                    .whereNotNull()
                    .toList() ??
                [],
            apiKey: preferences.geniusAccessToken,
            optimizeQuery: true,
          );
          if (lyrics != null) {
            await outputLyricsFile.writeAsString(
              "$lyrics\n\nPowered by genius.com",
              mode: FileMode.writeOnly,
            );
          }
        }
      } on FileSystemException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
            content: Text("Download Failed. ${e.message} ${e.path}"),
          ),
        );
      }
    }, [
      track,
      status,
      yt,
      preferences.saveTrackLyrics,
      playback.track,
      outputFile.value,
      preferences.downloadLocation,
      fileName
    ]);

    useEffect(() {
      return () => yt.close();
    }, []);

    final outputFileExists = useMemoized(
      () => outputFile.value?.existsSync() == true,
      [outputFile.value, status.value, track],
    );

    if (status.value == TrackStatus.downloading) {
      return const SizedBox(
        child: CircularProgressIndicator.adaptive(
          strokeWidth: 2,
        ),
        height: 20,
        width: 20,
      );
    } else if (status.value == TrackStatus.done) {
      return const Icon(Icons.download_done_rounded);
    }
    return IconButton(
      icon: Icon(
        outputFileExists ? Icons.download_done_rounded : Icons.download_rounded,
      ),
      onPressed: track != null && track is SpotubeTrack ? _downloadTrack : null,
    );
  }
}
