import 'dart:io';
import 'package:hive/hive.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/entities/CacheTrack.dart';
import 'package:spotube/helpers/contains-text-in-bracket.dart';
import 'package:spotube/helpers/getLyrics.dart';
import 'package:spotube/models/Logger.dart';
import 'package:spotube/models/SpotubeTrack.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:collection/collection.dart';
import 'package:spotube/extensions/list-sort-multiple.dart';
import 'package:spotube/extensions/yt-video-from-cache-track.dart';

enum AudioQuality {
  high,
  low,
}

final logger = getLogger("toSpotubeTrack");
Future<SpotubeTrack> toSpotubeTrack({
  required YoutubeExplode youtube,
  required Track track,
  required String format,
  required SpotubeTrackMatchAlgorithm matchAlgorithm,
  required AudioQuality audioQuality,
  LazyBox<CacheTrack>? box,
}) async {
  final artistsName =
      track.artists?.map((ar) => ar.name).toList().whereNotNull().toList() ??
          [];
  logger.v("[Track Search Artists] $artistsName");
  final mainArtist = artistsName.first;
  final featuredArtists =
      artistsName.length > 1 ? "feat. " + artistsName.sublist(1).join(" ") : "";
  final title = getTitle(
    track.name!,
    artists: artistsName,
    onlyCleanArtist: true,
  ).trim();
  logger.v("[Track Search Title] $title");
  final queryString = format
      .replaceAll("\$MAIN_ARTIST", mainArtist)
      .replaceAll("\$TITLE", title)
      .replaceAll("\$FEATURED_ARTISTS", featuredArtists);
  logger.v("[Youtube Search Term] $queryString");

  Video ytVideo;
  final cachedTrack = await box?.get(track.id);
  if (cachedTrack != null && cachedTrack.mode == matchAlgorithm.name) {
    logger.v(
      "[Playing track from cache] youtubeId: ${cachedTrack.id} mode: ${cachedTrack.mode}",
    );
    ytVideo = VideoFromCacheTrackExtension.fromCacheTrack(cachedTrack);
  } else {
    VideoSearchList videos = await youtube.search.search(queryString);
    if (matchAlgorithm != SpotubeTrackMatchAlgorithm.youtube) {
      List<Map> ratedRankedVideos = videos
          .map((video) {
            // the find should be lazy thus everything case insensitive
            final ytTitle = video.title.toLowerCase();
            final bool hasTitle = ytTitle.contains(title);
            final bool hasAllArtists = track.artists?.every(
                  (artist) => ytTitle.contains(artist.name!.toLowerCase()),
                ) ??
                false;
            final bool authorIsArtist =
                track.artists?.first.name?.toLowerCase() ==
                    video.author.toLowerCase();

            final bool hasNoLiveInTitle =
                !containsTextInBracket(ytTitle, "live");

            int rate = 0;
            for (final el in [
              hasTitle,
              hasAllArtists,
              if (matchAlgorithm == SpotubeTrackMatchAlgorithm.authenticPopular)
                authorIsArtist,
              hasNoLiveInTitle,
              !video.isLive,
            ]) {
              if (el) rate++;
            }
            // can't let pass any non title matching track
            if (!hasTitle) rate = rate - 2;
            return {
              "video": video,
              "points": rate,
              "views": video.engagement.viewCount,
            };
          })
          .toList()
          .sortByProperties(
            [false, false],
            ["points", "views"],
          );

      ytVideo = ratedRankedVideos.first["video"] as Video;
    } else {
      ytVideo = videos.where((video) => !video.isLive).first;
    }
  }

  final trackManifest = await youtube.videos.streams.getManifest(ytVideo.id);

  logger.v(
    "[YouTube Matched Track] ${ytVideo.title} | ${ytVideo.author} - ${ytVideo.url}",
  );

  final audioManifest = trackManifest.audioOnly.where((info) {
    final isMp4a = info.codec.mimeType == "audio/mp4";
    if (Platform.isLinux) {
      return !isMp4a;
    } else if (Platform.isMacOS || Platform.isIOS) {
      return isMp4a;
    } else {
      return true;
    }
  });

  final ytUri = (audioQuality == AudioQuality.high
          ? audioManifest.withHighestBitrate()
          : audioManifest.sortByBitrate().last)
      .url
      .toString();

  // only save when the track isn't available in the cache with same
  // matchAlgorithm
  if (cachedTrack == null || cachedTrack.mode != matchAlgorithm.name) {
    await box?.put(
        track.id!, CacheTrack.fromVideo(ytVideo, matchAlgorithm.name));
  }

  return SpotubeTrack.fromTrack(
    track: track,
    ytTrack: ytVideo,
    // Since Mac OS's & IOS's CodeAudio doesn't support WebMedia
    // ('audio/webm', 'video/webm' & 'image/webp') thus using 'audio/mpeg'
    // codec/mimetype for those Platforms
    ytUri: ytUri,
  );
}
