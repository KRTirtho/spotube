import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/Shared/DownloadTrackButton.dart';
import 'package:spotube/components/Player/PlayerControls.dart';
import 'package:spotube/helpers/artists-to-clickable-artists.dart';
import 'package:spotube/helpers/image-to-url-string.dart';
import 'package:spotube/helpers/search-youtube.dart';
import 'package:spotube/models/LocalStorageKeys.dart';
import 'package:spotube/provider/Playback.dart';
import 'package:flutter/material.dart';
import 'package:spotube/provider/SpotifyDI.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class Player extends HookConsumerWidget {
  const Player({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final _isPlaying = useState(false);
    final _shuffled = useState(false);
    final _volume = useState(0.0);
    final _duration = useState<Duration?>(null);
    final _currentTrackId = useState<String?>(null);

    final AudioPlayer player = useMemoized(() => AudioPlayer(), []);
    final YoutubeExplode youtube = useMemoized(() => YoutubeExplode(), []);
    final Future<SharedPreferences> future =
        useMemoized(SharedPreferences.getInstance);
    final AsyncSnapshot<SharedPreferences?> localStorage =
        useFuture(future, initialData: null);

    var _movePlaylistPositionBy = useCallback((int pos) {
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
          _duration.value = null;
        }
      }
    }, [_duration]);

    useEffect(() {
      var playingStreamListener = player.playingStream.listen((playing) async {
        _isPlaying.value = playing;
      });

      var durationStreamListener =
          player.durationStream.listen((duration) async {
        if (duration != null) {
          // Actually things doesn't work all the time as they were
          // described. So instead of listening to a `playback.ready`
          // stream, it has to listen to duration stream since duration
          // is always added to the Stream sink after all icyMetadata has
          // been loaded thus indicating buffering started
          if (duration != Duration.zero && duration != _duration.value) {
            // this line is for prev/next or already playing playlist
            if (player.playing) await player.pause();
            await player.play();
          }
          _duration.value = duration;
        }
      });

      var processingStateStreamListener =
          player.processingStateStream.listen((event) async {
        try {
          if (event == ProcessingState.completed &&
              _currentTrackId.value != null) {
            _movePlaylistPositionBy(1);
          }
        } catch (e, stack) {
          print("[PrecessingStateStreamListener] $e");
          print(stack);
        }
      });
      return () {
        playingStreamListener.cancel();
        durationStreamListener.cancel();
        processingStateStreamListener.cancel();
        player.dispose();
        youtube.close();
      };
    }, []);

    useEffect(() {
      if (localStorage.hasData) {
        _volume.value = localStorage.data?.getDouble(LocalStorageKeys.volume) ??
            player.volume;
      }
    }, [localStorage.data]);

    var _playTrack = useCallback((Track currentTrack, Playback playback) async {
      try {
        if (currentTrack.id != _currentTrackId.value) {
          Uri? parsedUri = Uri.tryParse(currentTrack.uri ?? "");
          if (parsedUri != null && parsedUri.hasAbsolutePath) {
            await player
                .setAudioSource(
              AudioSource.uri(parsedUri),
              preload: true,
            )
                .then((value) async {
              _currentTrackId.value = currentTrack.id;
              if (_duration.value != null) {
                _duration.value = value;
              }
            });
          }
          var ytTrack = await toYoutubeTrack(youtube, currentTrack);
          if (playback.setTrackUriById(currentTrack.id!, ytTrack.uri!)) {
            await player
                .setAudioSource(AudioSource.uri(Uri.parse(ytTrack.uri!)))
                .then((value) {
              _currentTrackId.value = currentTrack.id;
            });
          }
        }
      } catch (e, stack) {
        print("[Player._playTrack()] $e");
        print(stack);
      }
    }, [player, _currentTrackId, _duration]);

    var _onNext = useCallback(() async {
      try {
        await player.pause();
        await player.seek(Duration.zero);
        _movePlaylistPositionBy(1);
      } catch (e, stack) {
        print("[PlayerControls.onNext()] $e");
        print(stack);
      }
    }, [player]);

    var _onPrevious = useCallback(() async {
      try {
        await player.pause();
        await player.seek(Duration.zero);
        _movePlaylistPositionBy(-1);
      } catch (e, stack) {
        print("[PlayerControls.onPrevious()] $e");
        print(stack);
      }
    }, [player]);

    return Container(
      color: Theme.of(context).backgroundColor,
      child: HookConsumer(
        builder: (context, ref, widget) {
          Playback playback = ref.watch(playbackProvider);
          if (playback.currentPlaylist != null &&
              playback.currentTrack != null) {
            _playTrack(playback.currentTrack!, playback);
          }

          String? albumArt = useMemoized(
            () => imageToUrlString(
              playback.currentTrack?.album?.images,
              index: (playback.currentTrack?.album?.images?.length ?? 1) - 1,
            ),
            [playback.currentTrack?.album?.images],
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
                    isPlaying: _isPlaying.value,
                    duration: _duration.value ?? Duration.zero,
                    shuffled: _shuffled.value,
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
                        if (!_shuffled.value) {
                          playback.currentPlaylist!.shuffle();
                          _shuffled.value = true;
                        } else {
                          playback.currentPlaylist!.unshuffle();
                          _shuffled.value = false;
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
                        _isPlaying.value = false;
                        _currentTrackId.value = null;
                        _duration.value = null;
                        _shuffled.value = false;
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
                          value: _volume.value,
                          onChanged: (value) async {
                            try {
                              await player.setVolume(value).then((_) {
                                _volume.value = value;
                                localStorage.data?.setDouble(
                                  LocalStorageKeys.volume,
                                  value,
                                );
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
                                          spotifyApi.tracks.me.saveOne(
                                              playback.currentTrack!.id!);
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
