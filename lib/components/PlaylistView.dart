import 'package:spotube/provider/Playback.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/TrackButton.dart';
import 'package:spotube/provider/SpotifyDI.dart';

class PlaylistView extends StatefulWidget {
  PlaylistSimple playlist;
  PlaylistView(this.playlist);
  @override
  _PlaylistViewState createState() => _PlaylistViewState();
}

class _PlaylistViewState extends State<PlaylistView> {
  @override
  Widget build(BuildContext context) {
    Playback playback = context.read<Playback>();
    return Consumer<SpotifyDI>(builder: (_, data, __) {
      return Scaffold(
        body: Container(
          child: FutureBuilder<Iterable<Track>>(
              future: data.spotifyApi.playlists
                  .getTracksByPlaylistId(widget.playlist.id)
                  .all(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: const Text("Error occurred"));
                }
                if (!snapshot.hasData) {
                  return const Center(child: const Text("Loading.."));
                }
                List<Track> tracks = snapshot.data!.toList();
                return Column(
                  children: [
                    Row(
                      children: [
                        // nav back
                        const BackButton(),
                        // heart playlist
                        IconButton(
                          icon: const Icon(Icons.favorite_outline_rounded),
                          onPressed: () {},
                        ),
                        // play playlist
                        IconButton(
                          icon: const Icon(Icons.play_arrow_rounded),
                          onPressed: () {
                            playback.setCurrentPlaylist = CurrentPlaylist(
                              tracks: tracks,
                              id: widget.playlist.id!,
                              name: widget.playlist.name!,
                              thumbnail: widget.playlist.images![0].url!,
                            );
                          },
                        ),
                      ],
                    ),
                    Center(
                      child: Text(widget.playlist.name!,
                          style: Theme.of(context).textTheme.headline4),
                    ),
                    Expanded(
                      child: Scrollbar(
                        isAlwaysShown: true,
                        child: ListView.builder(
                            itemCount: tracks.length + 1,
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return Column(
                                  children: [
                                    TrackButton(
                                        index: "#",
                                        trackName: "Title",
                                        artists: ["Artist"],
                                        album: "Album",
                                        playback_time: "Time"),
                                    const Divider()
                                  ],
                                );
                              }
                              Track track = tracks[index - 1];
                              return TrackButton(
                                index: (index - 1).toString(),
                                thumbnail_url: track.album?.images?.last.url ??
                                    "https://i.scdn.co/image/ab67616d00001e02b993cba8ff7d0a8e9ee18d46",
                                trackName: track.name!,
                                artists:
                                    track.artists!.map((e) => e.name!).toList(),
                                album: track.album!.name!,
                                playback_time:
                                    track.duration!.inMinutes.toString(),
                                onTap: () {},
                              );
                            }),
                      ),
                    ),
                  ],
                );
              }),
        ),
      );
    });
  }
}
