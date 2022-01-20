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

class _DownloadTrackButtonState extends State<DownloadTrackButton> {
  late YoutubeExplode yt;

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

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.download_rounded),
      onPressed: widget.track != null
          ? () async {
              if (widget.track == null) return;
              StreamManifest manifest = await yt.videos.streamsClient
                  .getManifest(widget.track?.href!.split("watch?v=").last);

              var audioStream = yt.videos.streamsClient
                  .get(manifest.audioOnly.withHighestBitrate());

              String downloadFolder = path.join(
                  (await path_provider.getDownloadsDirectory())!.path,
                  "Spotube");
              String fileName =
                  "${widget.track?.name} - ${artistsToString(widget.track?.artists ?? [])}.mp3";
              File outputFile = File(path.join(downloadFolder, fileName));
              if (!outputFile.existsSync()) {
                outputFile.createSync(recursive: true);
                IOSink outputFileStream = outputFile.openWrite();
                await audioStream.pipe(outputFileStream);
                await outputFileStream.flush();
                await outputFileStream.close();
              }
            }
          : null,
    );
  }
}
