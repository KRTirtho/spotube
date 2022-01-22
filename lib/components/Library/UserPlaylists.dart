import 'package:flutter/material.dart' hide Image;
import 'package:provider/provider.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/Playlist/PlaylistCard.dart';
import 'package:spotube/provider/SpotifyDI.dart';

class UserPlaylists extends StatelessWidget {
  const UserPlaylists({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SpotifyDI data = context.watch<SpotifyDI>();

    return FutureBuilder<Iterable<PlaylistSimple>>(
      future: data.spotifyApi.playlists.me.all(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }
        Image image = Image();
        image.height = 300;
        image.width = 300;
        PlaylistSimple likedTracksPlaylist = PlaylistSimple();
        likedTracksPlaylist.name = "Liked Tracks";
        likedTracksPlaylist.type = "playlist";
        likedTracksPlaylist.collaborative = false;
        likedTracksPlaylist.public = false;
        likedTracksPlaylist.id = "user-liked-tracks";
        image.url =
            "https://t.scdn.co/images/3099b3803ad9496896c43f22fe9be8c4.png";
        likedTracksPlaylist.images = [image];
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 20, // gap between adjacent chips
              runSpacing: 20, // gap between lines
              alignment: WrapAlignment.center,
              children: [
                PlaylistCard(likedTracksPlaylist),
                ...snapshot.data!
                    .map((playlist) => PlaylistCard(playlist))
                    .toList(),
              ],
            ),
          ),
        );
      },
    );
  }
}
