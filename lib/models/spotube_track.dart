import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/extensions/video.dart';
import 'package:spotube/extensions/album_simple.dart';
import 'package:spotube/extensions/artist_simple.dart';
import 'package:spotube/models/track.dart';
import 'package:spotube/provider/user_preferences_provider.dart';
import 'package:spotube/services/pocketbase.dart';
import 'package:spotube/services/youtube.dart';
import 'package:spotube/utils/platform.dart';
import 'package:spotube/utils/primitive_utils.dart';
import 'package:spotube/utils/service_utils.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
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
  final Video ytTrack;
  final String ytUri;
  final List<Map<String, int>> skipSegments;
  final List<Video> siblings;

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

  static Future<SpotubeTrack> fromFetchTrack(
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

    final cachedTracks = await pb.collection(BackendTrack.collection).getList(
          filter: "spotify_id = '${track.id}'",
          sort: "-votes",
          page: 0,
          perPage: 1,
        );

    final cachedTrack = cachedTracks.items.isNotEmpty
        ? BackendTrack.fromRecord(cachedTracks.items.first)
        : null;

    Video ytVideo;
    List<Video> siblings = [];
    if (cachedTrack != null) {
      ytVideo = await VideoFromCacheTrackExtension.fromBackendTrack(
        cachedTrack,
        youtube,
      );
    } else {
      VideoSearchList videos = await PrimitiveUtils.raceMultiple(
        () => youtube.search.search("${artists.join(", ")} - $title"),
      );
      siblings = videos.where((video) => !video.isLive).take(10).toList();
      ytVideo = siblings.first;
    }

    StreamManifest trackManifest = await PrimitiveUtils.raceMultiple(
      () => youtube.videos.streams.getManifest(ytVideo.id),
    );

    final audioManifest = trackManifest.audioOnly.where((info) {
      final isMp4a = info.codec.mimeType == "audio/mp4";
      if (kIsLinux) {
        return !isMp4a;
      } else if (kIsMacOS || kIsIOS) {
        return isMp4a;
      } else {
        return true;
      }
    });

    final chosenStreamInfo = preferences.audioQuality == AudioQuality.high
        ? audioManifest.withHighestBitrate()
        : audioManifest.sortByBitrate().last;

    final ytUri = chosenStreamInfo.url.toString();

    if (cachedTrack == null) {
      await pb.collection(BackendTrack.collection).create(
            body: BackendTrack(
              spotifyId: track.id!,
              youtubeId: ytVideo.id.value,
              votes: 0,
            ).toJson(),
          );
    }

    if (preferences.predownload &&
        ytVideo.duration! < const Duration(minutes: 15)) {
      await DefaultCacheManager().getFileFromCache(track.id!).then(
        (file) async {
          if (file != null) return file.file;
          final List<int> bytesStore = [];
          final bytesFuture = Completer<Uint8List>();

          youtube.videos.streams.get(chosenStreamInfo).listen(
            (data) {
              bytesStore.addAll(data);
            },
            onDone: () {
              bytesFuture.complete(Uint8List.fromList(bytesStore));
            },
            onError: (e) {
              bytesFuture.completeError(e);
            },
          );

          final cached = await DefaultCacheManager().putFile(
            track.id!,
            await bytesFuture.future,
            fileExtension: chosenStreamInfo.codec.mimeType.split("/").last,
          );

          return cached;
        },
      );
    }

    return SpotubeTrack.fromTrack(
      track: track,
      ytTrack: ytVideo,
      ytUri: ytUri,
      skipSegments: preferences.skipSponsorSegments
          ? await ytVideo.getSkipSegments(preferences)
          : [],
      siblings: siblings,
    );
  }

  Future<SpotubeTrack?> swappedCopy(
    Video video,
    UserPreferences preferences,
  ) async {
    if (siblings.none((element) => element.id == video.id)) return null;

    StreamManifest trackManifest = await PrimitiveUtils.raceMultiple(
      () => youtube.videos.streams.getManifest(video.id),
    );

    final audioManifest = trackManifest.audioOnly.where((info) {
      final isMp4a = info.codec.mimeType == "audio/mp4";
      if (kIsLinux) {
        return !isMp4a;
      } else if (kIsMacOS || kIsIOS) {
        return isMp4a;
      } else {
        return true;
      }
    });

    final chosenStreamInfo = preferences.audioQuality == AudioQuality.high
        ? audioManifest.withHighestBitrate()
        : audioManifest.sortByBitrate().last;

    final ytUri = chosenStreamInfo.url.toString();

    final cachedTracks = await pb.collection(BackendTrack.collection).getList(
          filter: "spotify_id = '$id' && youtube_id = '${video.id.value}'",
          sort: "-votes",
          page: 0,
          perPage: 1,
        );

    final cachedTrack = cachedTracks.items.isNotEmpty
        ? BackendTrack.fromRecord(cachedTracks.items.first)
        : null;

    if (cachedTrack == null) {
      await pb.collection(BackendTrack.collection).create(
            body: BackendTrack(
              spotifyId: id!,
              youtubeId: video.id.value,
              votes: 1,
            ).toJson(),
          );
    } else {
      await pb.collection(BackendTrack.collection).update(
        cachedTrack.id,
        body: {
          "votes": cachedTrack.votes + 1,
        },
      );
    }

    if (preferences.predownload &&
        video.duration! < const Duration(minutes: 15)) {
      await DefaultCacheManager().getFileFromCache(id!).then(
        (file) async {
          if (file != null) return file.file;
          final List<int> bytesStore = [];
          final bytesFuture = Completer<Uint8List>();

          youtube.videos.streams.get(chosenStreamInfo).listen(
            (data) {
              bytesStore.addAll(data);
            },
            onDone: () {
              bytesFuture.complete(Uint8List.fromList(bytesStore));
            },
            onError: (e) {
              bytesFuture.completeError(e);
            },
          );

          final cached = await DefaultCacheManager().putFile(
            id!,
            await bytesFuture.future,
            fileExtension: chosenStreamInfo.codec.mimeType.split("/").last,
          );

          return cached;
        },
      );
    }

    return SpotubeTrack.fromTrack(
      track: this,
      ytTrack: video,
      ytUri: ytUri,
      skipSegments: preferences.skipSponsorSegments
          ? await video.getSkipSegments(preferences)
          : [],
      siblings: [
        video,
        ...siblings.where((element) => element.id != video.id),
      ],
    );
  }

  static SpotubeTrack fromJson(Map<String, dynamic> map) {
    return SpotubeTrack.fromTrack(
      track: Track.fromJson(map),
      ytTrack: VideoToJson.fromJson(map["ytTrack"]),
      ytUri: map["ytUri"],
      skipSegments:
          List.castFrom<dynamic, Map<String, int>>(map["skipSegments"]),
      siblings: List.castFrom<dynamic, Map<String, dynamic>>(map["siblings"])
          .map((sibling) => VideoToJson.fromJson(sibling))
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
    VideoSearchList videos = await PrimitiveUtils.raceMultiple(
      () => youtube.search.search("${artists.join(", ")} - $title"),
    );

    final siblings = videos.where((video) => !video.isLive).take(10).toList();

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
