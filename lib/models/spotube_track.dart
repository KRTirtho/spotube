import 'dart:async';
import 'dart:convert';

import 'package:catcher/catcher.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart';
import 'package:piped_client/piped_client.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/extensions/piped.dart';
import 'package:spotube/extensions/album_simple.dart';
import 'package:spotube/extensions/artist_simple.dart';
import 'package:spotube/models/logger.dart';
import 'package:spotube/models/track.dart';
import 'package:spotube/provider/user_preferences_provider.dart';
import 'package:spotube/services/pocketbase.dart';
import 'package:spotube/services/youtube.dart';
import 'package:spotube/utils/platform.dart';
import 'package:spotube/utils/service_utils.dart';
import 'package:collection/collection.dart';

enum SpotubeTrackMatchAlgorithm {
  // selects the first result returned from YouTube
  youtube,
  // selects the most popular one
  popular,
  // selects the most popular one from the author of the track
  authenticPopular,
}

class SpotubeTrack extends Track {
  final PipedStreamResponse ytTrack;
  final String ytUri;
  final List<Map<String, int>> skipSegments;
  final List<PipedSearchItemStream> siblings;

  SpotubeTrack(
    this.ytTrack,
    this.ytUri,
    this.skipSegments,
    this.siblings,
  ) : super();

  SpotubeTrack.fromTrack({
    required Track track,
    required this.ytTrack,
    required this.ytUri,
    required this.skipSegments,
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

  static Future<List<Map<String, int>>> getSkipSegments(
    String id,
    UserPreferences preferences,
  ) async {
    if (!preferences.skipSponsorSegments) return [];
    try {
      final res = await get(Uri(
        scheme: "https",
        host: "sponsor.ajay.app",
        path: "/api/skipSegments",
        queryParameters: {
          "videoID": id,
          "category": [
            'sponsor',
            'selfpromo',
            'interaction',
            'intro',
            'outro',
            'music_offtopic'
          ],
          "actionType": 'skip'
        },
      ));

      if (res.body == "Not Found") {
        return List.castFrom<dynamic, Map<String, int>>([]);
      }

      final data = jsonDecode(res.body) as List;
      final segments = data.map((obj) {
        return Map.castFrom<String, dynamic, String, int>({
          "start": obj["segment"].first.toInt(),
          "end": obj["segment"].last.toInt(),
        });
      }).toList();
      getLogger(SpotubeTrack).v(
        "[SponsorBlock] successfully fetched skip segments for $id",
      );
      return List.castFrom<dynamic, Map<String, int>>(segments);
    } catch (e, stack) {
      Catcher.reportCheckedError(e, stack);
      return List.castFrom<dynamic, Map<String, int>>([]);
    }
  }

  static Future<SpotubeTrack> fetchFromTrack(
      Track track, UserPreferences preferences) async {
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

    final cachedTracks = await Future<RecordModel?>.value(
      pb
          .collection(BackendTrack.collection)
          .getFirstListItem("spotify_id = '${track.id}'"),
    ).catchError((e, stack) {
      return null;
    });

    final cachedTrack =
        cachedTracks != null ? BackendTrack.fromRecord(cachedTracks) : null;

    PipedStreamResponse ytVideo;
    PipedAudioStream ytStream;
    List<PipedSearchItemStream> siblings = [];
    List<Map<String, int>> skipSegments = [];
    if (cachedTrack != null) {
      final responses = await Future.wait(
        [
          PipedStreamResponseExtension.fromBackendTrack(cachedTrack),
          if (preferences.skipSponsorSegments)
            getSkipSegments(cachedTrack.youtubeId, preferences)
          else
            Future.value([])
        ],
      );
      ytVideo = responses.first as PipedStreamResponse;
      skipSegments = responses.last as List<Map<String, int>>;
      ytStream = getStreamInfo(ytVideo, preferences.audioQuality);
    } else {
      final videos = await PipedSpotube.client
          .search("${artists.join(", ")} - $title", PipedFilter.musicSongs);
      // await PrimitiveUtils.raceMultiple(
      //   () => youtube.search.search("${artists.join(", ")} - $title"),
      // );
      siblings =
          videos.items.whereType<PipedSearchItemStream>().take(10).toList();
      final responses = await Future.wait(
        [
          PipedSpotube.client.streams(siblings.first.id),
          if (preferences.skipSponsorSegments)
            getSkipSegments(siblings.first.id, preferences)
          else
            Future.value([])
        ],
      );
      ytVideo = responses.first as PipedStreamResponse;
      skipSegments = responses.last as List<Map<String, int>>;
      ytStream = getStreamInfo(ytVideo, preferences.audioQuality);
    }

    if (cachedTrack == null) {
      await Future<RecordModel?>.value(
          pb.collection(BackendTrack.collection).create(
                body: BackendTrack(
                  spotifyId: track.id!,
                  youtubeId: ytVideo.id,
                  votes: 0,
                ).toJson(),
              )).catchError((e, stack) {
        Catcher.reportCheckedError(e, stack);
        return null;
      });
    }

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
      skipSegments: skipSegments,
      siblings: siblings,
    );
  }

  Future<SpotubeTrack?> swappedCopy(
    PipedSearchItemStream video,
    UserPreferences preferences,
  ) async {
    if (siblings.none((element) => element.id == video.id)) return null;

    final [PipedStreamResponse ytVideo, List<Map<String, int>> skipSegments] =
        await Future.wait<dynamic>(
      [
        PipedSpotube.client.streams(video.id),
        if (preferences.skipSponsorSegments)
          getSkipSegments(video.id, preferences)
        else
          Future.value(<Map<String, int>>[])
      ],
    );

    // await PrimitiveUtils.raceMultiple(
    //   () => youtube.videos.streams.getManifest(video.id),
    // );

    final ytStream = getStreamInfo(ytVideo, preferences.audioQuality);

    final ytUri = ytStream.url;

    final cachedTracks = await Future<RecordModel?>.value(
      pb.collection(BackendTrack.collection).getFirstListItem(
            "spotify_id = '$id' && youtube_id = '${video.id}'",
          ),
    ).catchError((e, stack) {
      Catcher.reportCheckedError(e, stack);
      return null;
    });

    final cachedTrack =
        cachedTracks != null ? BackendTrack.fromRecord(cachedTracks) : null;

    if (cachedTrack == null) {
      await Future<RecordModel?>.value(
          pb.collection(BackendTrack.collection).create(
                body: BackendTrack(
                  spotifyId: id!,
                  youtubeId: video.id,
                  votes: 1,
                ).toJson(),
              )).catchError((e, stack) {
        Catcher.reportCheckedError(e, stack);
        return null;
      });
    } else {
      await Future<RecordModel?>.value(
          pb.collection(BackendTrack.collection).update(
        cachedTrack.id,
        body: {"votes": cachedTrack.votes + 1},
      )).catchError((e, stack) {
        Catcher.reportCheckedError(e, stack);
        return null;
      });
    }

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
      skipSegments: skipSegments,
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
      skipSegments:
          List.castFrom<dynamic, Map<String, int>>(map["skipSegments"]),
      siblings: List.castFrom<dynamic, Map<String, dynamic>>(map["siblings"])
          .map((sibling) => PipedSearchItemStream.fromJson(sibling))
          .toList(),
    );
  }

  Future<SpotubeTrack> populatedCopy() async {
    if (this.siblings.isNotEmpty) return this;
    final artists = (this.artists ?? [])
        .map((ar) => ar.name)
        .toList()
        .whereNotNull()
        .toList();

    final title = ServiceUtils.getTitle(
      name!,
      artists: artists,
      onlyCleanArtist: true,
    ).trim();
    final videos = await PipedSpotube.client.search(
      "${artists.join(", ")} - $title",
      PipedFilter.musicSongs,
    );

    final siblings =
        videos.items.whereType<PipedSearchItemStream>().take(10).toList();

    return SpotubeTrack.fromTrack(
      track: this,
      ytTrack: ytTrack,
      ytUri: ytUri,
      skipSegments: skipSegments,
      siblings: siblings,
    );
  }

  Map<String, dynamic> toJson() {
    return {
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
      "ytTrack": ytTrack.toJson(),
      "ytUri": ytUri,
      "skipSegments": skipSegments,
      "siblings": siblings.map((sibling) => sibling.toJson()).toList(),
    };
  }
}
