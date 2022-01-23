import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/Playlist/PlaylistView.dart';
import 'package:spotube/components/Shared/PlaybuttonCard.dart';
import 'package:spotube/provider/Playback.dart';
import 'package:spotube/provider/SpotifyDI.dart';

class PlaylistCard extends StatefulWidget {
  final PlaylistSimple playlist;
  const PlaylistCard(this.playlist, {Key? key}) : super(key: key);
  @override
  _PlaylistCardState createState() => _PlaylistCardState();
}

class _PlaylistCardState extends State<PlaylistCard> {
  @override
  Widget build(BuildContext context) {
    Playback playback = context.watch<Playback>();
    bool isPlaylistPlaying = playback.currentPlaylist != null &&
        playback.currentPlaylist!.id == widget.playlist.id;
    return PlaybuttonCard(
      title: widget.playlist.name!,
      imageUrl: widget.playlist.images![0].url!,
      isPlaying: isPlaylistPlaying,
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) {
            return PlaylistView(widget.playlist);
          },
        ));
      },
      onPlaybuttonPressed: () async {
        if (isPlaylistPlaying) return;
        SpotifyDI data = context.read<SpotifyDI>();

        List<Track> tracks = (widget.playlist.id != "user-liked-tracks"
                ? await data.spotifyApi.playlists
                    .getTracksByPlaylistId(widget.playlist.id!)
                    .all()
                : await data.spotifyApi.tracks.me.saved
                    .all()
                    .then((tracks) => tracks.map((e) => e.track!)))
            .toList();

        if (tracks.isEmpty) return;

        playback.setCurrentPlaylist = CurrentPlaylist(
          tracks: tracks,
          id: widget.playlist.id!,
          name: widget.playlist.name!,
          thumbnail: widget.playlist.images!.first.url!,
        );
        playback.setCurrentTrack = tracks.first;
      },
    );
  }
}
