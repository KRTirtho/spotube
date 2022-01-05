import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/PlaylistView.dart';
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
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) {
            return PlaylistView(widget.playlist);
          },
        ));
      },
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 200),
        child: Ink(
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                  spreadRadius: 5,
                  color: Theme.of(context).shadowColor)
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // thumbnail of the playlist
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                        imageUrl: widget.playlist.images![0].url!),
                  ),
                  Positioned.directional(
                    textDirection: TextDirection.ltr,
                    bottom: 10,
                    end: 5,
                    child: Builder(builder: (context) {
                      Playback playback = context.watch<Playback>();
                      SpotifyDI data = context.watch<SpotifyDI>();
                      bool isPlaylistPlaying = playback.currentPlaylist !=
                              null &&
                          playback.currentPlaylist!.id == widget.playlist.id;
                      return ElevatedButton(
                        onPressed: () async {
                          if (isPlaylistPlaying) return;

                          List<Track> tracks =
                              (widget.playlist.id != "user-liked-tracks"
                                      ? await data.spotifyApi.playlists
                                          .getTracksByPlaylistId(
                                              widget.playlist.id!)
                                          .all()
                                      : await data.spotifyApi.tracks.me.saved
                                          .all()
                                          .then((tracks) =>
                                              tracks.map((e) => e.track!)))
                                  .toList();

                          playback.setCurrentPlaylist = CurrentPlaylist(
                            tracks: tracks,
                            id: widget.playlist.id!,
                            name: widget.playlist.name!,
                            thumbnail: widget.playlist.images!.first.url!,
                          );
                        },
                        child: Icon(
                          isPlaylistPlaying
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                        ),
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            const CircleBorder(),
                          ),
                          padding: MaterialStateProperty.all(
                            const EdgeInsets.all(16),
                          ),
                        ),
                      );
                    }),
                  )
                ],
              ),
              const SizedBox(height: 5),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                child: Column(
                  children: [
                    Text(
                      widget.playlist.name!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
