import 'dart:io';
import 'package:spotify/spotify.dart';
import 'package:spotube/helpers/getLyrics.dart';
import 'package:spotube/models/Logger.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:collection/collection.dart';
import 'package:spotube/extensions/list-sort-multiple.dart';

final logger = getLogger("toYoutubeTrack");
Future<Track> toYoutubeTrack(
    YoutubeExplode youtube, Track track, String format) async {
  final artistsName =
      track.artists?.map((ar) => ar.name).toList().whereNotNull().toList() ??
          [];
  logger.v("[Track Search Artists] $artistsName");
  final mainArtist = artistsName.first;
  final featuredArtists =
      artistsName.length > 1 ? "feat. " + artistsName.sublist(1).join(" ") : "";
  final title = getTitle(clearArtistsOfTitle(track.name!, artistsName)).trim();
  logger.v("[Track Search Title] $title");
  final queryString = format
      .replaceAll("\$MAIN_ARTIST", mainArtist)
      .replaceAll("\$TITLE", title)
      .replaceAll("\$FEATURED_ARTISTS", featuredArtists);
  logger.v("[Youtube Search Term] $queryString");

  SearchList videos = await youtube.search.getVideos(queryString);

  List<Map> ratedRankedVideos = videos
      .map((video) {
        // the find should be lazy thus everything case insensitive
        final ytTitle = video.title.toLowerCase();
        final bool hasTitle = ytTitle.contains(title);
        final bool hasAllArtists = track.artists?.every(
              (artist) => ytTitle.contains(artist.name!.toLowerCase()),
            ) ??
            false;
        final bool authorIsArtist = track.artists
                ?.any((artist) => artist.name?.toLowerCase() == video.author) ??
            false;
        int rate = 0;
        for (final el in [hasTitle, hasAllArtists, authorIsArtist]) {
          if (el) rate++;
        }
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

  final ytVideo = ratedRankedVideos.first["video"] as Video;

  final trackManifest = await youtube.videos.streams.getManifest(ytVideo.id);

  // Since Mac OS's & IOS's CodeAudio doesn't support WebMedia
  // ('audio/webm', 'video/webm' & 'image/webp') thus using 'audio/mpeg'
  // codec/mimetype for those Platforms
  track.uri = (Platform.isMacOS || Platform.isIOS
          ? trackManifest.audioOnly
              .where((info) => info.codec.mimeType == "audio/mp4")
              .withHighestBitrate()
          : trackManifest.audioOnly.withHighestBitrate())
      .url
      .toString();
  track.href = ytVideo.url;
  logger.v(
      "[YouTube Matched Track] ${ytVideo.title} | ${ytVideo.author} - ${track.href}");
  return track;
}
