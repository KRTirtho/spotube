import 'package:spotify/spotify.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

YoutubeExplode youtube = YoutubeExplode();
Future<Track> toYoutubeTrack(Track track) async {
  var artistsName = track.artists?.map((ar) => ar.name).toList() ?? [];
  String queryString =
      "${artistsName.first} - ${track.name}${artistsName.length > 1 ? " feat. ${artistsName.sublist(1).join(" ")}" : ""}";

  SearchList videos = await youtube.search.getVideos(queryString);

  List<Video> matchedVideos = videos.where((video) {
    return video.title.contains(track.name!) &&
        (track.artists?.every((artist) => video.title.contains(artist.name!)) ??
            false);
  }).toList();

  Video ytVideo = matchedVideos.isNotEmpty ? matchedVideos.first : videos.first;

  var trackManifest = await youtube.videos.streams.getManifest(ytVideo.id);

  track.uri = trackManifest.audioOnly.withHighestBitrate().url.toString();
  track.href = ytVideo.url;
  return track;
}
