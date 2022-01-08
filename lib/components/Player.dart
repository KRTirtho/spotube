import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/PlayerControls.dart';
import 'package:spotube/helpers/artist-to-string.dart';
import 'package:spotube/models/GlobalKeyActions.dart';
import 'package:spotube/provider/Playback.dart';
import 'package:flutter/material.dart';
import 'package:mpv_dart/mpv_dart.dart';
import 'package:provider/provider.dart';
import 'package:spotube/provider/PlayerDI.dart';
import 'package:spotube/provider/SpotifyDI.dart';

class Player extends StatefulWidget {
  const Player({Key? key}) : super(key: key);

  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  bool _isPlaying = false;
  bool _shuffled = false;
  double _duration = 0;

  String? _currentPlaylistId;

  double _volume = 0;

  List<HotKey> _hotKeys = [];

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      try {
        MPVPlayer player = context.read<PlayerDI>().player;
        if (!player.isRunning()) {
          await player.start();
        }
        double volume = await player.getProperty<double>("volume");
        setState(() {
          _volume = volume / 100;
        });
        player.on(MPVEvents.paused, null, (ev, context) {
          setState(() {
            _isPlaying = false;
          });
        });

        player.on(MPVEvents.resumed, null, (ev, context) {
          setState(() {
            _isPlaying = true;
          });
        });

        player.on(MPVEvents.status, null, (ev, _) async {
          Map data = ev.eventData as Map;
          print(
              "\n======================\nEVENT $data\n=======================\n");
          Playback playback = context.read<Playback>();

          // that means a new playlist have been added
          if (data["property"] == "playlist-count" && data["value"] > 0) {
            var playlist = await player.getProperty("playlist");
          }

          if (data["property"] == "media-title" && data["value"] != null) {
            // var containsYtdl = (data["value"] as String).contains("ytsearch:");
            // if (containsYtdl) {
            //   var props = (data["value"] as String).split("-");
            //   var mediaTitle = props.last.trim();
            //   var mediaArtists = props.first.split("ytsearch:").last.trim();
            //   setState(() {
            //     _isPlaying = true;
            //   });

            //   var matchedTracks = playback.currentPlaylist?.tracks.where(
            //         (track) {
            //           return track.name?.replaceAll("-", " ") == mediaTitle &&
            //               artistsToString(track.artists ?? []) == mediaArtists;
            //         },
            //       ) ??
            //       [];
            //   if (matchedTracks.isNotEmpty) {
            //     playback.setCurrentTrack = matchedTracks.first;
            //   }
            // }
            int playlistCurrentPos;
            if (_shuffled) {
              await player.unshuffle();
              playlistCurrentPos = await player.getPlaylistPosition();
              await player.shuffle();
            } else {
              playlistCurrentPos = await player.getPlaylistPosition();
            }
            print("${data["value"]} $playlistCurrentPos");
            Track? track =
                playback.currentPlaylist?.tracks.elementAt(playlistCurrentPos);
            if (track != null) {
              setState(() {
                _isPlaying = true;
              });
              playback.setCurrentTrack = track;
            }
          }
          if (data["property"] == "duration" && data["value"] != null) {
            setState(() {
              _duration = data["value"];
            });
          }
          playOrPause(key) async {
            _isPlaying ? await player.pause() : await player.play();
          }

          List<GlobalKeyActions> keyWithActions = [
            GlobalKeyActions(
              HotKey(KeyCode.space, scope: HotKeyScope.inapp),
              playOrPause,
            ),
            GlobalKeyActions(
              HotKey(KeyCode.mediaPlayPause),
              playOrPause,
            ),
            GlobalKeyActions(HotKey(KeyCode.mediaTrackNext), (key) async {
              await player.next();
            }),
            GlobalKeyActions(HotKey(KeyCode.mediaTrackPrevious), (key) async {
              await player.prev();
            }),
            GlobalKeyActions(HotKey(KeyCode.mediaStop), (key) async {
              await player.stop();
              setState(() {
                _isPlaying = false;
                _currentPlaylistId = null;
                _duration = 0;
                _shuffled = false;
              });
              playback.reset();
            })
          ];

          await Future.wait(
            keyWithActions.map((e) {
              return hotKeyManager.register(
                e.hotKey,
                keyDownHandler: e.onKeyDown,
              );
            }),
          );
        });
      } catch (e) {
        if (kDebugMode) {
          print("[PLAYER]: $e");
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() async {
    MPVPlayer player = context.read<PlayerDI>().player;
    player.removeAllByEvent(MPVEvents.paused);
    player.removeAllByEvent(MPVEvents.resumed);
    player.removeAllByEvent(MPVEvents.status);
    await Future.wait(_hotKeys.map((e) => hotKeyManager.unregister(e)));
    super.dispose();
  }

  String playlistToStr(CurrentPlaylist playlist) {
    var tracks = playlist.tracks.map((track) {
      var artists = artistsToString(track.artists ?? []);
      var title = track.name?.replaceAll("-", " ");

      return "ytdl://ytsearch:$artists - $title";
    }).toList();

    return tracks.join("\n");
  }

  Future playPlaylist(MPVPlayer player, CurrentPlaylist playlist) async {
    try {
      if (player.isRunning() && playlist.id != _currentPlaylistId) {
        var playlistPath = "/tmp/playlist-${playlist.id}.json";
        File file = File(playlistPath);
        var newPlaylist = playlistToStr(playlist);

        if (!await file.exists()) {
          await file.create();
        }

        await file.writeAsString(newPlaylist);

        await player.loadPlaylist(playlistPath);
        setState(() {
          _currentPlaylistId = playlist.id;
          _shuffled = false;
        });
      }
    } catch (e, stackTrace) {
      print("[Player]: $e");
      print(stackTrace);
    }
  }

  @override
  Widget build(BuildContext context) {
    MPVPlayer player = context.watch<PlayerDI>().player;

    return Container(
      color: Theme.of(context).backgroundColor,
      child: Consumer<Playback>(
        builder: (context, playback, widget) {
          if (playback.currentPlaylist != null) {
            playPlaylist(player, playback.currentPlaylist!);
          }

          String? albumArt = playback.currentTrack?.album?.images?.last.url;

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
                      Text(
                          artistsToString(playback.currentTrack?.artists ?? []))
                    ],
                  ),
                ),
                // controls
                Flexible(
                  flex: 3,
                  child: PlayerControls(
                    player: player,
                    isPlaying: _isPlaying,
                    duration: _duration,
                    shuffled: _shuffled,
                    onShuffle: () {
                      if (!_shuffled) {
                        player.shuffle().then(
                              (value) => setState(() {
                                _shuffled = true;
                              }),
                            );
                      } else {
                        player.unshuffle().then(
                              (value) => setState(() {
                                _shuffled = false;
                              }),
                            );
                      }
                    },
                    onStop: () {
                      setState(() {
                        _isPlaying = false;
                        _currentPlaylistId = null;
                        _duration = 0;
                        _shuffled = false;
                      });
                      playback.reset();
                    },
                  ),
                ),
                // add to saved tracks
                Expanded(
                  flex: 1,
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Consumer<SpotifyDI>(builder: (context, data, widget) {
                        return FutureBuilder<bool>(
                            future: playback.currentTrack?.id != null
                                ? data.spotifyApi.tracks.me
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
                                      data.spotifyApi.tracks.me
                                          .saveOne(playback.currentTrack!.id!)
                                          .then((value) => setState(() {}));
                                    }
                                  });
                            });
                      }),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 200),
                        child: Slider.adaptive(
                          value: _volume,
                          onChanged: (value) {
                            player.volume(value * 100).then((_) {
                              setState(() {
                                _volume = value;
                              });
                            });
                          },
                        ),
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
