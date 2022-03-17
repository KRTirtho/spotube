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
import 'package:spotube/provider/AudioPlayer.dart';
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

  void shuffle() {
    // won't shuffle if already shuffled
    if (_tempTrack == null) {
      _tempTrack = [...tracks];
      tracks.shuffle();
    }
  }

  void unshuffle() {
    // without _tempTracks unshuffling can't be done
    if (_tempTrack != null) {
      tracks = [..._tempTrack!];
      _tempTrack = null;
    }
  }
}

class Playback extends ChangeNotifier {
  CurrentPlaylist? _currentPlaylist;
  Track? _currentTrack;

  // states
  bool _isPlaying = false;
  Duration? _duration;

  // using custom listeners for duration as it changes super quickly
  // which will cause re-renders in components that don't even need it
  // thus only allowing to listen to change in duration through only
  // a listener function
  List<Function(Duration?)> _durationListeners = [];

  // listeners
  StreamSubscription<bool>? _playingStreamListener;
  StreamSubscription<Duration?>? _durationStreamListener;
  StreamSubscription<ProcessingState>? _processingStateStreamListener;
  StreamSubscription<AudioInterruptionEvent>? _audioInterruptionEventListener;

  AudioPlayer player;
  YoutubeExplode youtube;
  AudioSession? _audioSession;
  Playback({
    required this.player,
    required this.youtube,
    CurrentPlaylist? currentPlaylist,
    Track? currentTrack,
  })  : _currentPlaylist = currentPlaylist,
        _currentTrack = currentTrack {
    _playingStreamListener = player.playingStream.listen(
      (playing) {
        _isPlaying = playing;
        notifyListeners();
      },
    );

    _durationStreamListener = player.durationStream.listen((duration) async {
      if (duration != null) {
        // Actually things doesn't work all the time as they were
        // described. So instead of listening to a `_ready`
        // stream, it has to listen to duration stream since duration
        // is always added to the Stream sink after all icyMetadata has
        // been loaded thus indicating buffering started
        if (duration != Duration.zero && duration != _duration) {
          // this line is for prev/next or already playing playlist
          if (player.playing) await player.pause();
          await player.play();
        }
        _duration = duration;
        _callAllDurationListeners(duration);
        // for avoiding unnecessary re-renders in other components that
        // doesn't need duration
      }
    });

    _processingStateStreamListener =
        player.processingStateStream.listen((event) async {
      try {
        if (event == ProcessingState.completed && _currentTrack?.id != null) {
          movePlaylistPositionBy(1);
        }
      } catch (e, stack) {
        print("[PrecessingStateStreamListener] $e");
        print(stack);
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

  CurrentPlaylist? get currentPlaylist => _currentPlaylist;
  Track? get currentTrack => _currentTrack;
  bool get isPlaying => _isPlaying;

  /// this duration field is almost static & changes occasionally
  ///
  /// If you want realtime duration with state-update/re-render
  /// use custom state & the [addDurationChangeListener] function to do so
  Duration? get duration => _duration;

  _callAllDurationListeners(Duration? arg) {
    for (var listener in _durationListeners) {
      listener(arg);
    }
  }

  void addDurationChangeListener(void Function(Duration? duration) listener) {
    _durationListeners.add(listener);
  }

  void removeDurationChangeListener(
      void Function(Duration? duration) listener) {
    _durationListeners =
        _durationListeners.where((p) => p != listener).toList();
  }

  set setCurrentTrack(Track track) {
    _currentTrack = track;
    notifyListeners();
  }

  set setCurrentPlaylist(CurrentPlaylist playlist) {
    _currentPlaylist = playlist;
    notifyListeners();
  }

  void reset() {
    _isPlaying = false;
    _duration = null;
    _callAllDurationListeners(null);
    _currentPlaylist = null;
    _currentTrack = null;
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
    _processingStateStreamListener?.cancel();
    _durationStreamListener?.cancel();
    _playingStreamListener?.cancel();
    _audioInterruptionEventListener?.cancel();
    _audioSession?.setActive(false);
    super.dispose();
  }

  movePlaylistPositionBy(int pos) {
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
        _duration = null;
        _callAllDurationListeners(null);
        _currentTrack = track;
        notifyListeners();
        // starts to play the newly entered next/prev track
        startPlaying();
      }
    }
  }

  Future<void> startPlaying([Track? track]) async {
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
          await player
              .setAudioSource(
            AudioSource.uri(parsedUri, tag: tag),
            preload: true,
          )
              .then((value) async {
            _currentTrack = track;
            _duration = value;
            _callAllDurationListeners(value);
            notifyListeners();
          });
        }
        final ytTrack = await toYoutubeTrack(youtube, track);
        if (setTrackUriById(track.id!, ytTrack.uri!)) {
          await player
              .setAudioSource(
            AudioSource.uri(Uri.parse(ytTrack.uri!), tag: tag),
            preload: true,
          )
              .then((value) {
            _currentTrack = track;
            notifyListeners();
          });
        }
      }
    } catch (e, stack) {
      print("[Playback.startPlaying] $e");
      print(stack);
    }
  }
}

final playbackProvider = ChangeNotifierProvider<Playback>((ref) {
  final player = ref.watch(audioPlayerProvider);
  final youtube = ref.watch(youtubeProvider);
  return Playback(player: player, youtube: youtube);
});
