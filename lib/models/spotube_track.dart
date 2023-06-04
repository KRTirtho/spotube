import 'dart:async';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart';
import 'package:piped_client/piped_client.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/extensions/album_simple.dart';
import 'package:spotube/extensions/artist_simple.dart';
import 'package:spotube/models/matched_track.dart';
import 'package:spotube/provider/user_preferences_provider.dart';
import 'package:spotube/services/youtube.dart';
import 'package:spotube/utils/platform.dart';
import 'package:spotube/utils/service_utils.dart';
import 'package:collection/collection.dart';

typedef SkipSegment = ({int start, int end});

class SpotubeTrack extends Track {
  final PipedStreamResponse ytTrack;
  final String ytUri;

  final List<PipedSearchItemStream> siblings;

  SpotubeTrack(
    this.ytTrack,
    this.ytUri,
    this.siblings,
  ) : super();

  SpotubeTrack.fromTrack({
    required Track track,
    required this.ytTrack,
    required this.ytUri,
    required this.siblings,
  }) : super() {
    album = track.album;
    artists = track.artists;
    availableMarkets = track.availableMarkets;
    discNumber = track.discNumber;
    durationMs = track.durationMs;
    explicit = track.explicit;
    externalIds = track.externalIds;
    externalUrls = track.externalUrls;
    href = track.href;
    id = track.id;
    isPlayable = track.isPlayable;
    linkedFrom = track.linkedFrom;
    name = track.name;
    popularity = track.popularity;
    previewUrl = track.previewUrl;
    trackNumber = track.trackNumber;
    type = track.type;
    uri = track.uri;
  }

  static PipedAudioStream getStreamInfo(
    PipedStreamResponse item,
    AudioQuality audioQuality,
  ) {
    final streamFormat =
        kIsLinux ? PipedAudioStreamFormat.webm : PipedAudioStreamFormat.m4a;

    if (audioQuality == AudioQuality.high) {
      return item.highestBitrateAudioStreamOfFormat(streamFormat)!;
    } else {
      return item.lowestBitrateAudioStreamOfFormat(streamFormat)!;
    }
  }

  static Future<List<PipedSearchItemStream>> fetchSiblings(Track track) async {
    final artists = (track.artists ?? [])
        .map((ar) => ar.name)
        .toList()
        .whereNotNull()
        .toList();

    final title = ServiceUtils.getTitle(
      track.name!,
      artists: artists,
      onlyCleanArtist: true,
    ).trim();

    final List<PipedSearchItemStream> siblings = await PipedSpotube.client
        .search(
      "$title - ${artists.join(", ")}",
      PipedFilter.musicSongs,
    )
        .then(
      (res) {
        final siblings = res.items
            .whereType<PipedSearchItemStream>()
            .where((item) {
              return artists.any(
                (artist) =>
                    artist.toLowerCase() == item.uploaderName.toLowerCase(),
              );
            })
            .take(10)
            .toList();

        if (siblings.isEmpty) {
          return res.items.whereType<PipedSearchItemStream>().take(10).toList();
        }

        return siblings;
      },
    );

    return siblings;
  }

  static Future<SpotubeTrack> fetchFromTrack(
    Track track,
    UserPreferences preferences,
  ) async {
    final matchedCachedTrack = await MatchedTrack.box.get(track.id!);
    var siblings = <PipedSearchItemStream>[];
    PipedStreamResponse ytVideo;
    if (matchedCachedTrack != null) {
      ytVideo = await PipedSpotube.client.streams(matchedCachedTrack.youtubeId);
    } else {
      siblings = await fetchSiblings(track);
      ytVideo = await PipedSpotube.client.streams(siblings.first.id);

      await MatchedTrack.box.put(
        track.id!,
        MatchedTrack(
          youtubeId: ytVideo.id,
          spotifyId: track.id!,
        ),
      );
    }

    final PipedAudioStream ytStream =
        getStreamInfo(ytVideo, preferences.audioQuality);

    if (preferences.predownload &&
        ytVideo.duration < const Duration(minutes: 15)) {
      await DefaultCacheManager().getFileFromCache(track.id!).then(
        (file) async {
          if (file != null) return file.file;

          final res = await get(Uri.parse(ytStream.url));

          final cached = await DefaultCacheManager().putFile(
            track.id!,
            res.bodyBytes,
            fileExtension: ytStream.mimeType.split("/").last,
          );

          return cached;
        },
      );
    }

    return SpotubeTrack.fromTrack(
      track: track,
      ytTrack: ytVideo,
      ytUri: ytStream.url,
      siblings: siblings,
    );
  }

  Future<SpotubeTrack?> swappedCopy(
    PipedSearchItemStream video,
    UserPreferences preferences,
  ) async {
    if (siblings.none((element) => element.id == video.id)) return null;

    final ytVideo = await PipedSpotube.client.streams(video.id);

    final ytStream = getStreamInfo(ytVideo, preferences.audioQuality);

    final ytUri = ytStream.url;

    await MatchedTrack.box.put(
      id!,
      MatchedTrack(
        youtubeId: video.id,
        spotifyId: id!,
      ),
    );

    if (preferences.predownload &&
        video.duration < const Duration(minutes: 15)) {
      await DefaultCacheManager().getFileFromCache(id!).then(
        (file) async {
          if (file != null) return file.file;

          final res = await get(Uri.parse(ytStream.url));

          final cached = await DefaultCacheManager().putFile(
            id!,
            res.bodyBytes,
            fileExtension: ytStream.mimeType.split("/").last,
          );

          return cached;
        },
      );
    }

    return SpotubeTrack.fromTrack(
      track: this,
      ytTrack: ytVideo,
      ytUri: ytUri,
      siblings: [
        video,
        ...siblings.where((element) => element.id != video.id),
      ],
    );
  }

  static SpotubeTrack fromJson(Map<String, dynamic> map) {
    return SpotubeTrack.fromTrack(
      track: Track.fromJson(map),
      ytTrack: PipedStreamResponse.fromJson(map["ytTrack"]),
      ytUri: map["ytUri"],
      siblings: List.castFrom<dynamic, Map<String, dynamic>>(map["siblings"])
          .map((sibling) => PipedSearchItemStream.fromJson(sibling))
          .toList(),
    );
  }

  Future<SpotubeTrack> populatedCopy() async {
    if (this.siblings.isNotEmpty) return this;

    final siblings = await fetchSiblings(this);

    return SpotubeTrack.fromTrack(
      track: this,
      ytTrack: ytTrack,
      ytUri: ytUri,
      siblings: siblings,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // super values
      "album": album?.toJson(),
      "artists": artists?.map((artist) => artist.toJson()).toList(),
      "availableMarkets": availableMarkets,
      "discNumber": discNumber,
      "duration": duration.toString(),
      "durationMs": durationMs,
      "explicit": explicit,
      "href": href,
      "id": id,
      "isPlayable": isPlayable,
      "name": name,
      "popularity": popularity,
      "previewUrl": previewUrl,
      "trackNumber": trackNumber,
      "type": type,
      "uri": uri,
      // this values
      "ytTrack": ytTrack.toJson(),
      "ytUri": ytUri,
      "siblings": siblings.map((sibling) => sibling.toJson()).toList(),
    };
  }
}
