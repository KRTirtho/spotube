import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/Shared/DownloadTrackButton.dart';
import 'package:spotube/components/Player/PlayerControls.dart';
import 'package:spotube/helpers/artists-to-clickable-artists.dart';
import 'package:spotube/helpers/image-to-url-string.dart';
import 'package:spotube/helpers/search-youtube.dart';
import 'package:spotube/provider/Playback.dart';
import 'package:flutter/material.dart';
import 'package:spotube/provider/SpotifyDI.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class Player extends ConsumerStatefulWidget {
  const Player({Key? key}) : super(key: key);

  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends ConsumerState<Player> with WidgetsBindingObserver {
  late AudioPlayer player;
  bool _isPlaying = false;
  bool _shuffled = false;
  Duration? _duration;

  String? _currentTrackId;

  double _volume = 0;

  late YoutubeExplode youtube;

  @override
  void initState() {
    try {
      super.initState();
      player = AudioPlayer();
      youtube = YoutubeExplode();

      WidgetsBinding.instance?.addObserver(this);
      WidgetsBinding.instance?.addPostFrameCallback(_init);
    } catch (e, stack) {
      print("[Player.initState()] $e");
      print(stack);
    }
  }

  _init(Duration timeStamp) async {
    try {
      setState(() {
        _volume = player.volume;
      });
      player.playingStream.listen((playing) async {
        setState(() {
          _isPlaying = playing;
        });
      });

      player.durationStream.listen((duration) async {
        if (duration != null) {
          // Actually things doesn't work all the time as they were
          // described. So instead of listening to a `playback.ready`
          // stream, it has to listen to duration stream since duration
          // is always added to the Stream sink after all icyMetadata has
          // been loaded thus indicating buffering started
          if (duration != Duration.zero && duration != _duration) {
            // this line is for prev/next or already playing playlist
            if (player.playing) await player.pause();
            await player.play();
          }
          setState(() {
            _duration = duration;
          });
        }
      });

      player.processingStateStream.listen((event) async {
        try {
          if (event == ProcessingState.completed && _currentTrackId != null) {
            _movePlaylistPositionBy(1);
          }
        } catch (e, stack) {
          print("[PrecessingStateStreamListener] $e");
          print(stack);
        }
      });
    } catch (e) {
      print("[Player._init()]: $e");
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    player.dispose();
    youtube.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // Release the player's resources when not in use. We use "stop" so that
      // if the app resumes later, it will still remember what position to
      // resume from.
      player.stop();
    }
  }

  void _movePlaylistPositionBy(int pos) {
    Playback playback = ref.read(playbackProvider);
    if (playback.currentTrack != null && playback.currentPlaylist != null) {
      int index = playback.currentPlaylist!.trackIds
              .indexOf(playback.currentTrack!.id!) +
          pos;

      var safeIndex = index > playback.currentPlaylist!.trackIds.length - 1
          ? 0
          : index < 0
              ? playback.currentPlaylist!.trackIds.length
              : index;
      Track? track =
          playback.currentPlaylist!.tracks.asMap().containsKey(safeIndex)
              ? playback.currentPlaylist!.tracks.elementAt(safeIndex)
              : null;
      if (track != null) {
        playback.setCurrentTrack = track;
        setState(() {
          _duration = null;
        });
      }
    }
  }

  Future _playTrack(Track currentTrack, Playback playback) async {
    try {
      if (currentTrack.id != _currentTrackId) {
        Uri? parsedUri = Uri.tryParse(currentTrack.uri ?? "");
        if (parsedUri != null && parsedUri.hasAbsolutePath) {
          await player
              .setAudioSource(
            AudioSource.uri(parsedUri),
            preload: true,
          )
              .then((value) async {
            setState(() {
              _currentTrackId = currentTrack.id;
              if (_duration != null) {
                _duration = value;
              }
            });
          });
        }
        var ytTrack = await toYoutubeTrack(youtube, currentTrack);
        if (playback.setTrackUriById(currentTrack.id!, ytTrack.uri!)) {
          await player
              .setAudioSource(AudioSource.uri(Uri.parse(ytTrack.uri!)))
              .then((value) {
            setState(() {
              _currentTrackId = currentTrack.id;
            });
          });
        }
      }
    } catch (e, stack) {
      print("[Player._playTrack()] $e");
      print(stack);
    }
  }

  _onNext() async {
    try {
      await player.pause();
      await player.seek(Duration.zero);
      _movePlaylistPositionBy(1);
      print("ON NEXT");
    } catch (e, stack) {
      print("[PlayerControls.onNext()] $e");
      print(stack);
    }
  }

  _onPrevious() async {
    try {
      await player.pause();
      await player.seek(Duration.zero);
      _movePlaylistPositionBy(-1);
    } catch (e, stack) {
      print("[PlayerControls.onPrevious()] $e");
      print(stack);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor,
      child: Consumer(
        builder: (context, ref, widget) {
          Playback playback = ref.watch(playbackProvider);
          if (playback.currentPlaylist != null &&
              playback.currentTrack != null) {
            _playTrack(playback.currentTrack!, playback);
          }

          String? albumArt = imageToUrlString(
            playback.currentTrack?.album?.images,
            index: (playback.currentTrack?.album?.images?.length ?? 1) - 1,
          );

          return Material(
            type: MaterialType.transparency,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (albumArt != null)
                  CachedNetworkImage(
                    imageUrl: albumArt,
                    maxHeightDiskCache: 50,
                    maxWidthDiskCache: 50,
                    placeholder: (context, url) {
                      return Container(
                        height: 50,
                        width: 50,
                        color: Colors.green[400],
                      );
                    },
                  ),
                //  title of the currently playing track
                Flexible(
                  flex: 1,
                  child: Column(
                    children: [
                      Text(
                        playback.currentTrack?.name ?? "Not playing",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      artistsToClickableArtists(
                        playback.currentTrack?.artists ?? [],
                        mainAxisAlignment: MainAxisAlignment.center,
                      )
                    ],
                  ),
                ),
                // controls
                Flexible(
                  flex: 3,
                  child: PlayerControls(
                    positionStream: player.positionStream,
                    isPlaying: _isPlaying,
                    duration: _duration ?? Duration.zero,
                    shuffled: _shuffled,
                    onNext: _onNext,
                    onPrevious: _onPrevious,
                    onPause: () async {
                      try {
                        await player.pause();
                      } catch (e, stack) {
                        print("[PlayerControls.onPause()] $e");
                        print(stack);
                      }
                    },
                    onPlay: () async {
                      try {
                        await player.play();
                      } catch (e, stack) {
                        print("[PlayerControls.onPlay()] $e");
                        print(stack);
                      }
                    },
                    onSeek: (value) async {
                      try {
                        await player.seek(Duration(seconds: value.toInt()));
                      } catch (e, stack) {
                        print("[PlayerControls.onSeek()] $e");
                        print(stack);
                      }
                    },
                    onShuffle: () async {
                      if (playback.currentTrack == null ||
                          playback.currentPlaylist == null) return;
                      try {
                        if (!_shuffled) {
                          playback.currentPlaylist!.shuffle();
                          setState(() {
                            _shuffled = true;
                          });
                        } else {
                          playback.currentPlaylist!.unshuffle();
                          setState(() {
                            _shuffled = false;
                          });
                        }
                      } catch (e, stack) {
                        print("[PlayerControls.onShuffle()] $e");
                        print(stack);
                      }
                    },
                    onStop: () async {
                      try {
                        await player.pause();
                        await player.seek(Duration.zero);
                        setState(() {
                          _isPlaying = false;
                          _currentTrackId = null;
                          _duration = null;
                          _shuffled = false;
                        });
                        playback.reset();
                      } catch (e, stack) {
                        print("[PlayerControls.onStop()] $e");
                        print(stack);
                      }
                    },
                  ),
                ),
                // add to saved tracks
                Expanded(
                  flex: 1,
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    runAlignment: WrapAlignment.center,
                    children: [
                      Container(
                        height: 20,
                        constraints: const BoxConstraints(maxWidth: 200),
                        child: Slider.adaptive(
                          value: _volume,
                          onChanged: (value) async {
                            try {
                              await player.setVolume(value).then((_) {
                                setState(() {
                                  _volume = value;
                                });
                              });
                            } catch (e, stack) {
                              print("[VolumeSlider.onChange()] $e");
                              print(stack);
                            }
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          DownloadTrackButton(
                            track: playback.currentTrack,
                          ),
                          Consumer(builder: (context, ref, widget) {
                            SpotifyApi spotifyApi = ref.watch(spotifyProvider);
                            return FutureBuilder<bool>(
                                future: playback.currentTrack?.id != null
                                    ? spotifyApi.tracks.me
                                        .containsOne(playback.currentTrack!.id!)
                                    : Future.value(false),
                                initialData: false,
                                builder: (context, snapshot) {
                                  bool isLiked = snapshot.data ?? false;
                                  return IconButton(
                                      icon: Icon(
                                        !isLiked
                                            ? Icons.favorite_outline_rounded
                                            : Icons.favorite_rounded,
                                        color: isLiked ? Colors.green : null,
                                      ),
                                      onPressed: () {
                                        if (!isLiked &&
                                            playback.currentTrack?.id != null) {
                                          spotifyApi.tracks.me
                                              .saveOne(
                                                  playback.currentTrack!.id!)
                                              .then((value) => setState(() {}));
                                        }
                                      });
                                });
                          }),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
