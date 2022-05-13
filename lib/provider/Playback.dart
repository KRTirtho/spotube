import 'dart:async';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/helpers/artist-to-string.dart';
import 'package:spotube/helpers/image-to-url-string.dart';
import 'package:spotube/helpers/search-youtube.dart';
import 'package:spotube/models/Logger.dart';
import 'package:spotube/provider/AudioPlayer.dart';
import 'package:spotube/provider/UserPreferences.dart';
import 'package:spotube/provider/YouTube.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class CurrentPlaylist {
  List<Track>? _tempTrack;
  List<Track> tracks;
  String id;
  String name;
  String thumbnail;

  CurrentPlaylist({
    required this.tracks,
    required this.id,
    required this.name,
    required this.thumbnail,
  });

  List<String> get trackIds => tracks.map((e) => e.id!).toList();

  bool shuffle() {
    // won't shuffle if already shuffled
    if (_tempTrack == null) {
      _tempTrack = [...tracks];
      tracks.shuffle();
      return true;
    }
    return false;
  }

  bool unshuffle() {
    // without _tempTracks unshuffling can't be done
    if (_tempTrack != null) {
      tracks = [..._tempTrack!];
      _tempTrack = null;
      return true;
    }
    return false;
  }
}

class Playback extends ChangeNotifier {
  ChangeNotifierProviderRef<Playback> ref;
  AudioSource? _currentAudioSource;
  final _logger = getLogger(Playback);
  CurrentPlaylist? _currentPlaylist;
  Track? _currentTrack;

  // states
  bool _isPlaying = false;
  Duration? duration;

  // listeners
  StreamSubscription<bool>? _playingStreamListener;
  StreamSubscription<Duration?>? _durationStreamListener;
  StreamSubscription<AudioInterruptionEvent>? _audioInterruptionEventListener;
  StreamSubscription<Duration>? _positionStreamListener;

  Duration _prevPosition = Duration.zero;
  bool _shuffled = false;

  AudioPlayer player;
  YoutubeExplode youtube;
  AudioSession? _audioSession;
  Playback({
    required this.player,
    required this.youtube,
    required this.ref,
    CurrentPlaylist? currentPlaylist,
    Track? currentTrack,
  })  : _currentPlaylist = currentPlaylist,
        _currentTrack = currentTrack;

  void register() {
    _playingStreamListener = player.playingStream.listen(
      (playing) {
        _isPlaying = playing;
        notifyListeners();
      },
    );

    _durationStreamListener = player.durationStream.listen((event) async {
      if (event != null) {
        // Actually things doesn't work all the time as they were
        // described. So instead of listening to a `_ready`
        // stream, it has to listen to duration stream since duration
        // is always added to the Stream sink after all icyMetadata has
        // been loaded thus indicating buffering started
        if (event != Duration.zero && event != duration) {
          // this line is for prev/next or already playing playlist
          if (player.playing) await player.pause();
          await player.play();
        }
        duration = event;
        notifyListeners();
      }
    });

    _positionStreamListener =
        player.createPositionStream().listen((position) async {
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
          await audioSession?.setActive(false);
          _isPlaying = false;
          duration = null;
          notifyListeners();
        }
      }
    });

    AudioSession.instance.then((session) async {
      _audioSession = session;
      await session.configure(const AudioSessionConfiguration.music());
      _audioInterruptionEventListener = session.interruptionEventStream.listen(
        (AudioInterruptionEvent event) {},
      );
    });
  }

  bool get shuffled => _shuffled;
  CurrentPlaylist? get currentPlaylist => _currentPlaylist;
  Track? get currentTrack => _currentTrack;
  bool get isPlaying => _isPlaying;
  AudioSession? get audioSession => _audioSession;

  set setCurrentTrack(Track track) {
    _logger.v("[Setting Current Track] ${track.name} - ${track.id}");
    _currentTrack = track;
    notifyListeners();
  }

  set setCurrentPlaylist(CurrentPlaylist playlist) {
    _logger.v("[Current Playlist Changed] ${playlist.name} - ${playlist.id}");
    _currentPlaylist = playlist;
    notifyListeners();
  }

  void reset() {
    _logger.v("Playback Reset");
    _isPlaying = false;
    _shuffled = false;
    duration = null;
    _currentPlaylist = null;
    _currentTrack = null;
    _audioSession?.setActive(false);
    notifyListeners();
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
      return _currentPlaylist!.tracks[index].uri == uri;
    } catch (e) {
      return false;
    }
  }

  @override
  dispose() {
    _durationStreamListener?.cancel();
    _playingStreamListener?.cancel();
    _audioInterruptionEventListener?.cancel();
    _positionStreamListener?.cancel();
    _audioSession?.setActive(false);
    super.dispose();
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
      if (track != null && await _audioSession?.setActive(true) == true) {
        Uri? parsedUri = Uri.tryParse(track.uri ?? "");
        final tag = MediaItem(
          id: track.id!,
          title: track.name!,
          album: track.album?.name,
          artist: artistsToString(track.artists ?? <ArtistSimple>[]),
          artUri: Uri.parse(imageToUrlString(track.album?.images)),
        );
        if (parsedUri != null && parsedUri.hasAbsolutePath) {
          _currentAudioSource = AudioSource.uri(parsedUri, tag: tag);
          await player
              .setAudioSource(
            _currentAudioSource!,
            preload: true,
          )
              .then((value) async {
            _currentTrack = track;
            notifyListeners();
          });
        }
        final preferences = ref.read(userPreferencesProvider);
        final spotubeTrack = await toSpotubeTrack(
          youtube,
          track,
          preferences.ytSearchFormat,
        );
        if (setTrackUriById(track.id!, spotubeTrack.ytUri)) {
          _currentAudioSource =
              AudioSource.uri(Uri.parse(spotubeTrack.ytUri), tag: tag);
          await player
              .setAudioSource(
            _currentAudioSource!,
            preload: true,
          )
              .then((value) {
            _currentTrack = spotubeTrack;
            notifyListeners();
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
}

final playbackProvider = ChangeNotifierProvider<Playback>((ref) {
  final player = ref.watch(audioPlayerProvider);
  final youtube = ref.watch(youtubeProvider);
  return Playback(
    player: player,
    youtube: youtube,
    ref: ref,
  );
});
