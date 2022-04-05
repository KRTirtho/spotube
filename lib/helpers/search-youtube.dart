import 'dart:io';
import 'package:spotify/spotify.dart';
import 'package:spotube/helpers/getLyrics.dart';
import 'package:spotube/models/Logger.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

final logger = getLogger("toYoutubeTrack");
Future<Track> toYoutubeTrack(
    YoutubeExplode youtube, Track track, String format) async {
  final artistsName = track.artists?.map((ar) => ar.name).toList() ?? [];
  logger.v("[Track Search Artists] $artistsName");
  final mainArtist = artistsName.first ?? "";
  final featuredArtists =
      artistsName.length > 1 ? "feat. " + artistsName.sublist(1).join(" ") : "";
  final title = getTitle(track.name!, "").trim();
  logger.v("[Track Search Title] $title");
  final queryString = format
      .replaceAll("\$MAIN_ARTIST", mainArtist)
      .replaceAll("\$TITLE", title)
      .replaceAll("\$FEATURED_ARTISTS", featuredArtists);
  logger.v("[Youtube Search Term] $queryString");

  SearchList videos = await youtube.search.getVideos(queryString);

  List<Video> matchedVideos = videos.where((video) {
    // the find should be lazy thus everything case insensitive
    return video.title.toLowerCase().contains(track.name!.toLowerCase()) &&
        (track.artists?.every((artist) => video.title
                .toLowerCase()
                .contains(artist.name!.toLowerCase())) ??
            false);
  }).toList();

  Video ytVideo = matchedVideos.isNotEmpty ? matchedVideos.first : videos.first;

  var trackManifest = await youtube.videos.streams.getManifest(ytVideo.id);

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
  logger.v("[YouTube Matched Track] ${ytVideo.title} - ${track.href}");
  return track;
}
