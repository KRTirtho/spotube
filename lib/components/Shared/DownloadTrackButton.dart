import 'dart:io';

import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/helpers/artist-to-string.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path/path.dart' as path;

class DownloadTrackButton extends StatefulWidget {
  final Track? track;
  const DownloadTrackButton({Key? key, this.track}) : super(key: key);

  @override
  _DownloadTrackButtonState createState() => _DownloadTrackButtonState();
}

enum TrackStatus { downloading, idle, done }

class _DownloadTrackButtonState extends State<DownloadTrackButton> {
  late YoutubeExplode yt;
  TrackStatus status = TrackStatus.idle;

  @override
  void initState() {
    yt = YoutubeExplode();
    super.initState();
  }

  @override
  void dispose() {
    yt.close();
    super.dispose();
  }

  _downloadTrack() async {
    if (widget.track == null) return;
    StreamManifest manifest =
        await yt.videos.streamsClient.getManifest(widget.track?.href);

    var audioStream = yt.videos.streamsClient
        .get(manifest.audioOnly.withHighestBitrate())
        .asBroadcastStream();

    var statusCb = audioStream.listen(
      (event) {
        if (status != TrackStatus.downloading) {
          setState(() {
            status = TrackStatus.downloading;
          });
        }
      },
      onDone: () async {
        setState(() {
          status = TrackStatus.done;
        });
        await Future.delayed(
          const Duration(seconds: 3),
          () {
            if (status == TrackStatus.done) {
              setState(() {
                status = TrackStatus.idle;
              });
            }
          },
        );
      },
    );

    String downloadFolder = path.join(
        (await path_provider.getDownloadsDirectory())!.path, "Spotube");
    String fileName =
        "${widget.track?.name} - ${artistsToString<Artist>(widget.track?.artists ?? [])}.mp3";
    File outputFile = File(path.join(downloadFolder, fileName));
    if (!outputFile.existsSync()) {
      outputFile.createSync(recursive: true);
      IOSink outputFileStream = outputFile.openWrite();
      await audioStream.pipe(outputFileStream);
      await outputFileStream.flush();
      await outputFileStream.close().then((value) async {
        if (status == TrackStatus.downloading) {
          setState(() {
            status = TrackStatus.done;
          });
          await Future.delayed(
            const Duration(seconds: 3),
            () {
              if (status == TrackStatus.done) {
                setState(() {
                  status = TrackStatus.idle;
                });
              }
            },
          );
        }
        return statusCb.cancel();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (status == TrackStatus.downloading) {
      return const SizedBox(
        child: CircularProgressIndicator.adaptive(
          strokeWidth: 2,
        ),
        height: 20,
        width: 20,
      );
    } else if (status == TrackStatus.done) {
      return const Icon(Icons.download_done_rounded);
    }
    return IconButton(
      icon: const Icon(Icons.download_rounded),
      onPressed: widget.track != null &&
              !(widget.track!.href ?? "").startsWith("https://api.spotify.com")
          ? _downloadTrack
          : null,
    );
  }
}
