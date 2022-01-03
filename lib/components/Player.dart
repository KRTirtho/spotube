import 'dart:io';

import 'package:spotube/components/PlayerControls.dart';
import 'package:spotube/provider/Playback.dart';
import 'package:flutter/material.dart';
import 'package:mpv_dart/mpv_dart.dart';
import 'package:provider/provider.dart';
import 'package:spotify/spotify.dart';

class Player extends StatefulWidget {
  const Player({Key? key}) : super(key: key);

  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  late MPVPlayer player;

  bool _isPlaying = false;
  String? _mediaTitle;
  String? _mediaArtists;
  double _duration = 0;

  String? _currentPlaylistId;

  double _volume = 0;
  @override
  void initState() {
    player = MPVPlayer(
      // verbose: true,
      // debug: true,
      audioOnly: true,
      mpvArgs: [
        "--ytdl-raw-options-set=format=140,http-chunk-size=300000",
        "--script-opts=ytdl_hook-ytdl_path=yt-dlp",
      ],
    );

    (() async {
      try {
        await player.start();
        double volume = await player.getProperty<double>("volume");
        setState(() {
          _volume = volume / 100;
        });
      } catch (e) {
        print("[PLAYER]: $e");
      }
    })();

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

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      player.on(MPVEvents.status, null, (ev, _) async {
        Map data = ev.eventData as Map;
        Playback playback = context.read<Playback>();
        print("[DATA]: $data");
        if (data["property"] == "media-title" && data["value"] != null) {
          var props = (data["value"] as String).split("-");
          setState(() {
            _isPlaying = true;
            _mediaTitle = props.last.replaceAll(
              RegExp(
                "(official|video|lyric|[(){}\\[\\]\\|])",
                caseSensitive: false,
              ),
              "",
            );
            _mediaArtists = props.first;
          });
        }
        if (data["property"] == "duration" && data["value"] != null) {
          setState(() {
            _duration = data["value"];
          });
        }
      });
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Playback playback = context.read<Playback>();

    String? prevTrackName = playback.currentTrack?.name;
    String prevTrackArtists =
        artistsToString(playback.currentTrack?.artists ?? []);

    if (playback.currentPlaylist != null &&
        playback.currentPlaylist!.tracks.isNotEmpty &&
        prevTrackName != _mediaTitle &&
        prevTrackArtists != _mediaArtists) {
      var tracks = playback.currentPlaylist?.tracks.where((track) {
            return _mediaTitle == track.name! &&
                artistsToString(track.artists ?? []) == _mediaTitle;
          }) ??
          [];
      if (tracks.isNotEmpty) {
        playback.setCurrentTrack = tracks.first;
      }
    }
  }

  @override
  void dispose() {
    player.removeAllByEvent(MPVEvents.paused);
    player.removeAllByEvent(MPVEvents.resumed);
    player.removeAllByEvent(MPVEvents.status);
    super.dispose();
  }

  String playlistToStr(CurrentPlaylist playlist) {
    return playlist.tracks.map((track) {
      return "ytdl://ytsearch:${artistsToString(track.artists ?? [])} - ${track.name?.replaceAll("-", " ")}";
    }).join("\n");
  }

  Future playPlaylist(CurrentPlaylist playlist) async {
    if (player.isRunning() && playlist.id != _currentPlaylistId) {
      var playlistPath = "/tmp/playlist-${playlist.id}.txt";
      File file = File(playlistPath);
      var newPlaylist = playlistToStr(playlist);

      print("😃PLAYING PLAYLIST😃");
      if (!await file.exists()) {
        await file.create();
      }

      await file.writeAsString(newPlaylist);

      await player.loadPlaylist(playlistPath);
      setState(() {
        _currentPlaylistId = playlist.id;
      });
    }
  }

  String artistsToString(List<Artist> artists) {
    return artists.map((e) => e.name?.replaceAll(",", " ")).join(", ");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Consumer<Playback>(
        builder: (context, playback, widget) {
          if (playback.currentPlaylist != null) {
            playPlaylist(playback.currentPlaylist!);
          }

          return Material(
            type: MaterialType.transparency,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //  title of the currently playing track
                Flexible(
                  flex: 1,
                  child: Column(
                    children: [
                      Text(
                        _mediaTitle ?? "Not playing",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(_mediaArtists ?? "")
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
                    onStop: () {
                      setState(() {
                        _isPlaying = false;
                        _currentPlaylistId = null;
                        _mediaArtists = null;
                        _mediaTitle = null;
                        _duration = 0;
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
                      IconButton(
                          icon: const Icon(Icons.favorite_outline_rounded),
                          onPressed: () {}),
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
