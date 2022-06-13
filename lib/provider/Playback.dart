import 'dart:async';
import 'dart:convert';

import 'package:audio_service/audio_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/helpers/artist-to-string.dart';
import 'package:spotube/helpers/image-to-url-string.dart';
import 'package:spotube/helpers/search-youtube.dart';
import 'package:spotube/models/CurrentPlaylist.dart';
import 'package:spotube/models/Logger.dart';
import 'package:spotube/provider/UserPreferences.dart';
import 'package:spotube/provider/YouTube.dart';
import 'package:spotube/utils/AudioPlayerHandler.dart';
import 'package:spotube/utils/PersistedChangeNotifier.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class Playback extends PersistedChangeNotifier {
  AudioSource? _currentAudioSource;
  final _logger = getLogger(Playback);
  CurrentPlaylist? _currentPlaylist;
  Track? _currentTrack;

  // states
  bool _isPlaying = false;
  Duration? duration;

  Duration _prevPosition = Duration.zero;
  bool _shuffled = false;

  AudioPlayerHandler player;
  YoutubeExplode youtube;
  Ref ref;
  Playback({
    required this.player,
    required this.youtube,
    required this.ref,
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
  StreamSubscription<Duration>? _positionStream;
  StreamSubscription<bool>? _playingStream;

  void _init() async {
    _playingStream = player.core.playingStream.listen(
      (playing) {
        _isPlaying = playing;
        notifyListeners();
      },
    );

    _durationStream = player.core.durationStream.listen((event) async {
      if (event != null) {
        // Actually things doesn't work all the time as they were
        // described. So instead of listening to a `_ready`
        // stream, it has to listen to duration stream since duration
        // is always added to the Stream sink after all icyMetadata has
        // been loaded thus indicating buffering started
        if (event != Duration.zero && event != duration) {
          // this line is for prev/next or already playing playlist
          if (player.core.playing) await player.pause();
          await player.play();
        }
        duration = event;
        notifyListeners();
      }
    });

    _positionStream =
        player.core.createPositionStream().listen((position) async {
      // detecting multiple same call
      if (_prevPosition.inSeconds == position.inSeconds) return;
      _prevPosition = position;

      /// Because of ProcessingState.complete never gets set bug using a
      /// custom solution to know when the audio stops playing
      ///
      /// Details: https://github.com/KRTirtho/spotube/issues/46
      if (duration != Duration.zero &&
          duration?.isNegative == false &&
          position.inSeconds == duration?.inSeconds) {
        if (_currentTrack?.id != null) {
          await player.pause();
          movePlaylistPositionBy(1);
        } else {
          _isPlaying = false;
          duration = null;
          notifyListeners();
        }
      }
    });
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    _playingStream?.cancel();
    _durationStream?.cancel();
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
      int index = _currentPlaylist!.trackIds.indexOf(_currentTrack!.id!) + pos;

      var safeIndex = index > _currentPlaylist!.trackIds.length - 1
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
          _currentAudioSource = AudioSource.uri(parsedUri);
          await player.core
              .setAudioSource(
            _currentAudioSource!,
            preload: true,
          )
              .then((value) async {
            _currentTrack = track;
            notifyListeners();
            updatePersistence();
          });
          // await player.play();
          return;
        }
        final preferences = ref.read(userPreferencesProvider);
        final spotubeTrack = await toSpotubeTrack(
          youtube: youtube,
          track: track,
          format: preferences.ytSearchFormat,
          matchAlgorithm: preferences.trackMatchAlgorithm,
          audioQuality: preferences.audioQuality,
        );
        if (setTrackUriById(track.id!, spotubeTrack.ytUri)) {
          logger.v("[Track Direct Source] - ${spotubeTrack.ytUri}");
          _currentAudioSource = AudioSource.uri(Uri.parse(spotubeTrack.ytUri));
          await player.core
              .setAudioSource(
            _currentAudioSource!,
            preload: true,
          )
              .then((value) {
            _currentTrack = spotubeTrack;
            notifyListeners();
            updatePersistence();
          });
          // await player.play();
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
          if (player.core.playing) {
            player.pause();
            timer.cancel();
          }
        });
      });
    }
  }

  @override
  FutureOr<Map<String, dynamic>> toMap() {
    return {
      "currentPlaylist": currentPlaylist != null
          ? jsonEncode(currentPlaylist?.toJson())
          : null,
      "currentTrack":
          currentTrack != null ? jsonEncode(currentTrack?.toJson()) : null,
    };
  }
}

final playbackProvider = ChangeNotifierProvider<Playback>((ref) {
  final player = AudioPlayerHandler();
  final youtube = ref.watch(youtubeProvider);
  return Playback(
    player: player,
    youtube: youtube,
    ref: ref,
  );
});
