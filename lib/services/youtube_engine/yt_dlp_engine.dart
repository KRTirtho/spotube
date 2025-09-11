import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:spotube/services/youtube_engine/youtube_engine.dart';
import 'package:spotube/utils/platform.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:yt_dlp_dart/yt_dlp_dart.dart';
// ignore: depend_on_referenced_packages
import 'package:http_parser/http_parser.dart';

class YtDlpEngine implements YouTubeEngine {
  StreamManifest _parseFormats(List formats, videoId) {
    final audioOnlyStreams = formats
        .where((f) => f["resolution"] == "audio only")
        .sorted((a, b) => a["quality"] > b["quality"] ? 1 : -1)
        .map((f) {
      final filesize = f["filesize"] ?? f["filesize_approx"];
      return AudioOnlyStreamInfo(
        VideoId(videoId),
        0,
        Uri.parse(f["url"]),
        StreamContainer.parse(
          f["container"]?.replaceAll("_dash", "").replaceAll("m4a", "mp4") ??
              (f["protocol"] == "m3u8_native" ? "m3u8" : "mp4"),
        ),
        filesize != null ? FileSize(filesize) : FileSize.unknown,
        Bitrate(
          (((f["abr"] ?? f["tbr"] ?? 0) * 1000) as num).toInt(),
        ),
        f["acodec"] ?? "aac",
        f["format_note"],
        [],
        MediaType.parse(
          "audio/${f["audio_ext"]}",
        ),
        null,
      );
    });

    return StreamManifest(audioOnlyStreams);
  }

  Video _parseInfo(Map<String, dynamic> info) {
    final publishDate = info["upload_date"] != null
        ? DateTime.fromMillisecondsSinceEpoch(
            int.parse(info["upload_date"]) * 1000,
          )
        : DateTime.now();
    return Video(
      VideoId(info["id"]),
      info["title"],
      info["channel"],
      ChannelId(info["channel_id"]),
      publishDate,
      info["upload_date"] as String? ?? DateTime.now().toString(),
      publishDate,
      info["description"] ?? "",
      Duration(seconds: (info["duration"] as num).toInt()),
      ThumbnailSet(info["id"]),
      info["tags"]?.cast<String>() ?? <String>[],
      Engagement(
        info["view_count"],
        info["like_count"],
        null,
      ),
      info["is_live"] ?? false,
    );
  }

  static bool get isAvailableForPlatform => kIsDesktop;

  static Future<bool> isInstalled() async {
    return isAvailableForPlatform &&
        await YtDlp.instance.checkAvailableInPath();
  }

  @override
  Future<StreamManifest> getStreamManifest(String videoId) async {
    final formats = await YtDlp.instance.extractInfo(
      "https://www.youtube.com/watch?v=$videoId",
      formatSpecifiers: "%(formats)j",
      extraArgs: [
        "--no-check-certificate",
        "--geo-bypass",
        "--quiet",
        "--ignore-errors"
      ],
    ) as List;

    return _parseFormats(formats, videoId);
  }

  @override
  Future<Video> getVideo(String videoId) async {
    final info = await YtDlp.instance.extractInfo(
      "https://www.youtube.com/watch?v=$videoId",
      formatSpecifiers: "%()j",
      extraArgs: [
        "--skip-download",
        "--no-check-certificate",
        "--geo-bypass",
        "--quiet",
        "--ignore-errors",
      ],
    ) as Map<String, dynamic>;

    return _parseInfo(info);
  }

  @override
  Future<(Video, StreamManifest)> getVideoWithStreamInfo(String videoId) async {
    final info = await YtDlp.instance.extractInfo(
      "https://www.youtube.com/watch?v=$videoId",
      formatSpecifiers: "%()j",
      extraArgs: [
        "--no-check-certificate",
        "--geo-bypass",
        "--quiet",
        "--ignore-errors",
      ],
    ) as Map<String, dynamic>;

    return (_parseInfo(info), _parseFormats(info["formats"], videoId));
  }

  @override
  Future<List<Video>> searchVideos(String query) async {
    final stdout = await YtDlp.instance.extractInfoString(
      "ytsearch10:$query",
      formatSpecifiers: "%()j",
      extraArgs: [
        "--skip-download",
        "--no-check-certificate",
        "--geo-bypass",
        "--quiet",
        "--ignore-errors",
        "--flat-playlist",
        "--no-playlist",
      ],
    );

    final json = jsonDecode(
      "[${stdout.split("\n").where((s) => s.trim().isNotEmpty).join(",")}]",
    ) as List;

    return json.map((e) => _parseInfo(e)).toList();
  }

  @override
  void dispose() {}
}
