import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/Playlist/PlaylistView.dart';
import 'package:spotube/components/Shared/PlaybuttonCard.dart';
import 'package:spotube/helpers/image-to-url-string.dart';
import 'package:spotube/provider/Playback.dart';
import 'package:spotube/provider/SpotifyDI.dart';

class PlaylistCard extends ConsumerStatefulWidget {
  final PlaylistSimple playlist;
  const PlaylistCard(this.playlist, {Key? key}) : super(key: key);
  @override
  _PlaylistCardState createState() => _PlaylistCardState();
}

class _PlaylistCardState extends ConsumerState<PlaylistCard> {
  @override
  Widget build(BuildContext context) {
    Playback playback = ref.watch(playbackProvider);
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
        SpotifyApi spotifyApi = ref.read(spotifyProvider);

        List<Track> tracks = (widget.playlist.id != "user-liked-tracks"
                ? await spotifyApi.playlists
                    .getTracksByPlaylistId(widget.playlist.id!)
                    .all()
                : await spotifyApi.tracks.me.saved
                    .all()
                    .then((tracks) => tracks.map((e) => e.track!)))
            .toList();

        if (tracks.isEmpty) return;

        playback.setCurrentPlaylist = CurrentPlaylist(
          tracks: tracks,
          id: widget.playlist.id!,
          name: widget.playlist.name!,
          thumbnail: imageToUrlString(widget.playlist.images),
        );
        playback.setCurrentTrack = tracks.first;
      },
    );
  }
}
