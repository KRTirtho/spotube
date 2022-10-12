import 'dart:async';
import 'dart:convert';

import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/entities/CacheTrack.dart';
import 'package:spotube/extensions/yt-video-from-cache-track.dart';
import 'package:spotube/models/CurrentPlaylist.dart';
import 'package:spotube/models/Logger.dart';
import 'package:spotube/models/SpotubeTrack.dart';
import 'package:spotube/provider/AudioPlayer.dart';
import 'package:spotube/provider/UserPreferences.dart';
import 'package:spotube/provider/YouTube.dart';
import 'package:spotube/services/LinuxAudioService.dart';
import 'package:spotube/services/MobileAudioService.dart';
import 'package:spotube/utils/PersistedChangeNotifier.dart';
import 'package:spotube/utils/platform.dart';
import 'package:spotube/utils/primitive_utils.dart';
import 'package:spotube/utils/service_utils.dart';
import 'package:spotube/utils/type_conversion_utils.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' hide Playlist;
import 'package:collection/collection.dart';
import 'package:spotube/extensions/list-sort-multiple.dart';
import 'package:http/http.dart' as http;

enum PlaybackStatus {
  playing,
  loading,
  idle,
}

enum AudioQuality {
  high,
  low,
}

enum PlaybackMode {
  repeat,
  shuffle,
  normal,
}

class Playback extends PersistedChangeNotifier {
  // player properties
  PlaybackMode playbackMode;
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
  // state of preSearch used inside [onPositionChanged]
  bool _isPreSearching = false;

  PlaybackStatus status;

  Playback({
    required this.player,
    required this.youtube,
    required this.ref,
    this.mobileAudioService,
  })  : volume = 1,
        isPlaying = false,
        playbackMode = PlaybackMode.normal,
        currentDuration = Duration.zero,
        _subscriptions = [],
        status = PlaybackStatus.idle,
        super() {
    if (kIsLinux) {
      _linuxAudioService = LinuxAudioService(this);
    }

    (() async {
      cache = await Hive.openLazyBox<CacheTrack>("track-cache");

      if (kIsAndroid) {
        await player.setVolume(1);
        volume = 1;
      } else {
        await player.setVolume(volume);
      }

      addListener(() {
        _linuxAudioService?.player.updateProperties(this);
      });

      _subscriptions.addAll([
        player.onPlayerStateChanged.listen(
          (state) async {
            isPlaying = state == PlayerState.playing;
            notifyListeners();
          },
        ),
        player.onPlayerComplete.listen((_) {
          if (track?.id != null) {
            if (isLoop) {
              final prevTrack = track;
              track = null;
              play(prevTrack!);
            } else if (playlist != null) {
              seekForward();
            }
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

          final currentTrackIndex =
              playlist?.tracks.indexWhere((t) => t.id == track?.id);

          // when the track progress is above 80%, track isn't the last
          // and is not already fetched and nothing is fetching currently
          if (pos.inSeconds > currentDuration.inSeconds * .8 &&
              playlist != null &&
              currentTrackIndex != playlist!.tracks.length - 1 &&
              playlist!.tracks.elementAt(currentTrackIndex! + 1)
                  is! SpotubeTrack &&
              !_isPreSearching) {
            _isPreSearching = true;
            playlist!.tracks[currentTrackIndex + 1] = await toSpotubeTrack(
              playlist!.tracks[currentTrackIndex + 1],
            ).then((v) {
              _isPreSearching = false;
              return v;
            });
          }
          if (track != null && preferences.skipSponsorSegments) {
            for (final segment in track!.skipSegments) {
              if (pos.inSeconds == segment["start"] ||
                  (pos.inSeconds > segment["start"]! &&
                      pos.inSeconds < segment["end"]!)) {
                seekPosition(Duration(seconds: segment["end"]!));
              }
            }
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
    try {
      if (index < 0 || index > playlist.tracks.length - 1) return;
      if (isPlaying || status == PlaybackStatus.playing) await stop();
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
    } catch (e) {
      _logger.e("[playPlaylist] $e");
    }
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

      // the track is not a SpotubeTrack so turning it to one
      if (track is! SpotubeTrack) {
        track = await toSpotubeTrack(track);
      }

      final tag = MediaItem(
        id: track.id!,
        title: track.name!,
        album: track.album?.name,
        artist: TypeConversionUtils.artists_X_String(
            track.artists ?? <ArtistSimple>[]),
        artUri: Uri.parse(
          TypeConversionUtils.image_X_UrlString(
            track.album?.images,
            placeholder: ImagePlaceholder.online,
          ),
        ),
        duration: track.ytTrack.duration,
      );
      mobileAudioService?.addItem(tag);
      _logger.v("[Track Direct Source] - ${(track).ytUri}");
      this.track = track;
      notifyListeners();
      updatePersistence();
      await player.play(
        track.ytUri.startsWith("http")
            ? UrlSource(track.ytUri)
            : DeviceFileSource(track.ytUri),
      );
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

  void cyclePlaybackMode() {
    switch (playbackMode) {
      case PlaybackMode.normal:
        playbackMode = PlaybackMode.shuffle;
        playlist?.shuffle();
        break;
      case PlaybackMode.shuffle:
        playbackMode = PlaybackMode.repeat;
        playlist?.unshuffle();
        break;
      case PlaybackMode.repeat:
        playbackMode = PlaybackMode.normal;
        break;
    }
    notifyListeners();
  }

  void setPlaybackMode(PlaybackMode mode) {
    playbackMode = mode;
    notifyListeners();
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
    playbackMode = PlaybackMode.normal;
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

  Future<T> raceMultiple<T>(
    Future<T> Function() inner, {
    Duration timeout = const Duration(milliseconds: 2500),
    int retryCount = 4,
  }) async {
    return Future.any(
      List.generate(retryCount, (i) {
        if (i == 0) return inner();
        return Future.delayed(
          Duration(milliseconds: timeout.inMilliseconds * i),
          inner,
        );
      }),
    );
  }

  Future<List<Map<String, int>>> getSkipSegments(String id) async {
    if (!preferences.skipSponsorSegments) return [];
    try {
      final res = await http.get(Uri(
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

      final data = jsonDecode(res.body);
      final segments = data.map((obj) {
        return Map.castFrom<String, dynamic, String, int>({
          "start": obj["segment"].first.toInt(),
          "end": obj["segment"].last.toInt(),
        });
      }).toList();
      _logger.v(
        "[SponsorBlock] successfully fetched skip segments for ${track?.name} | ${track?.ytTrack.id.value}",
      );
      return List.castFrom<dynamic, Map<String, int>>(segments);
    } catch (e, stack) {
      _logger.e("[getSkipSegments]", e, stack);
      return List.castFrom<dynamic, Map<String, int>>([]);
    }
  }

  // playlist & track list methods
  Future<SpotubeTrack> toSpotubeTrack(
    Track track, {
    bool noSponsorBlock = false,
  }) async {
    try {
      final format = preferences.ytSearchFormat;
      final matchAlgorithm = preferences.trackMatchAlgorithm;
      final artistsName = track.artists
              ?.map((ar) => ar.name)
              .toList()
              .whereNotNull()
              .toList() ??
          [];
      final audioQuality = preferences.audioQuality;
      _logger.v("[Track Search Artists] $artistsName");
      final mainArtist = artistsName.first;
      final featuredArtists = artistsName.length > 1
          ? "feat. " + artistsName.sublist(1).join(" ")
          : "";
      final title = ServiceUtils.getTitle(
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
        VideoSearchList videos =
            await raceMultiple(() => youtube.search.search(queryString));
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
                    !PrimitiveUtils.containsTextInBracket(ytTitle, "live");
                final bool hasCloseDuration =
                    (track.duration!.inSeconds - video.duration!.inSeconds)
                            .abs() <=
                        10; //Duration matching threshold

                int rate = 0;
                for (final el in [
                  hasTitle,
                  hasAllArtists,
                  if (matchAlgorithm ==
                      SpotubeTrackMatchAlgorithm.authenticPopular)
                    authorIsArtist,
                  hasNoLiveInTitle,
                  hasCloseDuration,
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

      StreamManifest trackManifest = await raceMultiple(
        () => youtube.videos.streams.getManifest(ytVideo.id),
      );

      _logger.v(
        "[YouTube Matched Track] ${ytVideo.title} | ${ytVideo.author} - ${ytVideo.url}",
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

      final ytUri = (audioQuality == AudioQuality.high
              ? audioManifest.withHighestBitrate()
              : audioManifest.sortByBitrate().last)
          .url
          .toString();

      final skipSegments = cachedTrack?.skipSegments != null &&
              cachedTrack!.skipSegments!.isNotEmpty
          ? cachedTrack.skipSegments!
              .map(
                (segment) => segment.toJson(),
              )
              .toList()
          : noSponsorBlock
              ? List.castFrom<dynamic, Map<String, int>>([])
              : await getSkipSegments(ytVideo.id.value);

      // only save when the track isn't available in the cache with same
      // matchAlgorithm
      if (cachedTrack == null || cachedTrack.mode != matchAlgorithm.name) {
        await cache.put(
          track.id!,
          CacheTrack.fromVideo(
            ytVideo,
            matchAlgorithm.name,
            skipSegments: skipSegments,
          ),
        );
      }

      return SpotubeTrack.fromTrack(
        track: track,
        ytTrack: ytVideo,
        // Since Mac OS's & IOS's CodeAudio doesn't support WebMedia
        // ('audio/webm', 'video/webm' & 'image/webp') thus using 'audio/mpeg'
        // codec/mimetype for those Platforms
        ytUri: ytUri,
        skipSegments: skipSegments,
      );
    } catch (e, stack) {
      _logger.e("topSpotubeTrack", e, stack);
      rethrow;
    }
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
    await play(playlist!.tracks.elementAt(nextTrackIndex)).then((_) {
      playlist!.tracks[nextTrackIndex] = track!;
    });
  }

  Future<void> seekBackward() async {
    if (playlist == null || track == null) return;
    final int prevTrackIndex =
        (playlist!.trackIds.indexOf(track!.id!) - 1).toInt();
    // checking if there's any track available behind
    if (prevTrackIndex < 0) return;
    await play(playlist!.tracks.elementAt(prevTrackIndex)).then((_) {
      playlist!.tracks[prevTrackIndex] = track!;
    });
  }

  @override
  FutureOr<void> loadFromLocal(Map<String, dynamic> map) async {
    try {
      if (map["playlist"] != null) {
        playlist = CurrentPlaylist.fromJson(jsonDecode(map["playlist"]));
      }
      if (map["track"] != null) {
        final Map<String, dynamic> trackMap = jsonDecode(map["track"]);
        // for backwards compatibility
        if (!trackMap.containsKey("skipSegments")) {
          trackMap["skipSegments"] = await getSkipSegments(
            trackMap["id"],
          );
        }
        track = SpotubeTrack.fromJson(trackMap);
      }
      volume = map["volume"] ?? volume;
    } catch (e, stack) {
      _logger.e("loadFromLocal", e, stack);
    }
  }

  @override
  FutureOr<Map<String, dynamic>> toMap() {
    return {
      "playlist": playlist != null ? jsonEncode(playlist?.toJson()) : null,
      "track": track != null ? jsonEncode(track?.toJson()) : null,
      "volume": volume,
    };
  }

  bool get isLoop => playbackMode == PlaybackMode.repeat;
  bool get isShuffled => playbackMode == PlaybackMode.shuffle;
  bool get isNormal => playbackMode == PlaybackMode.normal;
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
