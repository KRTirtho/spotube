import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:dbus/dbus.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/entities/CacheTrack.dart';
import 'package:spotube/helpers/artist-to-string.dart';
import 'package:spotube/helpers/image-to-url-string.dart';
import 'package:spotube/helpers/search-youtube.dart';
import 'package:spotube/interfaces/media_player2.dart';
import 'package:spotube/interfaces/media_player2_player.dart';
import 'package:spotube/models/CurrentPlaylist.dart';
import 'package:spotube/models/Logger.dart';
import 'package:spotube/provider/DBus.dart';
import 'package:spotube/provider/UserPreferences.dart';
import 'package:spotube/provider/YouTube.dart';
import 'package:spotube/utils/AudioPlayerHandler.dart';
import 'package:spotube/utils/PersistedChangeNotifier.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class LegacyPlayback extends PersistedChangeNotifier {
  UrlSource? _currentAudioSource;
  final _logger = getLogger(LegacyPlayback);
  CurrentPlaylist? _currentPlaylist;
  Track? _currentTrack;

  // states
  bool _isPlaying = false;
  Duration? duration;

  bool _shuffled = false;

  AudioPlayerHandler player;
  YoutubeExplode youtube;
  Ref ref;

  LazyBox<CacheTrack>? cacheTrackBox;

  @protected
  final DBusClient? dbus;
  Media_Player? _media_player;
  Player_Interface? _mpris;

  double volume = 1;

  LegacyPlayback({
    required this.player,
    required this.youtube,
    required this.ref,
    required this.dbus,
    CurrentPlaylist? currentPlaylist,
    Track? currentTrack,
  })  : _currentPlaylist = currentPlaylist,
        _currentTrack = currentTrack,
        super() {
    player.onNextRequest = () {
      movePlaylistPositionBy(1);
    };
    player.onPreviousRequest = () {
      movePlaylistPositionBy(-1);
    };

    _init();
  }

  StreamSubscription<Duration?>? _durationStream;
  StreamSubscription<PlayerState>? _playingStream;
  StreamSubscription<Duration>? _positionStream;

  void _init() async {
    // dbus m.p.r.i.s stuff
    if (Platform.isLinux) {
      try {
        _media_player = Media_Player();
        _mpris = Player_Interface(player: player.core, playback: this);
        await dbus?.registerObject(_media_player!);
        await dbus?.registerObject(_mpris!);
      } catch (e) {
        logger.e("[MPRIS initialization error]", e);
      }
    }

    cacheTrackBox = await Hive.openLazyBox<CacheTrack>("track-cache");

    _playingStream = player.core.onPlayerStateChanged.listen(
      (state) async {
        _isPlaying = state == PlayerState.playing;
        if (state == PlayerState.completed) {
          if (_currentTrack?.id != null) {
            movePlaylistPositionBy(1);
          } else {
            _isPlaying = false;
            duration = null;
          }
        }
        notifyListeners();
      },
    );

    _durationStream = player.core.onDurationChanged.listen((event) {
      duration = event;
      notifyListeners();
    });

    _positionStream = player.core.onPositionChanged.listen((pos) async {
      if (pos > Duration.zero &&
          (duration == null || duration == Duration.zero)) {
        duration = await player.core.getDuration();
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _playingStream?.cancel();
    _durationStream?.cancel();
    _positionStream?.cancel();
    cacheTrackBox?.close();
    if (Platform.isLinux && _media_player != null && _mpris != null) {
      dbus?.unregisterObject(_media_player!);
      dbus?.unregisterObject(_mpris!);
    }
    super.dispose();
  }

  bool get shuffled => _shuffled;
  CurrentPlaylist? get currentPlaylist => _currentPlaylist;
  Track? get currentTrack => _currentTrack;
  bool get isPlaying => _isPlaying;

  set setCurrentTrack(Track track) {
    _logger.v("[Setting Current Track] ${track.name} - ${track.id}");
    _currentTrack = track;
    notifyListeners();
    updatePersistence();
  }

  set setCurrentPlaylist(CurrentPlaylist playlist) {
    _logger.v("[Current Playlist Changed] ${playlist.name} - ${playlist.id}");
    _currentPlaylist = playlist;
    notifyListeners();
    updatePersistence();
  }

  void reset() {
    _logger.v("Playback Reset");
    _isPlaying = false;
    _shuffled = false;
    duration = null;
    _currentPlaylist = null;
    _currentTrack = null;
    notifyListeners();
    updatePersistence(clearNullEntries: true);
  }

  void setVolume(double newVolume) {
    volume = newVolume;
    notifyListeners();
    updatePersistence();
  }

  /// sets the provided id matched track's uri\
  /// Doesn't notify listeners\
  /// @returns `bool` - `true` if succeed & `false` when failed
  bool setTrackUriById(String id, String uri) {
    if (_currentPlaylist == null) return false;
    try {
      int index =
          _currentPlaylist!.tracks.indexWhere((element) => element.id == id);
      if (index == -1) return false;
      _currentPlaylist!.tracks[index].uri = uri;
      updatePersistence();
      return _currentPlaylist!.tracks[index].uri == uri;
    } catch (e) {
      return false;
    }
  }

  void movePlaylistPositionBy(int pos) {
    _logger.v("[Playlist Position Move] $pos");
    if (_currentTrack != null && _currentPlaylist != null) {
      final int index =
          _currentPlaylist!.trackIds.indexOf(_currentTrack!.id!) + pos;

      final safeIndex = index > _currentPlaylist!.trackIds.length - 1
          ? 0
          : index < 0
              ? _currentPlaylist!.trackIds.length
              : index;
      Track? track = _currentPlaylist!.tracks.asMap().containsKey(safeIndex)
          ? _currentPlaylist!.tracks.elementAt(safeIndex)
          : null;
      if (track != null) {
        duration = null;
        _currentTrack = track;
        notifyListeners();
        updatePersistence();
        // starts to play the newly entered next/prev track
        startPlaying();
      }
    }
  }

  Future<void> startPlaying([Track? track]) async {
    _logger.v("[Track Playing] ${track?.name} - ${track?.id}");
    try {
      // the track is already playing so no need to change that
      if (track != null && track.id == _currentTrack?.id) return;
      track ??= _currentTrack;
      if (track != null) {
        Uri? parsedUri = Uri.tryParse(track.uri ?? "");
        final tag = MediaItem(
          id: track.id!,
          title: track.name!,
          album: track.album?.name,
          artist: artistsToString(track.artists ?? <ArtistSimple>[]),
          artUri: Uri.parse(imageToUrlString(track.album?.images)),
        );
        player.addItem(tag);
        if (parsedUri != null && parsedUri.hasAbsolutePath) {
          _currentAudioSource = UrlSource(parsedUri.toString());
          await player.core
              .play(
            _currentAudioSource!,
          )
              .then((value) async {
            _currentTrack = track;
            notifyListeners();
            updatePersistence();
          });
          return;
        }
        final preferences = ref.read(userPreferencesProvider);
        final spotubeTrack = await toSpotubeTrack(
          youtube: youtube,
          track: track,
          format: preferences.ytSearchFormat,
          matchAlgorithm: preferences.trackMatchAlgorithm,
          audioQuality: preferences.audioQuality,
          box: cacheTrackBox,
        );
        if (setTrackUriById(track.id!, spotubeTrack.ytUri)) {
          logger.v("[Track Direct Source] - ${spotubeTrack.ytUri}");
          _currentAudioSource = UrlSource(spotubeTrack.ytUri);
          await player.core
              .play(
            _currentAudioSource!,
          )
              .then((value) {
            _currentTrack = spotubeTrack;
            notifyListeners();
            updatePersistence();
          });
        }
      }
    } catch (e, stack) {
      _logger.e("startPlaying", e, stack);
    }
  }

  void shuffle() {
    if (currentPlaylist?.shuffle() == true) {
      _shuffled = true;
      notifyListeners();
    }
  }

  void unshuffle() {
    if (currentPlaylist?.unshuffle() == true) {
      _shuffled = false;
      notifyListeners();
    }
  }

  @override
  FutureOr<void> loadFromLocal(Map<String, dynamic> map) {
    if (map["currentPlaylist"] != null) {
      _currentPlaylist =
          CurrentPlaylist.fromJson(jsonDecode(map["currentPlaylist"]));
    }
    if (map["currentTrack"] != null) {
      _currentTrack = Track.fromJson(jsonDecode(map["currentTrack"]));
      startPlaying().then((_) {
        Timer.periodic(const Duration(milliseconds: 100), (timer) {
          if (player.core.state == PlayerState.playing) {
            player.pause();
            timer.cancel();
          }
        });
      });
    }
    volume = map["volume"] ?? volume;
  }

  @override
  FutureOr<Map<String, dynamic>> toMap() {
    return {
      "currentPlaylist": currentPlaylist != null
          ? jsonEncode(currentPlaylist?.toJson())
          : null,
      "currentTrack":
          currentTrack != null ? jsonEncode(currentTrack?.toJson()) : null,
      "volume": volume,
    };
  }
}

final legacyPlaybackProvider = ChangeNotifierProvider<LegacyPlayback>((ref) {
  final player = AudioPlayerHandler();
  final youtube = ref.watch(youtubeProvider);
  final dbus = ref.watch(dbusClientProvider);
  return LegacyPlayback(
    player: player,
    youtube: youtube,
    ref: ref,
    dbus: dbus,
  );
});
