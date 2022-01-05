import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:spotube/components/PlayerControls.dart';
import 'package:spotube/provider/Playback.dart';
import 'package:flutter/material.dart';
import 'package:mpv_dart/mpv_dart.dart';
import 'package:provider/provider.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/provider/SpotifyDI.dart';

class Player extends StatefulWidget {
  const Player({Key? key}) : super(key: key);

  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  late MPVPlayer player;

  bool _isPlaying = false;
  bool _shuffled = false;
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
        if (kDebugMode) {
          print("[PLAYER]: $e");
        }
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
        if (data["property"] == "media-title" && data["value"] != null) {
          var containsYtdl = (data["value"] as String).contains("ytsearch:");
          if (containsYtdl) {
            var props = (data["value"] as String).split("-");
            var mediaTitle = props.last.trim();
            var mediaArtists = props.first.split("ytsearch:").last.trim();
            setState(() {
              _isPlaying = true;
            });

            var matchedTracks = playback.currentPlaylist?.tracks.where(
                  (track) {
                    return track.name?.replaceAll("-", " ") == mediaTitle &&
                        artistsToString(track.artists ?? []) == mediaArtists;
                  },
                ) ??
                [];
            if (matchedTracks.isNotEmpty) {
              playback.setCurrentTrack = matchedTracks.first;
            }
          }
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
    try {
      if (player.isRunning() && playlist.id != _currentPlaylistId) {
        var playlistPath = "/tmp/playlist-${playlist.id}.txt";
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

  String artistsToString(List<Artist> artists) {
    return artists.map((e) => e.name?.replaceAll(",", " ")).join(", ");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor,
      child: Consumer<Playback>(
        builder: (context, playback, widget) {
          if (playback.currentPlaylist != null) {
            playPlaylist(playback.currentPlaylist!);
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
