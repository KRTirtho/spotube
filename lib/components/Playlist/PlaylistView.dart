import 'package:spotube/components/Shared/PageWindowTitleBar.dart';
import 'package:spotube/components/Shared/TracksTableView.dart';
import 'package:spotube/provider/Playback.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/provider/SpotifyDI.dart';

class PlaylistView extends StatefulWidget {
  final PlaylistSimple playlist;
  const PlaylistView(this.playlist, {Key? key}) : super(key: key);
  @override
  _PlaylistViewState createState() => _PlaylistViewState();
}

class _PlaylistViewState extends State<PlaylistView> {
  playPlaylist(Playback playback, List<Track> tracks, {Track? currentTrack}) {
    currentTrack ??= tracks.first;
    var isPlaylistPlaying = playback.currentPlaylist?.id != null &&
        playback.currentPlaylist?.id == widget.playlist.id;
    if (!isPlaylistPlaying) {
      playback.setCurrentPlaylist = CurrentPlaylist(
        tracks: tracks,
        id: widget.playlist.id!,
        name: widget.playlist.name!,
        thumbnail: widget.playlist.images![0].url!,
      );
      playback.setCurrentTrack = currentTrack;
    } else if (isPlaylistPlaying &&
        currentTrack.id != null &&
        currentTrack.id != playback.currentTrack?.id) {
      playback.setCurrentTrack = currentTrack;
    }
  }

  @override
  Widget build(BuildContext context) {
    Playback playback = context.watch<Playback>();
    var isPlaylistPlaying = playback.currentPlaylist?.id != null &&
        playback.currentPlaylist?.id == widget.playlist.id;
    return Consumer<SpotifyDI>(builder: (_, data, __) {
      return Scaffold(
        body: FutureBuilder<Iterable<Track>>(
            future: widget.playlist.id != "user-liked-tracks"
                ? data.spotifyApi.playlists
                    .getTracksByPlaylistId(widget.playlist.id)
                    .all()
                : data.spotifyApi.tracks.me.saved
                    .all()
                    .then((tracks) => tracks.map((e) => e.track!)),
            builder: (context, snapshot) {
              List<Track> tracks = snapshot.data?.toList() ?? [];
              return Column(
                children: [
                  PageWindowTitleBar(
                    leading: Row(
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
                          icon: Icon(
                            isPlaylistPlaying
                                ? Icons.stop_rounded
                                : Icons.play_arrow_rounded,
                          ),
                          onPressed: snapshot.hasData
                              ? () => playPlaylist(playback, tracks)
                              : null,
                        )
                      ],
                    ),
                  ),
                  Center(
                    child: Text(widget.playlist.name!,
                        style: Theme.of(context).textTheme.headline4),
                  ),
                  snapshot.hasError
                      ? const Center(child: Text("Error occurred"))
                      : !snapshot.hasData
                          ? const Expanded(
                              child: Center(
                                  child: CircularProgressIndicator.adaptive()),
                            )
                          : TracksTableView(
                              tracks,
                              onTrackPlayButtonPressed: (currentTrack) =>
                                  playPlaylist(
                                playback,
                                tracks,
                                currentTrack: currentTrack,
                              ),
                            ),
                ],
              );
            }),
      );
    });
  }
}
