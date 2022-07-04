import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/entities/CacheTrack.dart';
import 'package:spotube/extensions/yt-video-from-cache-track.dart';
import 'package:spotube/helpers/artist-to-string.dart';
import 'package:spotube/helpers/contains-text-in-bracket.dart';
import 'package:spotube/helpers/getLyrics.dart';
import 'package:spotube/helpers/image-to-url-string.dart';
import 'package:spotube/helpers/search-youtube.dart';
import 'package:spotube/models/CurrentPlaylist.dart';
import 'package:spotube/models/Logger.dart';
import 'package:spotube/models/SpotubeTrack.dart';
import 'package:spotube/provider/AudioPlayer.dart';
import 'package:spotube/provider/UserPreferences.dart';
import 'package:spotube/provider/YouTube.dart';
import 'package:spotube/services/LinuxAudioService.dart';
import 'package:spotube/services/MobileAudioService.dart';
import 'package:spotube/utils/PersistedChangeNotifier.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' hide Playlist;
import 'package:collection/collection.dart';
import 'package:spotube/extensions/list-sort-multiple.dart';

enum PlaybackStatus {
  playing,
  loading,
  idle,
}

class Playback extends PersistedChangeNotifier {
  // player properties
  bool isShuffled;
  bool isPlaying;
  Duration currentDuration;
  double volume;

  // class dependencies
  LinuxAudioService? _linuxAudioService;
  MobileAudioService? mobileAudioService;

  // foreign/passed properties
  AudioPlayer player;
  YoutubeExplode youtube;
  Ref ref;
  UserPreferences get preferences => ref.read(userPreferencesProvider);

  // playlist & track list properties
  late LazyBox<CacheTrack> cache;
  CurrentPlaylist? playlist;
  SpotubeTrack? track;

  // internal stuff
  final List<StreamSubscription> _subscriptions;
  final _logger = getLogger(Playback);

  PlaybackStatus status;

  Playback({
    required this.player,
    required this.youtube,
    required this.ref,
    this.mobileAudioService,
  })  : volume = 0,
        isShuffled = false,
        isPlaying = false,
        currentDuration = Duration.zero,
        _subscriptions = [],
        status = PlaybackStatus.idle,
        super() {
    if (Platform.isLinux) {
      _linuxAudioService = LinuxAudioService(this);
    }

    (() async {
      cache = await Hive.openLazyBox<CacheTrack>("track-cache");
      _subscriptions.addAll([
        player.onPlayerStateChanged.listen(
          (state) async {
            isPlaying = state == PlayerState.playing;
            notifyListeners();
          },
        ),
        player.onPlayerComplete.listen((_) {
          if (track?.id != null) {
            seekForward();
          } else {
            isPlaying = false;
            status = PlaybackStatus.idle;
            currentDuration = Duration.zero;
            notifyListeners();
          }
        }),
        player.onDurationChanged.listen((event) {
          if (event != currentDuration) {
            currentDuration = event;
            notifyListeners();
          }
        }),
        player.onPositionChanged.listen((pos) async {
          if (pos > Duration.zero && currentDuration == Duration.zero) {
            currentDuration = await player.getDuration() ?? Duration.zero;
            notifyListeners();
          }
        }),
      ]);
    }());
  }

  @override
  void dispose() {
    _linuxAudioService?.dispose();
    for (var subscription in _subscriptions) {
      subscription.cancel();
    }
    super.dispose();
  }

  Future<void> playPlaylist(CurrentPlaylist playlist, [int index = 0]) async {
    if (index < 0 || index > playlist.tracks.length - 1) return;
    this.playlist = playlist;
    final played = this.playlist!.tracks[index];
    status = PlaybackStatus.loading;
    notifyListeners();
    await play(played).then((_) {
      int i = this
          .playlist!
          .tracks
          .indexWhere((element) => element.id == played.id);
      if (index == -1) return;
      this.playlist!.tracks[i] = track!;
    });
  }

  // player methods
  Future<void> play(Track track) async {
    _logger.v("[Track Playing] ${track.name} - ${track.id}");
    try {
      // the track is already playing so no need to change that
      if (track.id == this.track?.id) return;
      if (status != PlaybackStatus.loading) {
        status = PlaybackStatus.loading;
        notifyListeners();
      }
      final tag = MediaItem(
        id: track.id!,
        title: track.name!,
        album: track.album?.name,
        artist: artistsToString(track.artists ?? <ArtistSimple>[]),
        artUri: Uri.parse(imageToUrlString(track.album?.images)),
      );
      mobileAudioService?.addItem(tag);

      // the track is not a SpotubeTrack so turning it to one
      if (track is! SpotubeTrack) {
        track = await toSpotubeTrack(track);
      }
      _logger.v("[Track Direct Source] - ${(track).ytUri}");
      this.track = track;
      notifyListeners();
      updatePersistence();
      await player.play(UrlSource(track.ytUri));
      status = PlaybackStatus.playing;
      notifyListeners();
    } catch (e, stack) {
      _logger.e("play", e, stack);
    }
  }

  Future<void> resume() async {
    if (isPlaying || (playlist == null && track == null)) return;
    await player.resume();
    isPlaying = true;
    notifyListeners();
  }

  Future<void> pause() async {
    if (!isPlaying || (playlist == null && track == null)) return;
    await player.pause();
    isPlaying = false;
    notifyListeners();
  }

  Future<void> togglePlayPause() async {
    isPlaying ? await pause() : await resume();
  }

  toggleShuffle() {
    final result = isShuffled ? playlist?.unshuffle() : playlist?.shuffle();
    if (result == true) {
      isShuffled = !isShuffled;
      notifyListeners();
    }
  }

  Future<void> seekPosition(Duration position) {
    return player.seek(position);
  }

  Future<void> setVolume(double newVolume) async {
    await player.setVolume(volume);
    volume = newVolume;
    notifyListeners();
    updatePersistence();
  }

  Future<void> stop() async {
    await player.stop();
    await player.release();
    isPlaying = false;
    isShuffled = false;
    playlist = null;
    track = null;
    status = PlaybackStatus.idle;
    currentDuration = Duration.zero;
    notifyListeners();
    updatePersistence(clearNullEntries: true);
  }

  void destroy() {
    stop();
    player.dispose();
  }

  // playlist & track list methods
  Future<SpotubeTrack> toSpotubeTrack(Track track) async {
    final format = preferences.ytSearchFormat;
    final matchAlgorithm = preferences.trackMatchAlgorithm;
    final artistsName =
        track.artists?.map((ar) => ar.name).toList().whereNotNull().toList() ??
            [];
    final audioQuality = preferences.audioQuality;
    _logger.v("[Track Search Artists] $artistsName");
    final mainArtist = artistsName.first;
    final featuredArtists = artistsName.length > 1
        ? "feat. " + artistsName.sublist(1).join(" ")
        : "";
    final title = getTitle(
      track.name!,
      artists: artistsName,
      onlyCleanArtist: true,
    ).trim();
    _logger.v("[Track Search Title] $title");
    final queryString = format
        .replaceAll("\$MAIN_ARTIST", mainArtist)
        .replaceAll("\$TITLE", title)
        .replaceAll("\$FEATURED_ARTISTS", featuredArtists);
    _logger.v("[Youtube Search Term] $queryString");

    Video ytVideo;
    final cachedTrack = await cache.get(track.id);
    if (cachedTrack != null && cachedTrack.mode == matchAlgorithm.name) {
      _logger.v(
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
                if (matchAlgorithm ==
                    SpotubeTrackMatchAlgorithm.authenticPopular)
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

    _logger.v(
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
      await cache.put(
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

  Future<void> setPlaylistPosition(int position) async {
    if (playlist == null) return;
    await playPlaylist(playlist!, position);
  }

  Future<void> seekForward() async {
    if (playlist == null || track == null) return;
    final int nextTrackIndex =
        (playlist!.trackIds.indexOf(track!.id!) + 1).toInt();
    // checking if there's any track available forward
    if (nextTrackIndex > (playlist?.tracks.length ?? 0) - 1) return;
    await play(playlist!.tracks.elementAt(nextTrackIndex));
  }

  Future<void> seekBackward() async {
    if (playlist == null || track == null) return;
    final int prevTrackIndex =
        (playlist!.trackIds.indexOf(track!.id!) - 1).toInt();
    // checking if there's any track available behind
    if (prevTrackIndex < 0) return;
    await play(playlist!.tracks.elementAt(prevTrackIndex));
  }

  @override
  FutureOr<void> loadFromLocal(Map<String, dynamic> map) async {
    if (map["playlist"] != null) {
      playlist = CurrentPlaylist.fromJson(jsonDecode(map["playlist"]));
    }
    if (map["track"] != null) {
      track = SpotubeTrack.fromJson(jsonDecode(map["track"]));
    }
    volume = map["volume"] ?? volume;
  }

  @override
  FutureOr<Map<String, dynamic>> toMap() {
    return {
      "playlist": playlist != null ? jsonEncode(playlist?.toJson()) : null,
      "track": track != null ? jsonEncode(track?.toJson()) : null,
      "volume": volume,
    };
  }
}

final playbackProvider = ChangeNotifierProvider<Playback>((ref) {
  final youtube = ref.watch(youtubeProvider);
  final player = ref.watch(audioPlayerProvider);
  return Playback(
    player: player,
    youtube: youtube,
    ref: ref,
  );
});
