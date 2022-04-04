import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/helpers/artist-to-string.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';

enum TrackStatus { downloading, idle, done }

class DownloadTrackButton extends HookWidget {
  final Track? track;
  const DownloadTrackButton({Key? key, this.track}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final status = useState<TrackStatus>(TrackStatus.idle);
    YoutubeExplode yt = useMemoized(() => YoutubeExplode());

    final _downloadTrack = useCallback(() async {
      if (track == null) return;
      if ((Platform.isAndroid || Platform.isIOS) &&
          !await Permission.storage.isGranted &&
          !await Permission.storage.isPermanentlyDenied) {
        final status = await Permission.storage.request();
        if (!status.isGranted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Couldn't download track. Not enough permissions"),
            ),
          );
          return;
        }
      }
      StreamManifest manifest =
          await yt.videos.streamsClient.getManifest(track?.href);

      String downloadFolder = path.join(
          Platform.isAndroid
              ? "/storage/emulated/0/Download"
              : (await path_provider.getDownloadsDirectory())!.path,
          "Spotube");
      String fileName =
          "${track?.name} - ${artistsToString<Artist>(track?.artists ?? [])}.mp3";
      File outputFile = File(path.join(downloadFolder, fileName));

      if (await outputFile.exists()) {
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

      if (!outputFile.existsSync()) outputFile.createSync(recursive: true);
      IOSink outputFileStream = outputFile.openWrite();
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
    }, [track, status, yt]);

    useEffect(() {
      return () => yt.close();
    }, []);

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
      icon: const Icon(Icons.download_rounded),
      onPressed: track != null &&
              !(track!.href ?? "").startsWith("https://api.spotify.com")
          ? _downloadTrack
          : null,
    );
  }
}
