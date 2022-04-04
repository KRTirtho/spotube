import 'dart:io';
import 'package:spotify/spotify.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

Future<Track> toYoutubeTrack(YoutubeExplode youtube, Track track) async {
  var artistsName = track.artists?.map((ar) => ar.name).toList() ?? [];
  String queryString =
      "${artistsName.first} - ${track.name}${artistsName.length > 1 ? " feat. ${artistsName.sublist(1).join(" ")}" : ""}";

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
  return track;
}
